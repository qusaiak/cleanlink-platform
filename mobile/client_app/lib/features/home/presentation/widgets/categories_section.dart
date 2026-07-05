import 'package:client_app/features/home/presentation/widgets/category_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/routes/app_router.dart';
import '../../../categories/domain/entities/category_entity.dart';

class CategoriesSection extends StatelessWidget {
  final List<CategoryEntity> categories;
  const CategoriesSection({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: categories.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 8.w,
          crossAxisSpacing: 8.w,
          childAspectRatio: 1,
        ),
        itemBuilder: (_, i) {
          final item = categories[i];
          return CategoryItem(
            category: item,
            number: 3,
            onTap: () {
              GoRouter.of(
                context,
              ).push(AppRouter.kCategoryDetails, extra: item.id);
            },
          );
        },
      ),
    );
  }
}
