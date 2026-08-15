import 'package:client_app/core/utils/functions/spinkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/widgets/custom_search_bar.dart';
import '../../../../core/widgets/glass/circular_glass_button.dart';
import '../../../../injection_container.dart';
import '../../../../l10n/app_localizations.dart';
import '../bloc/search_bloc.dart';
import '../widgets/search_filter_bottom_sheet.dart';
import '../widgets/search_results.dart';
import '../widgets/search_sections_grid.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SearchBloc(sl()),
      child: const _SearchView(),
    );
  }
}

class _SearchView extends StatefulWidget {
  const _SearchView();

  @override
  State<_SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<_SearchView> {
  late final TextEditingController _searchController;
  late final FocusNode _searchFocusNode;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _searchFocusNode.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchBar(l10n, theme),
            Expanded(
              child: BlocBuilder<SearchBloc, SearchState>(
                builder: (context, state) {
                  if (state.isLoading) {
                    return Center(child: spinKitApp(theme.primary));
                  }
                  if (state.errorMessage != null) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.all(24.w),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              state.errorMessage!,
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 16.h),
                            ElevatedButton(
                              onPressed: () => context.read<SearchBloc>().add(
                                const Search(),
                              ),
                              child: Text(l10n.retry),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  if (!state.hasSearched) {
                    return _buildSearchContent(l10n, theme);
                  }

                  return const SearchResults();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(AppLocalizations l10n, ColorScheme theme) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),

      child: Row(
        children: [
          Expanded(
            child: CustomSearchBar(
              searchController: _searchController,

              focusNode: _searchFocusNode,

              hintText: l10n.search_hint,

              onChanged: (query) {
                final bloc = context.read<SearchBloc>();

                bloc.add(UpdateSearchQuery(query));

                if (query.trim().isEmpty) {
                  bloc.add(const ClearSearch());
                }
              },

              onSubmitted: (query) {
                if (query.trim().isEmpty) {
                  context.read<SearchBloc>().add(const ClearSearch());

                  return;
                }

                context.read<SearchBloc>().add(const Search());
              },
            ),
          ),

          SizedBox(width: 8.w),

          BlocBuilder<SearchBloc, SearchState>(
            buildWhen: (previous, current) =>
                previous.hasActiveFilters != current.hasActiveFilters,
            builder: (context, state) => SizedBox(
              height: 48.h,
              width: 48.w,
              child: CircularGlassButton(
                icon: Icons.tune_rounded,
                isActive: state.hasActiveFilters,
                activeColor: theme.primary,
                onTap: () => SearchFilterBottomSheet.show(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchContent(AppLocalizations l10n, ColorScheme theme) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16.h),
          const SearchSectionsGrid(),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }
}
