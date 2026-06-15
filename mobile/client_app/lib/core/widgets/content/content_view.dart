import 'package:flutter/material.dart';
import 'content_horizontal_list.dart';
import 'content_navigator.dart';
import 'content_section.dart';

class ContentView extends StatelessWidget {
  const ContentView({super.key, required this.sections});

  final List<ContentSection> sections;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: sections
          .map(
            (section) => ContentHorizontalList(
              section: section,
              onTitleTap: () => ContentNavigator.openSection(context, section),
              onItemTap: (index) => ContentNavigator.openItemDetails(
                context,
                type: section.type,
                index: index,
              ),
            ),
          )
          .toList(),
    );
  }
}
