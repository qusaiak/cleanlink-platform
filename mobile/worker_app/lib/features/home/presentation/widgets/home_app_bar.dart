
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/theme/app_decoration.dart';
import '../../../../config/theme/styles.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: theme.primary, width: 1.5),
            ),
            child: CircleAvatar(
              radius: 25,
              backgroundImage: NetworkImage("https://i.pravatar.cc/150?img=3"),
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "khaled ajjour",
                  style: Styles.textStyle16.copyWith(
                      fontWeight: FontWeight.bold
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                     Icon(Icons.location_on_rounded,
                        size: 14, color: theme.onSurfaceVariant),
                    const SizedBox(width: 4),
                    Text(
                      "New York City",
                      style: Styles.textStyle12.copyWith(
                        color: theme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  color: theme.onSurface.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: Icon(Icons.notifications, color: theme.primary),
                  onPressed: () {},
                ),
              ),

              Positioned(
                right: -2,
                top: -2,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  decoration: BoxDecoration(
                    color: theme.error,
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                    border: Border.all(color: theme.surface, width: 1),
                  ),
                  child: Text(
                    "3",
                    style: TextStyle(
                      fontSize: 8,
                      color: theme.onError,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}