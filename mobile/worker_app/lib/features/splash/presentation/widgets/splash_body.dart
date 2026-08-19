import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/constants/api_url_parameters.dart';
import '../../../../config/routes/app_router.dart';
import '../../../../config/theme/styles.dart';
import '../../../../core/session/app_startup.dart';
import '../../../../core/session/login_session.dart';
import '../../../../core/utils/gen/assets.gen.dart';
import '../../../../injection_container.dart';

/// Branded splash + the app's single startup decision point.
///
/// Deterministic routing (fixes the "onboarding on every launch" bug):
///  * onboarding never completed        → Onboarding
///  * onboarding done, no token         → Login
///  * onboarding done, token present    → validate via `/auth/me`
///      - valid                         → Home
///      - genuinely unauthorized (401)  → the Dio interceptor clears the
///                                         session and routes to Login
///      - network/timeout error         → Home anyway (never log the worker
///                                         out over connectivity)
class SplashBody extends StatefulWidget {
  const SplashBody({super.key});

  @override
  State<SplashBody> createState() => _SplashBodyState();
}

class _SplashBodyState extends State<SplashBody>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..forward();

  @override
  void initState() {
    super.initState();
    _decideNextRoute();
  }

  Future<void> _decideNextRoute() async {
    // Minimum on-screen time so the splash never flickers past.
    final minDelay = Future<void>.delayed(const Duration(milliseconds: 1200));

    String target;
    if (!AppStartup.onboardingCompleted) {
      target = AppRouter.kOnboarding;
    } else if (!LoginSession.hasToken) {
      target = AppRouter.kLogin;
    } else {
      target = await _resolveAuthenticatedRoute();
    }

    await minDelay;
    if (!mounted) return;
    // If a 401 already bounced us to Login, don't override it.
    context.go(target);
  }

  /// Best-effort session validation. Returns Home unless the token is proven
  /// invalid (in which case the interceptor has already redirected to Login).
  Future<String> _resolveAuthenticatedRoute() async {
    try {
      await sl<Dio>().get(
        ApiUrlParameters.authMe,
        // Let a 401 fall through to the interceptor (clear + go Login) instead
        // of being swallowed here; any OTHER error must not move the worker.
        options: Options(extra: const {kSkipAuthRedirect: false}),
      );
      return AppRouter.kHome;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        // Interceptor cleared the session and navigated to Login already.
        return AppRouter.kLogin;
      }
      // Network/timeout/server-down: keep the worker signed in.
      return AppRouter.kHome;
    } catch (_) {
      return AppRouter.kHome;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: colors.surface,
      alignment: Alignment.center,
      child: FadeTransition(
        opacity: _controller,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(24.r),
              child: Assets.images.logo.appLogo.image(
                width: 120.w,
                height: 120.w,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              'CleanLink',
              style: Styles.textStyle24.copyWith(
                color: colors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 24.h),
            SizedBox(
              width: 24.w,
              height: 24.w,
              child: CircularProgressIndicator(
                strokeWidth: 2.4,
                valueColor: AlwaysStoppedAnimation<Color>(colors.primary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
