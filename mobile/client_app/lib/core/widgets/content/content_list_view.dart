import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'content_item_factory.dart';
import 'content_navigator.dart';
import 'content_section_type.dart';

class ContentListView extends StatelessWidget {
  const ContentListView({super.key, required this.type, required this.items});

  final ContentSectionType type;

  final List<dynamic> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const Center(child: Text('No results found'));
    }

    return Padding(
      padding: EdgeInsets.only(
        right: 10.w,
        left: 10.w,
        bottom: MediaQuery.of(context).padding.bottom,
      ),
      child: ListView.separated(
        padding: EdgeInsets.zero,

        itemCount: items.length,

        separatorBuilder: (context, index) => const SizedBox(height: 8),

        itemBuilder: (context, index) {
          final item = items[index];

          return ContentItemFactory.buildListItem(
            context,

            type: type,

            item: item,

            index: index,

            onTap: () {
              ContentNavigator.openItemDetails(
                context,
                type: type,
                id: item.id,
              );
            },
          );
        },
      ),
    );
  }
}
