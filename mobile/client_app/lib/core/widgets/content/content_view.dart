import 'package:flutter/material.dart';
import 'content_horizontal_list.dart';
import 'content_navigator.dart';
import 'content_section.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ContentView extends StatelessWidget {
  const ContentView({super.key, required this.sections});

  final List<ContentSection> sections;

  @override
  Widget build(BuildContext context) {
    final visibleSections = sections.where((e) => e.items.isNotEmpty).toList();

    if (visibleSections.isEmpty) {
      return const SizedBox();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: List.generate(visibleSections.length, (index) {
        final section = visibleSections[index];

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.h, vertical: 4.h),

          child: ContentHorizontalList(
            section: section,

            onTitleTap: () {
              ContentNavigator.openSection(context, section);
            },

            onItemTap: (id) {
              ContentNavigator.openItemDetails(
                context,

                type: section.type,

                id: id,
              );
            },
          ),
        );
      }),
    );
  }
}
