import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/functions/spinkit.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/content/content_grid_view.dart';
import '../../../../core/widgets/content/content_list_view.dart';
import '../../../../core/widgets/content/content_section.dart';
import '../../../../core/widgets/content/content_section_type.dart';
import '../../../../core/widgets/content/content_view.dart';
import '../bloc/search_bloc.dart';
import '../../../../l10n/app_localizations.dart';
import 'search_tabs.dart';

class SearchResults extends StatelessWidget {
  const SearchResults({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;
    final bottomInset = MediaQuery.of(context).padding.bottom;
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 12.h),
            const SearchTabs(),
            SizedBox(height: 16.h),
            Expanded(
              child: state.isLoading
                  ? Center(child: spinKitApp(theme.primary))
                  : _buildTabContent(context, state, bottomInset),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTabContent(
    BuildContext context,
    SearchState state,
    double bottomInset,
  ) {
    final data = state.data;

    if (data == null) {
      return const SizedBox();
    }

    if (data.regions.isEmpty &&
        data.categories.isEmpty &&
        data.companies.isEmpty &&
        data.services.isEmpty &&
        data.offers.isEmpty) {
      return Center(
        child: AppEmptyState(
          icon: Icons.search_off_rounded,
          title: AppLocalizations.of(context)!.search_no_results,
        ),
      );
    }

    switch (state.selectedTab) {
      case SearchTab.all:
        return SingleChildScrollView(
          padding: EdgeInsets.only(bottom: bottomInset),

          child: ContentView(
            sections: [
              ContentSection(
                title: 'Companies',

                type: ContentSectionType.companies,

                items: data.companies,
              ),

              ContentSection(
                title: 'Services',

                type: ContentSectionType.services,

                items: data.services,
              ),

              ContentSection(
                title: 'Categories',

                type: ContentSectionType.categories,

                items: data.categories,
              ),

              ContentSection(
                title: 'Regions',

                type: ContentSectionType.regions,

                items: data.regions,
              ),

              ContentSection(
                title: 'Offers',

                type: ContentSectionType.offers,

                items: data.offers,
              ),
            ],
          ),
        );

      case SearchTab.companies:
        return ContentListView(
          type: ContentSectionType.companies,

          items: data.companies,
        );

      case SearchTab.services:
        return ContentListView(
          type: ContentSectionType.services,

          items: data.services,
        );

      case SearchTab.categories:
        return ContentGridView(
          type: ContentSectionType.categories,

          items: data.categories,
        );

      case SearchTab.regions:
        return ContentListView(
          type: ContentSectionType.regions,

          items: data.regions,
        );

      case SearchTab.offers:
        return ContentListView(
          type: ContentSectionType.offers,

          items: data.offers,
        );
    }
  }

  // Widget _buildTabContent(SearchTab tab, double bottomInset) {
  //   switch (tab) {
  //     case SearchTab.all:
  //       return SingleChildScrollView(
  //         padding: EdgeInsets.only(bottom: bottomInset),
  //         child: ContentView(sections: _allSections),
  //       );
  //     case SearchTab.companies:
  //       return ContentListView(
  //         type: ContentSectionType.companies,
  //         items: ContentMockData.itemsFor(ContentSectionType.companies),
  //       );
  //     case SearchTab.services:
  //       return ContentListView(
  //         type: ContentSectionType.services,
  //         items: ContentMockData.itemsFor(ContentSectionType.services),
  //       );
  //     case SearchTab.categories:
  //       return ContentGridView(
  //         type: ContentSectionType.categories,
  //         items: ContentMockData.itemsFor(ContentSectionType.categories),
  //       );
  //     case SearchTab.regions:
  //       return ContentListView(
  //         type: ContentSectionType.regions,
  //         items: ContentMockData.itemsFor(ContentSectionType.regions),
  //       );
  //     // case SearchTab.providers:
  //     //   return ContentGridView(
  //     //     type: ContentSectionType.providers,
  //     //     items: ContentMockData.itemsFor(ContentSectionType.providers),
  //     //   );
  //     case SearchTab.offers:
  //       return ContentListView(
  //         type: ContentSectionType.offers,
  //         items: ContentMockData.itemsFor(ContentSectionType.offers),
  //       );
  //   }
  // }
}
