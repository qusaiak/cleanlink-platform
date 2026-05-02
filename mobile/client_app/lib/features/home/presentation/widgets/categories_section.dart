import 'package:client_app/features/home/presentation/widgets/category_item.dart';
import 'package:flutter/material.dart';

class CategoriesSection extends StatelessWidget {
  const CategoriesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      {"icon": Icons.home, "title": "Home"},
      {"icon": Icons.business, "title": "Office"},
      {"icon": Icons.auto_awesome, "title": "Deep"},
      {"icon": Icons.chair, "title": "Sofa"},
      {"icon": Icons.cleaning_services, "title": "Carpet"},
      {"icon": Icons.local_shipping, "title": "Move"},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: categories.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1,
        ),
        itemBuilder: (_, i) {
          final item = categories[i];
          return CategoryItem(
            iconData: item["icon"] as IconData,
            title: item["title"] as String,
            onPressed: () {},
          );
        },
      ),
    );
  }
}