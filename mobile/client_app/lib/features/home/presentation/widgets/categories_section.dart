import 'package:client_app/features/home/presentation/widgets/category_item.dart';
import 'package:flutter/material.dart';

import '../../data/models/category_model.dart';

class CategoriesSection extends StatelessWidget {
  const CategoriesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = CategoriesData.all.take(6).toList();
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
            iconData: item.icon,
            title: item.title,
            onPressed: () {},
          );
        },
      ),
    );
  }
}


// RowTitle(
// iconData: Icons.category,
// title: AppLocalizations.of(context)!.popular_categories,
// onTap: () {
// GoRouter.of(context).push(AppRouter.kCategories);
// },
// ),