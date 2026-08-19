import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/routes/app_router.dart';
import '../../../../config/theme/styles.dart';
import '../../../../core/widgets/network_avatar.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/presentation/widgets/logout_dialog.dart';
import '../../../profile/presentation/bloc/worker_profile_bloc.dart';
import '../../../profile/presentation/widgets/worker_availability_ui.dart';

/// Sidebar for the home screen. Two destinations — the worker's profile and the
/// settings screen — pushed over the home route so the back button returns here.
class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final l = AppLocalizations.of(context)!;

    return Drawer(
      backgroundColor: theme.surface,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Account header — shows the SAME worker account as the top-bar
            // profile button (both read [WorkerProfileBloc]). Tapping it opens
            // the profile screen, just like the Profile item below.
            InkWell(
              onTap: () => _go(context, AppRouter.kProfile),
              child: Padding(
                padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 16.h),
                child: BlocBuilder<WorkerProfileBloc, WorkerProfileState>(
                  builder: (context, state) {
                    final profile = state.profile;
                    final name = profile?.name ?? 'CleanLink';
                    final avatarUrl = profile?.avatarUrl ?? '';
                    // Ring colour mirrors the worker's availability status.
                    final ringColor = profile != null
                        ? WorkerAvailabilityUi.of(
                            context,
                            profile.availability,
                          ).color
                        : theme.primary;

                    return Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(2.r),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: ringColor, width: 2),
                          ),
                          child: NetworkAvatar(
                            avatarUrl: avatarUrl,
                            radius: 24.r,
                            backgroundColor: theme.primary.withValues(
                              alpha: 0.12,
                            ),
                            iconColor: theme.primary,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                name,
                                maxLines: 1,
                                style: Styles.textStyle16.copyWith(
                                  color: theme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (profile != null && profile.role.isNotEmpty)
                                Text(
                                  profile.role,
                                  maxLines: 1,
                                  style: Styles.textStyle12.copyWith(
                                    color: theme.onSurfaceVariant,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            const Divider(height: 1),
            _DrawerItem(
              icon: Icons.person_outline,
              label: l.profile,
              onTap: () => _go(context, AppRouter.kProfile),
            ),
            _DrawerItem(
              icon: Icons.settings_outlined,
              label: l.setting_title,
              onTap: () => _go(context, AppRouter.kSettings),
            ),

            // Logout pinned to the bottom, separated and styled as a
            // destructive/exit action.
            const Spacer(),
            const Divider(height: 1),
            _DrawerItem(
              icon: Icons.logout_rounded,
              label: l.logout,
              destructive: true,
              // Close the drawer first, then open the confirmation dialog on
              // the root navigator (independent of the closing drawer context).
              onTap: () {
                Navigator.of(context).pop();
                showLogoutDialog(
                  AppRouter.rootNavigatorKey.currentContext ?? context,
                );
              },
            ),
            SizedBox(height: 8.h),
          ],
        ),
      ),
    );
  }

  /// Closes the drawer first, then pushes the destination. When returning from
  /// the profile screen, refreshes the worker profile so any availability
  /// change is reflected in the home avatar ring / status.
  void _go(BuildContext context, String route) async {
    final bloc = context.read<WorkerProfileBloc>();
    Navigator.of(context).pop();
    await context.push(route);
    if (route == AppRouter.kProfile) {
      bloc.add(const LoadWorkerProfile());
    }
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  /// Renders the item in the error colour to read as a destructive/exit action
  /// (used for Logout).
  final bool destructive;

  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.destructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final color = destructive ? theme.error : theme.primary;
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        label,
        style: Styles.textStyle14.copyWith(
          color: destructive ? theme.error : theme.onSurface,
          fontWeight: destructive ? FontWeight.w600 : FontWeight.w400,
        ),
      ),
      onTap: onTap,
    );
  }
}
