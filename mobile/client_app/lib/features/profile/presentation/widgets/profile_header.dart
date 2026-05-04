import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/theme/colors.dart';
import '../../../../config/theme/styles.dart';
import '../../../../l10n/app_localizations.dart';
import '../bloc/profile_bloc.dart';

class ProfileHeader extends StatefulWidget {
  const ProfileHeader({super.key});

  @override
  State<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;

    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        return Column(
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: CircleAvatar(
                radius: 48.w,
                backgroundColor: Colors.grey.shade300,
                backgroundImage: const NetworkImage(
                  "https://i.pravatar.cc/300",
                ),
              ),
            ),

            SizedBox(height: 12.h),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Qusai Abo Khier",
                  style: Styles.textStyle16.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            SizedBox(height: 20.h),
          ],
        );
      },
    );
  }
}
