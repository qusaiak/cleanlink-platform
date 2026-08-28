import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/theme/styles.dart';
import '../../../../core/utils/functions/build_app_snack_bar.dart';
import '../../../../core/utils/functions/localized_failure_message.dart';
import '../../../../core/utils/functions/spinkit.dart';
import '../../../../l10n/app_localizations.dart';
import '../bloc/worker_profile_bloc.dart';

class MySkillsPage extends StatefulWidget {
  const MySkillsPage({super.key});

  @override
  State<MySkillsPage> createState() => _MySkillsPageState();
}

class _MySkillsPageState extends State<MySkillsPage> {
  late Set<int> _selectedIds;
  late Set<int> _initialIds;

  @override
  void initState() {
    super.initState();
    final state = context.read<WorkerProfileBloc>().state;
    _initialIds = {for (final skill in state.ownedSkills) skill.id};
    _selectedIds = {..._initialIds};
    if (state.allSkills.isEmpty && !state.loadingSkills) {
      context.read<WorkerProfileBloc>().add(const LoadAvailableSkills());
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final l = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: colors.surfaceContainerLowest,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        title: Text(
          l.my_skills,
          style: Styles.textStyle18.copyWith(fontWeight: FontWeight.w700),
        ),
      ),
      body: BlocConsumer<WorkerProfileBloc, WorkerProfileState>(
        listenWhen: (previous, current) =>
            current.status == WorkerProfileStatus.skillsSaved ||
            current.status == WorkerProfileStatus.skillsFailure,
        listener: (context, state) {
          if (state.status == WorkerProfileStatus.skillsSaved) {
            showAppSnackBar(context, message: l.skills_saved_message);
            context.pop();
          } else {
            showAppSnackBar(
              context,
              message: localizedFailureMessage(
                context,
                state.error,
                fallback: l.skills_save_failed,
              ),
              type: SnackBarType.error,
            );
          }
        },
        builder: (context, state) {
          if (state.loadingSkills && state.allSkills.isEmpty) {
            return Center(child: spinKitApp(colors.primary));
          }

          final hasChanges =
              _selectedIds.length != _initialIds.length ||
              !_selectedIds.every(_initialIds.contains);

          return Column(
            children: [
              Expanded(
                child: state.allSkills.isEmpty
                    ? Center(
                        child: Text(
                          l.skills_empty_dictionary,
                          style: Styles.textStyle14.copyWith(
                            color: colors.onSurfaceVariant,
                          ),
                        ),
                      )
                    : ListView.separated(
                        padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
                        itemCount: state.allSkills.length,
                        separatorBuilder: (_, __) => SizedBox(height: 8.h),
                        itemBuilder: (context, index) {
                          final skill = state.allSkills[index];
                          final selected = _selectedIds.contains(skill.id);
                          return Material(
                            color: selected
                                ? colors.primary.withValues(alpha: 0.08)
                                : colors.surface,
                            borderRadius: BorderRadius.circular(14.r),
                            child: CheckboxListTile(
                              value: selected,
                              controlAffinity: ListTileControlAffinity.leading,
                              activeColor: colors.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14.r),
                              ),
                              title: Text(
                                skill.nameFor(
                                  Localizations.localeOf(context).languageCode,
                                ),
                                style: Styles.textStyle14.copyWith(
                                  fontWeight: selected
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                ),
                              ),
                              onChanged: state.savingSkills
                                  ? null
                                  : (value) => setState(() {
                                      if (value ?? false) {
                                        _selectedIds.add(skill.id);
                                      } else {
                                        _selectedIds.remove(skill.id);
                                      }
                                    }),
                            ),
                          );
                        },
                      ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 12.h),
                decoration: BoxDecoration(
                  color: colors.surface,
                  border: Border(top: BorderSide(color: colors.outlineVariant)),
                ),
                child: SafeArea(
                  top: false,
                  child: SizedBox(
                    height: 52.h,
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: !hasChanges || state.savingSkills
                          ? null
                          : () => context.read<WorkerProfileBloc>().add(
                              SaveSkillsSelection(_selectedIds),
                            ),
                      style: FilledButton.styleFrom(
                        backgroundColor: colors.primary,
                        foregroundColor: colors.onPrimary,
                        disabledBackgroundColor: colors.onSurface.withValues(
                          alpha: 0.08,
                        ),
                        disabledForegroundColor: colors.onSurfaceVariant,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                      ),
                      icon: state.savingSkills
                          ? spinKitApp(
                              colors.onPrimary,
                              size: 18.r,
                              strokeWidth: 2,
                            )
                          : const Icon(Icons.save_outlined),
                      label: Text(
                        l.save_changes,
                        style: Styles.textStyle14.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
