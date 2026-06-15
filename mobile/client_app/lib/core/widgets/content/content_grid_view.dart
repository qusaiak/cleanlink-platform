import 'package:flutter/material.dart';

import 'content_item_factory.dart';
import 'content_navigator.dart';
import 'content_section_type.dart';

class ContentGridView extends StatelessWidget {
  const ContentGridView({super.key, required this.type, required this.items});

  final ContentSectionType type;
  final List<String> items;

  double get _childAspectRatio =>
      (type == ContentSectionType.providers || type == ContentSectionType.categories)
      ? 1.0
      : 2 / 3;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
      itemCount: items.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 8,
        crossAxisSpacing: 2,
        childAspectRatio: _childAspectRatio,
      ),
      itemBuilder: (context, index) => ContentItemFactory.build(
        type: type,
        imagePath: items[index],
        index: index,
        onTap: () =>
            ContentNavigator.openItemDetails(context, type: type, index: index),
      ),
    );
  }
}
