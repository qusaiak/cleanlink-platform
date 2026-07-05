part of 'search_bloc.dart';

enum SearchTab { all, companies, services, categories, regions, offers }

enum Availability { today, tomorrow, week }

enum SortOrder { asc, desc }

class SearchState extends Equatable {
  final String searchQuery;

  final SearchTab selectedTab;

  final Availability availability;

  final SortOrder sortOrder;

  final RangeValues priceRange;

  final double distance;

  final double minRate;

  final int regionId;

  final bool isLoading;

  final bool hasSearched;

  final SearchEntity? data;

  final bool hasPriceFilter;
  final bool hasRateFilter;
  final bool hasRegionFilter;

  const SearchState({
    this.searchQuery = '',

    this.selectedTab = SearchTab.all,

    this.availability = Availability.today,

    this.sortOrder = SortOrder.asc,

    this.priceRange = const RangeValues(10, 1000),

    this.distance = 1,

    this.minRate = 0,

    this.regionId = 0,

    this.isLoading = false,

    this.hasSearched = false,

    this.data,

    this.hasPriceFilter = false,
    this.hasRateFilter = false,
    this.hasRegionFilter = false,
  });

  SearchState copyWith({
    String? searchQuery,

    SearchTab? selectedTab,

    Availability? availability,

    SortOrder? sortOrder,

    RangeValues? priceRange,

    double? distance,

    double? minRate,

    int? regionId,

    bool? isLoading,

    bool? hasSearched,

    SearchEntity? data,

    bool? hasPriceFilter,
    bool? hasRateFilter,
    bool? hasRegionFilter,
  }) {
    return SearchState(
      searchQuery: searchQuery ?? this.searchQuery,

      selectedTab: selectedTab ?? this.selectedTab,

      availability: availability ?? this.availability,

      sortOrder: sortOrder ?? this.sortOrder,

      priceRange: priceRange ?? this.priceRange,

      distance: distance ?? this.distance,

      minRate: minRate ?? this.minRate,

      regionId: regionId ?? this.regionId,

      isLoading: isLoading ?? this.isLoading,

      hasSearched: hasSearched ?? this.hasSearched,

      data: data ?? this.data,

      hasPriceFilter: hasPriceFilter ?? this.hasPriceFilter,

      hasRateFilter: hasRateFilter ?? this.hasRateFilter,

      hasRegionFilter: hasRegionFilter ?? this.hasRegionFilter,
    );
  }

  @override
  List<Object?> get props => [
    searchQuery,

    selectedTab,

    availability,

    sortOrder,

    priceRange,

    distance,

    minRate,

    regionId,

    isLoading,

    hasSearched,

    data,

    hasPriceFilter,
    hasRateFilter,
    hasRegionFilter,
  ];
}
