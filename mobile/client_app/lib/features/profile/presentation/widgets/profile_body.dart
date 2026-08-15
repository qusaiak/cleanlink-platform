import 'package:client_app/features/profile/presentation/widgets/profile_content.dart';
import 'package:client_app/features/profile/presentation/widgets/profile_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../bloc/profile_bloc.dart';
import '../../../complaints/presentation/bloc/complaints_bloc.dart';

class ProfileBody extends StatefulWidget {
  const ProfileBody({super.key});

  @override
  State<ProfileBody> createState() => _ProfileBodyState();
}

class _ProfileBodyState extends State<ProfileBody> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(GetDashboardSummaryEvent());
    context.read<ProfileBloc>().add(LoadNotificationPreferenceEvent());
    context.read<ComplaintsBloc>().add(const LoadComplaintUnreadCountEvent());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () async {
          final bloc = context.read<ProfileBloc>()..add(RefreshProfileEvent());
          context.read<ComplaintsBloc>().add(
            const LoadComplaintUnreadCountEvent(),
          );
          await bloc.stream.firstWhere((state) => !state.isRefreshingProfile);
        },
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  children: [
                    const ProfileHeader(),
                    // SizedBox(height: 16.h),
                    // _ProfileInfoCard(),
                    SizedBox(height: 16.h),
                    const ProfileContent(),
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

// class _ProfileInfoCard extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context).colorScheme;
//     return ListenableBuilder(
//       listenable: sl<UserSession>(),
//       builder: (context, child) {
//         final session = sl<UserSession>();
//         final phone = session.phone;
//         final address = session.address;
//
//         if ((phone == null || phone.isEmpty) &&
//             (address == null || address.isEmpty)) {
//           return const SizedBox.shrink();
//         }
//
//         return Container(
//           padding: EdgeInsets.all(16.w),
//           decoration: BoxDecoration(
//             color: theme.onSurface.withValues(alpha: 0.04),
//             borderRadius: BorderRadius.circular(18.r),
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 AppLocalizations.of(context)!.personal_details,
//                 style: TextStyle(
//                   fontSize: 14.sp,
//                   fontWeight: FontWeight.w600,
//                   color: theme.onSurface,
//                 ),
//               ),
//               SizedBox(height: 12.h),
//               if (phone != null && phone.isNotEmpty)
//                 _InfoRow(icon: Icons.phone, text: "0$phone"),
//               if (phone != null && phone.isNotEmpty) SizedBox(height: 8.h),
//               if (address != null && address.isNotEmpty)
//                 _InfoRow(icon: Icons.location_on, text: address),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }

// class _InfoRow extends StatelessWidget {
//   const _InfoRow({required this.icon, required this.text});
//
//   final IconData icon;
//   final String text;
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context).colorScheme;
//     return Row(
//       children: [
//         Icon(icon, size: 18, color: theme.primary),
//         SizedBox(width: 10.w),
//         Expanded(
//           child: Text(
//             text,
//             style: TextStyle(
//               fontSize: 13.sp,
//               color: theme.onSurface.withValues(alpha: 0.8),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
