import 'package:client_app/config/theme/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RowTitle extends StatelessWidget {
  const RowTitle({
    super.key,
    required this.iconData,
    required this.title,
    this.onTap,
  });

  final IconData iconData;
  final String title;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 5.h),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          color: Colors.transparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(iconData, size: 23, color: theme.primary),
                  SizedBox(width: 10.w),
                  Text(
                    title,
                    style: Styles.textStyle14.copyWith(
                      color: theme.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              if (onTap != null)
                IconButton(
                  onPressed: onTap,
                  icon: Icon(
                    Icons.arrow_forward_ios,
                    size: 15,
                    color: theme.onSurface,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
