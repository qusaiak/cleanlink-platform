import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/theme/app_decoration.dart';
import '../../../../config/theme/styles.dart';
import '../../../../core/widgets/app_shimmer.dart';
import '../../../../core/widgets/custom_appbar.dart';
import '../../../../injection_container.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../tasks/presentation/utils/open_task.dart';
import '../../domain/entities/search_query.dart';
import '../bloc/search_bloc.dart';
import '../widgets/service_result_tile.dart';
import '../widgets/service_search_field.dart';

/// The search results screen. Hosts the same [ServiceSearchField] at the top
/// (so the worker can refine the query) and lists matching services below.
///
/// Provides a feature-scoped [SearchBloc] from `get_it`. An optional
/// [initialQuery] (passed from the top-bar field) is run on open.
class SearchResultsPage extends StatelessWidget {
  final SearchQuery? initialQuery;

  const SearchResultsPage({super.key, this.initialQuery});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SearchBloc>(
      create: (_) {
        final bloc = sl<SearchBloc>();
        if (initialQuery != null) {
          bloc.add(SubmitSearch(initialQuery!));
        }
        return bloc;
      },
      child: _SearchResultsView(initialQuery: initialQuery),
    );
  }
}

class _SearchResultsView extends StatelessWidget {
  final SearchQuery? initialQuery;

  const _SearchResultsView({this.initialQuery});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final l = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: theme.secondaryContainer,
      appBar: customAppBar(
        l.search_title,
        Icons.arrow_back_ios_new_rounded,
        null,
        () => Navigator.of(context).maybePop(),
        theme.primary,
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 12.h),
              child: ServiceSearchField(
                initialQuery: initialQuery ?? const SearchQuery(),
                autofocus: initialQuery == null,
                onSearch: (query) =>
                    context.read<SearchBloc>().add(SubmitSearch(query)),
              ),
            ),
            Expanded(
              child: BlocBuilder<SearchBloc, SearchState>(
                builder: (context, state) {
                  switch (state.status) {
                    case SearchStatus.initial:
                      return _hint(context, l, theme);
                    case SearchStatus.loading:
                      return const _SearchResultsSkeleton();
                    case SearchStatus.error:
                      return _message(
                        theme,
                        Icons.cloud_off_rounded,
                        state.error?.message ?? l.search_failed,
                        theme.error,
                      );
                    case SearchStatus.loaded:
                      if (state.results.isEmpty) {
                        return _message(
                          theme,
                          Icons.search_off_rounded,
                          l.search_no_results,
                          theme.onSurfaceVariant,
                        );
                      }
                      return ListView.separated(
                        padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 24.h),
                        itemCount: state.results.length,
                        separatorBuilder: (_, __) => SizedBox(height: 10.h),
                        itemBuilder: (context, index) {
                          final service = state.results[index];
                          return ServiceResultTile(
                            service: service,
                            // Open the matching task's full details, just like
                            // tapping a card on the home tasks list. No list
                            // reload — search isn't the daily-tasks list.
                            onTap: () => openTaskById(
                              context,
                              service.id,
                              refreshTasksOnReturn: false,
                            ),
                          );
                        },
                      );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _hint(BuildContext context, AppLocalizations l, ColorScheme theme) =>
      _message(theme, Icons.search_rounded, l.search_hint_prompt,
          theme.onSurfaceVariant);

  Widget _message(ColorScheme theme, IconData icon, String text, Color color) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 56.r, color: color.withValues(alpha: 0.6)),
            SizedBox(height: 16.h),
            Text(
              text,
              textAlign: TextAlign.center,
              style:
                  Styles.textStyle14.copyWith(color: theme.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}

/// Loading-state placeholder for the results list: a handful of shimmering
/// rows shaped like [ServiceResultTile] so the layout doesn't jump once the
/// real data arrives.
class _SearchResultsSkeleton extends StatelessWidget {
  const _SearchResultsSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 24.h),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 6,
      separatorBuilder: (_, __) => SizedBox(height: 10.h),
      itemBuilder: (context, index) => const _SearchResultSkeletonTile(),
    );
  }
}

class _SearchResultSkeletonTile extends StatelessWidget {
  const _SearchResultSkeletonTile();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: theme.surface,
        borderRadius: AppRadius.card,
        border: Border.all(color: theme.onSurface.withValues(alpha: 0.06)),
      ),
      padding: EdgeInsets.all(14.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AppShimmerBox(width: 42.w, height: 42.w, radius: 21.r),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppShimmerBox(width: 120.w, height: 14.h, radius: 4.r),
                    SizedBox(height: 6.h),
                    AppShimmerBox(width: 80.w, height: 12.h, radius: 4.r),
                  ],
                ),
              ),
              SizedBox(width: 12.w),
              AppShimmerBox(width: 44.w, height: 14.h, radius: 4.r),
            ],
          ),
          SizedBox(height: 12.h),
          AppShimmerBox(width: 170.w, height: 12.h, radius: 4.r),
          SizedBox(height: 6.h),
          AppShimmerBox(width: 130.w, height: 12.h, radius: 4.r),
        ],
      ),
    );
  }
}
