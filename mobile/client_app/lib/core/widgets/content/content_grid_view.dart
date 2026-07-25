import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../l10n/app_localizations.dart';
import '../app_empty_state.dart';
import 'content_item_factory.dart';
import 'content_navigator.dart';
import 'content_section_type.dart';

class ContentGridView extends StatelessWidget {
  const ContentGridView({super.key, required this.type, required this.items});

  final ContentSectionType type;

  final List<dynamic> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Center(
        child: AppEmptyState(
          icon: Icons.search_off_rounded,
          title: AppLocalizations.of(context)!.search_no_results,
        ),
      );
    }
    return Padding(
      padding: EdgeInsets.only(
        right: 10.w,
        left: 10.w,
        bottom: MediaQuery.of(context).padding.bottom,
      ),
      child: GridView.builder(
        itemCount: items.length,
        padding: EdgeInsets.zero,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 14.h,
          crossAxisSpacing: 14.w,
          childAspectRatio: 1,
        ),
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
