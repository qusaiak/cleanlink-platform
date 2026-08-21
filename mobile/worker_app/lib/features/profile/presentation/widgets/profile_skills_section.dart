import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/theme/styles.dart';
import '../../../../core/utils/functions/spinkit.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/worker_profile.dart';
import 'skill_chip.dart';

class ProfileSkillsSection extends StatelessWidget {
  final List<WorkerSkill> skills;

  final List<WorkerSkill> availableSkills;

  final bool loadingSkills;

  final Set<int> pendingSkillIds;

  final ValueChanged<WorkerSkill> onAddSkill;

  final ValueChanged<WorkerSkill> onRemoveSkill;

  const ProfileSkillsSection({
    super.key,
    required this.skills,
    required this.availableSkills,
    required this.loadingSkills,
    required this.pendingSkillIds,
    required this.onAddSkill,
    required this.onRemoveSkill,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final l = AppLocalizations.of(context)!;
    final localeCode = Localizations.localeOf(context).languageCode;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: theme.surface,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: theme.onSurface.withValues(alpha: 0.06)),
      ),

      child: LayoutBuilder(
        builder: (context, constraints) {
          final chipMaxWidth = constraints.maxWidth;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.handyman_outlined,
                    size: 18.r,
                    color: theme.primary,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      l.profile_skills_title,
                      style: Styles.textStyle14.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),

              if (skills.isEmpty)
                Text(
                  l.profile_no_skills,
                  style: Styles.textStyle12.copyWith(
                    color: theme.onSurfaceVariant,
                  ),
                )
              else
                Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: [
                    for (final skill in skills)
                      SkillChip(
                        label: skill.nameFor(localeCode),
                        owned: true,
                        pending: pendingSkillIds.contains(skill.id),
                        maxWidth: chipMaxWidth,
                        onPressed: () => onRemoveSkill(skill),
                      ),
                  ],
                ),

              SizedBox(height: 14.h),
              Divider(color: theme.onSurface.withValues(alpha: 0.06)),
              SizedBox(height: 10.h),

              Text(
                l.skills_available_title,
                style: Styles.textStyle12.copyWith(
                  color: theme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 10.h),
              _available(context, theme, l, localeCode, chipMaxWidth),
            ],
          );
        },
      ),
    );
  }

  Widget _available(
    BuildContext context,
    ColorScheme theme,
    AppLocalizations l,
    String localeCode,
    double chipMaxWidth,
  ) {
    if (loadingSkills && availableSkills.isEmpty) {
      return Row(
        children: [
          SizedBox(width: 16.r, height: 16.r, child: spinKitApp(theme.primary)),
          SizedBox(width: 10.w),
          Flexible(
            child: Text(
              l.profile_skills_loading,
              style: Styles.textStyle12.copyWith(color: theme.onSurfaceVariant),
            ),
          ),
        ],
      );
    }

    if (availableSkills.isEmpty) {
      return Text(
        skills.isEmpty
            ? l.skills_empty_dictionary
            : l.profile_all_skills_assigned,
        style: Styles.textStyle12.copyWith(color: theme.onSurfaceVariant),
      );
    }

    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: [
        for (final skill in availableSkills)
          SkillChip(
            label: skill.nameFor(localeCode),
            owned: false,
            pending: pendingSkillIds.contains(skill.id),
            maxWidth: chipMaxWidth,
            onPressed: () => onAddSkill(skill),
          ),
      ],
    );
  }
}
