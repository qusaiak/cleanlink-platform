import 'package:flutter/material.dart';
import 'package:client_app/core/widgets/row_title.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'section_header.dart';

class CustomListSection extends StatelessWidget {
  const CustomListSection({
    super.key,
    this.title,
    required this.itemCount,
    required this.itemBuilder,

    this.itemExtent,

    this.iconData,
    this.onTitleTap,
    this.isVertical = false,
    this.padding,
    this.separator,
    this.physics,
    this.shrinkWrap = false,
  });

  final String? title;
  final int itemCount;
  final Widget Function(BuildContext context, int index) itemBuilder;

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

    return title != null
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              iconData != null
                  ? RowTitle(
                      iconData: iconData!,
                      title: title!,
                      onTap: onTitleTap,
                      padding: EdgeInsets.all(8.h),
                    )
                  : SectionHeader(title: title!, onTap: onTitleTap),

              if (isVertical)
                list
              else
                SizedBox(height: itemExtent, child: list),
            ],
          )
        : isVertical
        ? list
        : SizedBox(height: itemExtent, child: list);
  }
}
