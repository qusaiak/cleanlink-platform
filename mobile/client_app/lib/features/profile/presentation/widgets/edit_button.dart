import 'package:client_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../config/theme/styles.dart';

class EditButton extends StatelessWidget {
  const EditButton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: theme.primary.withOpacity(0.5)),
        ),
        child: Row(
          children: [
            Icon(Icons.edit, size: 16.sp, color: theme.primary),
            SizedBox(width: 4.w),
            Text(
              AppLocalizations.of(context)!.edit,
              style: Styles.textStyle12.copyWith(
                color: theme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}