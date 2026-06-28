import 'dart:io';
import 'dart:ui';

import 'package:client_app/core/session/user_session.dart';
import 'package:client_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/theme/styles.dart';
import '../../../../core/utils/functions/helper_functions.dart';
import '../../../../injection_container.dart';
import 'edit_button.dart';
import 'statistic.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return ListenableBuilder(
      listenable: sl<UserSession>(),
      builder: (context, child) {
        final session = sl<UserSession>();
        final fullname = session.fullname ?? 'Guest';
        final email = session.email ?? '';
        final image = session.image;

        return ClipRRect(
          borderRadius: BorderRadius.circular(18.r),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
            child: Container(
              padding: EdgeInsets.all(16.w),
              color: Colors.grey.withValues(alpha: 0.06),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(3.w),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: theme.primary,
                        ),
                        child: CircleAvatar(
                          radius: 30.r,
                          backgroundImage: resolveImage(image),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              fullname,
                              style: Styles.textStyle14.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              email,
                              style: Styles.textStyle11.copyWith(
                                color: theme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const EditButton(),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Statistic(
                        title: AppLocalizations.of(context)!.bookings,
                        value: "12",
                      ),
                      Statistic(
                        title: AppLocalizations.of(context)!.favorites,
                        value: "5",
                      ),
                      Statistic(
                        title: AppLocalizations.of(context)!.reviews,
                        value: "8",
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
