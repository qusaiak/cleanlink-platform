import 'package:client_app/features/categories/domain/entities/category_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/theme/styles.dart';

class CategoryItem extends StatelessWidget {
  const CategoryItem({
    super.key,
    required this.category,
    required this.number,
    this.onTap,
  });

  final CategoryEntity category;
  final int number;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24.r),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24.r),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  category.image,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) {
                    return Container(
                      color: theme.primary.withValues(alpha: 0.08),
                      child: Icon(
                        Icons.category_rounded,
                        size: 45.sp,
                        color: theme.primary,
                      ),
                    );
                  },
                ),

                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: .18),
                        Colors.black.withValues(alpha: .65),
                      ],
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.all(14.w),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      category.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: number == 2
                          ? Styles.textStyle14.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            )
                          : Styles.textStyle12.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
