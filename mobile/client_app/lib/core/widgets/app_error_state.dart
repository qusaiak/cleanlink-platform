import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../l10n/app_localizations.dart';
import '../error/failure.dart';
import 'app_primary_button.dart';

class AppErrorState extends StatelessWidget {
  const AppErrorState({
    super.key,
    required this.onRetry,
    this.failure,
    this.compact = false,
  });

  final Failure? failure;
  final VoidCallback onRetry;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final l = AppLocalizations.of(context)!;
    final type = failure?.type ?? AppFailureType.unknown;
    final content = switch (type) {
      AppFailureType.noInternet => (
        Icons.wifi_off_rounded,
        l.network_no_internet_title,
        l.network_no_internet_description,
      ),
      AppFailureType.timeout => (
        Icons.timer_off_outlined,
        l.network_timeout_title,
        l.network_timeout_description,
      ),
      AppFailureType.server => (
        Icons.cloud_off_outlined,
        l.network_server_title,
        l.network_server_description,
      ),
      _ => (
        Icons.error_outline_rounded,
        l.network_generic_title,
        l.network_generic_description,
      ),
    };

    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: compact ? 20.w : 28.w,
          vertical: 32.h,
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 380.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 58.w,
                height: 58.w,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: colors.primary.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Icon(content.$1, size: 30.sp, color: colors.primary),
              ),
              SizedBox(height: 26.h),
              Text(
                content.$2,
                textAlign: TextAlign.center,
                style: textTheme.headlineSmall?.copyWith(
                  color: colors.onSurface,
                  fontWeight: FontWeight.w700,
                  height: 1.2,
                ),
              ),
              SizedBox(height: 10.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: Text(
                  content.$3,
                  textAlign: TextAlign.center,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colors.onSurfaceVariant,
                    height: 1.55,
                  ),
                ),
              ),
              SizedBox(height: 30.h),
              AppPrimaryButton(label: l.retry, onPressed: onRetry),
            ],
          ),
        ),
      ),
    );
  }
}
