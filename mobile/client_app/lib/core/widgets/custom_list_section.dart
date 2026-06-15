import 'package:flutter/material.dart';
import 'package:client_app/core/widgets/row_title.dart';
import 'section_header.dart';

class CustomListSection extends StatelessWidget {
  const CustomListSection({
    super.key,
    required this.title,
    required this.itemCount,
    required this.itemBuilder,

    /// Required only for horizontal lists
    this.itemExtent,

    this.iconData,
    this.onTitleTap,
    this.isVertical = false,
    this.padding,
    this.separator,
    this.physics,
    this.shrinkWrap = false,
  });

  final String title;
  final int itemCount;
  final Widget Function(BuildContext context, int index) itemBuilder;

  /// Height for horizontal / width for vertical if needed
  final double? itemExtent;

  final IconData? iconData;
  final VoidCallback? onTitleTap;

  final bool isVertical;
  final EdgeInsetsGeometry? padding;
  final Widget? separator;
  final ScrollPhysics? physics;
  final bool shrinkWrap;

  @override
  Widget build(BuildContext context) {
    final list = ListView.separated(
      scrollDirection: isVertical ? Axis.vertical : Axis.horizontal,
      padding: padding,
      physics: physics,
      shrinkWrap: shrinkWrap,
      itemCount: itemCount,
      separatorBuilder: (_, __) {
        if (separator != null) return separator!;

        return SizedBox(
          width: isVertical ? 0 : 10,
          height: isVertical ? 10 : 0,
        );
      },
      itemBuilder: itemBuilder,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        iconData != null
            ? RowTitle(iconData: iconData!, title: title, onTap: onTitleTap)
            : SectionHeader(title: title, onTap: onTitleTap),

        if (isVertical) list else SizedBox(height: itemExtent, child: list),
      ],
    );
  }
}
