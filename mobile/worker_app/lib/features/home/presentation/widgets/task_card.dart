
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/theme/app_decoration.dart';
import '../../../../config/theme/styles.dart';
import '../../../../core/widgets/custom_elevated_button.dart';
import '../../../../core/widgets/custom_image_view.dart';
import '../../../../l10n/app_localizations.dart';
import '../../data/models/task_model.dart';

class TaskCard extends StatelessWidget {
  final TaskModel task;

  const TaskCard({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        borderRadius: AppRadius.card,
        boxShadow: AppShadow.card(Theme.of(context).brightness),
      ),
      child: ClipRRect(
        borderRadius: AppRadius.card,
        child: Stack(
          children: [
            CustomImageView(
              imagePath: task.image,
              fit: BoxFit.cover,
              width: double.infinity,
            ),

            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withValues(alpha: 0.05),
                    Colors.black.withValues(alpha: 0.8),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.all(16.r),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: Styles.textStyle16.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 6.h),

                    Text(
                      task.subtitle,
                      style: Styles.textStyle12.copyWith(color: Colors.white70),
                    ),

                    SizedBox(height: 10.h),

                    CustomElevatedButton(
                      width: 120.w,
                      text: AppLocalizations.of(context)!.book_now,
                      buttonTextStyle: Styles.textStyle12.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      buttonStyle: ElevatedButton.styleFrom(
                        backgroundColor: theme.primary,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: AppRadius.button,
                        ),
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
