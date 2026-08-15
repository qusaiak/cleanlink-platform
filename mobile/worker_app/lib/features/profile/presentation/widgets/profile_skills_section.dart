import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/theme/styles.dart';
import '../../../../core/utils/functions/spinkit.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/worker_profile.dart';
import 'skill_chip.dart';

/// The skills card: the worker's own skills, and underneath them the skills
/// they can still add.
///
/// Both lists act IMMEDIATELY — one tap on a chip attaches or detaches it.
/// There is no "manage" button, no edit mode and no confirmation step, so there
/// is no mode flag anywhere in this widget: every chip is always live.
///
/// While a given skill's request is in flight its own chip shows a spinner and
/// stops responding ([pendingSkillIds]); every other chip stays tappable.
///
/// Names resolve from `name_ar` / `name_en` against the ambient locale, so the
/// owned chips re-localize with the app language without a request; the
/// dictionary below them is re-fetched by the bloc instead, because the server
/// is what localizes it.
class ProfileSkillsSection extends StatelessWidget {
  /// Skills the worker already has.
  final List<WorkerSkill> skills;

  /// Skills that can still be added (dictionary − owned).
  final List<WorkerSkill> availableSkills;

  /// The dictionary is being fetched.
  final bool loadingSkills;

  /// Ids whose attach/detach request is in flight right now.
  final Set<int> pendingSkillIds;

  /// Attach this skill — fired by a single tap on an "add" chip.
  final ValueChanged<WorkerSkill> onAddSkill;

  /// Detach this skill — fired by a single tap on an owned chip.
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
      // Measures the real content width and hands it to every chip, which is
      // what allows a long Arabic name to wrap instead of being clipped (a Wrap
      // gives its children unbounded width — see [SkillChip.maxWidth]).
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

              // ---- The worker's own skills: tap to remove. ----
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

              // ---- Everything still addable: tap to add. ----
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
              style: Styles.textStyle12.copyWith(
                color: theme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      );
    }

    if (availableSkills.isEmpty) {
      return Text(
        // "everything assigned" and "the dictionary is empty" are different
        // situations and read differently to the worker.
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
