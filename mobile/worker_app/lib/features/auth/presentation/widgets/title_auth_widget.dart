
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/theme/styles.dart';

class TitleAuthWidget extends StatelessWidget {
  const TitleAuthWidget(this.pageTitle, {super.key});

  final String pageTitle;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          pageTitle,
          style: Styles.textStyle22.copyWith(color: theme.onSurface),
        ),
        SizedBox(
          height: 20.h,
        ),
      ],
    );
  }
}
