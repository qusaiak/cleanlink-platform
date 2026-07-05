import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'content_item_factory.dart';
import '../custom_list_section.dart';
import 'content_section.dart';
import 'content_section_type.dart';

class ContentHorizontalList extends StatelessWidget {
  const ContentHorizontalList({
    super.key,
    required this.section,
    this.onItemTap,
    this.onTitleTap,
  });

  final ContentSection section;
  final void Function(int index)? onItemTap;
  final VoidCallback? onTitleTap;

  static final _defaultHeights = <ContentSectionType, double>{
    ContentSectionType.companies: 200.w,
    ContentSectionType.services: 120.w,
    ContentSectionType.categories: 120.w,
    ContentSectionType.regions: 250.w,
    // ContentSectionType.providers: 140,
    ContentSectionType.offers: 200.w,
  };

  static final _defaultWidths = <ContentSectionType, double>{
    ContentSectionType.companies: 200.w,
    ContentSectionType.services: 320.w,
    ContentSectionType.categories: 120.w,
    ContentSectionType.regions: 320.w,
    // ContentSectionType.providers: 140,
    ContentSectionType.offers: 300.w,
  };

  static const _sectionsIcons = <ContentSectionType, IconData>{
    ContentSectionType.companies: Icons.business,
    ContentSectionType.services: Icons.cleaning_services,
    ContentSectionType.categories: Icons.category,
    ContentSectionType.regions: Icons.location_on,
    // ContentSectionType.providers: Icons.person,
    ContentSectionType.offers: Icons.local_offer,
  };

  @override
  Widget build(BuildContext context) {
    final height = _defaultHeights[section.type]!;
    final width = _defaultWidths[section.type]!;
    return CustomListSection(
      title: section.title,
      itemExtent: height,
      itemCount: section.items.length,
      onTitleTap: onTitleTap,
      iconData: _sectionsIcons[section.type],
      isVertical: false,
      itemBuilder: (context, index) {
        final item = section.items[index];

        return SizedBox(
          width: width,
          child: ContentItemFactory.buildListItem(
            context,

            type: section.type,

            item: item,

            index: index,

            onTap: () => onItemTap?.call(item.id),
          ),
        );
      },
    );
  }
}
