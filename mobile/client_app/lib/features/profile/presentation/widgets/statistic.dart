import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/theme/styles.dart';

class Statistic extends StatelessWidget {
  final String title;
  final String value;

  const Statistic({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Text(
          value,
          style: Styles.textStyle14.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.primary,
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          title,
          style: Styles.textStyle11.copyWith(color: theme.onSurfaceVariant),
        ),
      ],
    );
  }
}
