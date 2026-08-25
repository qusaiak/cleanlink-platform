import 'package:flutter/material.dart';

import '../utils/gen/fonts.gen.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.onTap,
    this.padding = const EdgeInsets.all(16.0),
    this.showChevron = true,
  });

  final String title;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final bool showChevron;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: padding,
        child: Row(
          children: [
            _SectionTitleText(title: title),
            const Spacer(),
            if (showChevron)
              const Icon(Icons.chevron_right, color: Colors.white),
          ],
        ),
      ),
    );
  }
}

class _SectionTitleText extends StatelessWidget {
  const _SectionTitleText({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final parts = title.split(' ');
    final firstWord = parts.isNotEmpty ? parts.first : '';
    final rest = parts.length > 1 ? ' ${parts.sublist(1).join(' ')}' : '';

    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: firstWord,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w300,
              fontFamily: FontFamily.poppins,
            ),
          ),
          TextSpan(
            text: rest,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: FontFamily.poppins,
            ),
          ),
        ],
      ),
    );
  }
}
