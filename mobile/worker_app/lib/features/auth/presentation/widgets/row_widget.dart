
import 'package:flutter/material.dart';

import '../../../../config/theme/styles.dart';

class RowWidget extends StatelessWidget {
  const RowWidget({
    required this.text,
    required this.textButton,
    required this.onTap,
    super.key,
  });

  final String text;
  final String textButton;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          text,
          style: Styles.textStyle12
              .copyWith(color: theme.onSurface, fontWeight: FontWeight.w400),
        ),
        TextButton(
          onPressed: onTap,
          child: Text(
            textButton,
            style: Styles.textStyle14
                .copyWith(color: theme.primary, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
