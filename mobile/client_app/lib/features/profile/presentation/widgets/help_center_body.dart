import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../config/theme/styles.dart';
import '../../../../l10n/app_localizations.dart';
import 'faq_item.dart';

class HelpCenterBody extends StatelessWidget {
  const HelpCenterBody({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: Column(
          children: [
            Icon(
              Icons.question_answer_outlined,
              size: 90,
              color: theme.primary,
            ),

            SizedBox(height: 12.h),

            Text(
              AppLocalizations.of(context)!.help_center_title,
              style: Styles.textStyle18.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 6.h),

            Text(
              AppLocalizations.of(context)!.help_center_body,
              style: Styles.textStyle12.copyWith(color: Colors.grey),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 30.h),

            const FaqItem(
              question: "How do I book a service?",
              answer:
              "Go to services, choose what you need, and confirm booking.",
            ),
            const FaqItem(
              question: "How can I cancel my booking?",
              answer:
              "You can cancel from your bookings screen before the scheduled time.",
            ),
            const FaqItem(
              question: "How do I change my password?",
              answer: "Go to settings → change password.",
            ),
            const FaqItem(
              question: "What payment methods are supported?",
              answer:
              "We support cash and online payments (coming soon).",
            ),
          ],
        ),
      ),
    );
  }
}