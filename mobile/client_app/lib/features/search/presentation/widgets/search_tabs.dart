import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../config/theme/styles.dart';
import '../../../../l10n/app_localizations.dart';
import '../bloc/search_bloc.dart';

class SearchTabs extends StatelessWidget {
  const SearchTabs({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context).colorScheme;

    final tabs = <SearchTab, String>{
      SearchTab.all: l10n.all,
      SearchTab.companies: l10n.search_companies,
      SearchTab.services: l10n.search_services,
      SearchTab.categories: l10n.search_categories,
      SearchTab.regions: l10n.search_regions,
      // SearchTab.providers: l10n.search_providers,
      SearchTab.offers: l10n.search_offers,
    };

    return BlocBuilder<SearchBloc, SearchState>(
      buildWhen: (prev, curr) => prev.selectedTab != curr.selectedTab,
      builder: (context, state) {
        return SizedBox(
          height: 30.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: tabs.length,
            separatorBuilder: (_, _) => SizedBox(width: 8.w),
            itemBuilder: (context, index) {
              final entry = tabs.entries.elementAt(index);
              final isSelected = state.selectedTab == entry.key;
              return GestureDetector(
                onTap: () =>
                    context.read<SearchBloc>().add(SelectTab(entry.key)),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? theme.primary : theme.surface,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    entry.value,
                    style: Styles.textStyle12.copyWith(
                      color: isSelected
                          ? theme.onPrimary
                          : theme.onSurfaceVariant,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
