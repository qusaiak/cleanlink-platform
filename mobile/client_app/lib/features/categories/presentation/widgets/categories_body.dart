import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../home/data/models/category_model.dart';
import '../../../home/presentation/widgets/category_item.dart';

class CategoriesBody extends StatelessWidget {
  const CategoriesBody({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = CategoriesData.all;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: GridView.builder(
        itemCount: categories.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 14.h,
          crossAxisSpacing: 14.w,
          childAspectRatio: 1,
        ),
        itemBuilder: (_, i) {
          final item = categories[i];
          return CategoryItem(
            iconData: item.icon,
            title: item.title,
            onPressed: () {
              /// Navigate to services by category (later)
            },
          );
        },
      ),
    );
  }
}
