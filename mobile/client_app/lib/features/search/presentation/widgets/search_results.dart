import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/functions/spinkit.dart';
import '../../../../core/widgets/content/content_grid_view.dart';
import '../../../../core/widgets/content/content_list_view.dart';
import '../../../../core/widgets/content/content_mock_data.dart';
import '../../../../core/widgets/content/content_section.dart';
import '../../../../core/widgets/content/content_section_type.dart';
import '../../../../core/widgets/content/content_view.dart';
import '../bloc/search_bloc.dart';
import 'search_tabs.dart';

class SearchResults extends StatelessWidget {
  const SearchResults({super.key});

  static final _allSections = <ContentSection>[
    ContentSection(
      id: 'search_companies',
      title: 'Companies',
      type: ContentSectionType.companies,
      items: ContentMockData.itemsFor(ContentSectionType.companies),
    ),
    ContentSection(
      id: 'search_services',
      title: 'Services',
      type: ContentSectionType.services,
      items: ContentMockData.itemsFor(ContentSectionType.services),
    ),
    ContentSection(
      id: 'search_categories',
      title: 'Categories',
      type: ContentSectionType.categories,
      items: ContentMockData.itemsFor(ContentSectionType.categories),
    ),
    ContentSection(
      id: 'search_regions',
      title: 'Regions',
      type: ContentSectionType.regions,
      items: ContentMockData.itemsFor(ContentSectionType.regions),
    ),
    ContentSection(
      id: 'search_providers',
      title: 'Providers',
      type: ContentSectionType.providers,
      items: ContentMockData.itemsFor(ContentSectionType.providers),
    ),
    ContentSection(
      id: 'search_offers',
      title: 'Offers',
      type: ContentSectionType.offers,
      items: ContentMockData.itemsFor(ContentSectionType.offers),
    ),
  ];

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
                  ?            Center(child: spinKitApp(theme.primary))

            : _buildTabContent(state.selectedTab, bottomInset),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTabContent(SearchTab tab, double bottomInset) {
    switch (tab) {
      case SearchTab.all:
        return SingleChildScrollView(
          padding: EdgeInsets.only(bottom: bottomInset),
          child: ContentView(sections: _allSections),
        );
      case SearchTab.companies:
        return ContentListView(
          type: ContentSectionType.companies,
          items: ContentMockData.itemsFor(ContentSectionType.companies),
        );
      case SearchTab.services:
        return ContentListView(
          type: ContentSectionType.services,
          items: ContentMockData.itemsFor(ContentSectionType.services),
        );
      case SearchTab.categories:
        return ContentGridView(
          type: ContentSectionType.categories,
          items: ContentMockData.itemsFor(ContentSectionType.categories),
        );
      case SearchTab.regions:
        return ContentListView(
          type: ContentSectionType.regions,
          items: ContentMockData.itemsFor(ContentSectionType.regions),
        );
      case SearchTab.providers:
        return ContentGridView(
          type: ContentSectionType.providers,
          items: ContentMockData.itemsFor(ContentSectionType.providers),
        );
      case SearchTab.offers:
        return ContentListView(
          type: ContentSectionType.offers,
          items: ContentMockData.itemsFor(ContentSectionType.offers),
        );
    }
  }
}
