import 'package:flutter/material.dart';
import 'content_item_factory.dart';
import 'content_navigator.dart';
import 'content_section_type.dart';

class ContentListView extends StatelessWidget {
  const ContentListView({
    super.key,
    required this.type,
    required this.items,
  });

  final ContentSectionType type;

  /// Companies / Services ...
  final List<dynamic> items;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(
        vertical: 8,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return ContentItemFactory.buildListItem(
          context,
          type: type,
          item: items[index],
          index: index,
          onTap: () {
            ContentNavigator.openItemDetails(
              context,
              type: type,
              index: index,
            );
          },
        );
      },
    );
  }
}