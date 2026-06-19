
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/routes/app_router.dart';
import '../../../../config/theme/colors.dart';
import '../../../../config/theme/styles.dart';
import '../../../../l10n/app_localizations.dart';

class SkipButton extends StatelessWidget {
  const SkipButton({super.key});

  @override
  Widget build(BuildContext context) {

    final router = GoRouter.of(context);
    return Positioned(
      top: 30.0.h,
      right: 20.0.w,
      child: TextButton(
        onPressed: () async {
          // Routing to Login
          // await SharedStorage.set(StorageData.isOnboarding, "true");
          router.go(AppRouter.kLogin);
        },
        child: Text(
          AppLocalizations.of(context)!.skip,
          style: Styles.textStyle16.copyWith(
            color: AppColor.primaryColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
