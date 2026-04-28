import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/theme/colors.dart';
import '../../../../config/theme/styles.dart';
import '../../../../core/utils/functions/validator.dart';
import '../../../../l10n/app_localizations.dart';

class PasswordStrengthIndicator extends StatelessWidget {
  const PasswordStrengthIndicator({super.key, required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (context, value, _) {
        final score = PasswordStrength.score(value.text);
        return _StrengthBar(score: score);
      },
    );
  }
}

class _StrengthBar extends StatelessWidget {
  const _StrengthBar({required this.score});

  final double score;

  Color get _color {
    if (score < 0.4) return const Color(0xFFEF4444);
    if (score < 0.75) return const Color(0xFFF59E0B);
    return AppColor.successColor;
  }

  String _label(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    if (score == 0) return '';
    if (score < 0.4) return l.auth_password_weak;
    if (score < 0.75) return l.auth_password_medium;
    return l.auth_password_strong;
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    var theme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              l.auth_password_strength,
              style: Styles.textStyle12.copyWith(
                color: theme.onSurface.withValues(alpha: 0.55),
              ),
            ),
            const Spacer(),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Text(
                _label(context),
                key: ValueKey(_label(context)),
                style: Styles.textStyle12.copyWith(
                  color: _color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 6.h),
        ClipRRect(
          borderRadius: BorderRadius.circular(8.r),
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: score),
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
            builder: (context, value, _) => LinearProgressIndicator(
              value: value,
              minHeight: 6.h,
              backgroundColor: theme.onSurface.withValues(alpha: 0.06),
              valueColor: AlwaysStoppedAnimation(_color),
            ),
          ),
        ),
      ],
    );
  }
}
