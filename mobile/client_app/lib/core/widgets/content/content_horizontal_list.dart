import 'package:flutter/material.dart';
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

  static const _defaultHeights = <ContentSectionType, double>{
    ContentSectionType.companies: 200,
    ContentSectionType.services: 140,
    ContentSectionType.categories: 200,
    ContentSectionType.regions: 140,
    ContentSectionType.providers: 140,
    ContentSectionType.offers: 140,
  };

  static const _sectionsIcons = <ContentSectionType, IconData>{
    ContentSectionType.companies: Icons.business,
    ContentSectionType.services: Icons.cleaning_services,
    ContentSectionType.categories: Icons.category,
    ContentSectionType.regions: Icons.location_on,
    ContentSectionType.providers: Icons.person,
    ContentSectionType.offers: Icons.local_offer,
  };

  @override
  Widget build(BuildContext context) {
    final height = section.itemHeight ?? _defaultHeights[section.type]!;
    return CustomListSection(
      title: section.title,
      itemExtent: height,
      itemCount: section.items.length,
      onTitleTap: onTitleTap,
      iconData: _sectionsIcons[section.type],
      isVertical: false,
      itemBuilder: (context, index) => ContentItemFactory.build(
        type: section.type,
        imagePath: section.items[index],
        index: index,
        itemWidth:
            (section.type == ContentSectionType.providers ||
                section.type == ContentSectionType.categories)
            ? height
            : null,
        onTap: onItemTap == null ? null : () => onItemTap!(index),
      ),
    );
  }
}
