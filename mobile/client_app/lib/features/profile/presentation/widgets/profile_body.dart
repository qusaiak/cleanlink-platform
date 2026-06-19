import 'package:client_app/features/profile/presentation/widgets/profile_content.dart';
import 'package:client_app/features/profile/presentation/widgets/profile_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileBody extends StatelessWidget {
  const ProfileBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () async {},
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  children: [
                    ProfileHeader(),
                    SizedBox(height: 16.h),
                    // PremiumCard(),
                    // SizedBox(height: 16.h),
                    ProfileContent(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
