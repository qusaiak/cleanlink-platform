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

  final int? regionId;
  final double? minimumPrice;
  final double? maximumPrice;
  final double? rating;

  final bool isLoading;

  final bool hasSearched;

  final SearchEntity? data;
  final String? errorMessage;

  const SearchState({
    this.searchQuery = '',

    this.selectedTab = SearchTab.all,

    this.availability = Availability.today,

    this.sortOrder = SortOrder.asc,

    this.priceRange = const RangeValues(10, 1000),

    this.distance = 1,

    this.regionId,
    this.minimumPrice,
    this.maximumPrice,
    this.rating,

    this.isLoading = false,

    this.hasSearched = false,

    this.data,
    this.errorMessage,
  });

  bool get hasPriceFilter => minimumPrice != null || maximumPrice != null;
  bool get hasRateFilter => rating != null;
  bool get hasRegionFilter => regionId != null;
  bool get hasActiveFilters =>
      hasRegionFilter || hasPriceFilter || hasRateFilter;

  SearchState copyWith({
    String? searchQuery,

    SearchTab? selectedTab,

    Availability? availability,

    SortOrder? sortOrder,

    RangeValues? priceRange,

    double? distance,

    int? regionId,
    double? minimumPrice,
    double? maximumPrice,
    double? rating,
    bool clearRegion = false,
    bool clearPrice = false,
    bool clearRating = false,

    bool? isLoading,

    bool? hasSearched,

    SearchEntity? data,
    bool clearData = false,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return SearchState(
      searchQuery: searchQuery ?? this.searchQuery,

      selectedTab: selectedTab ?? this.selectedTab,

      availability: availability ?? this.availability,

      sortOrder: sortOrder ?? this.sortOrder,

      priceRange: priceRange ?? this.priceRange,

      distance: distance ?? this.distance,

      regionId: clearRegion ? null : regionId ?? this.regionId,
      minimumPrice: clearPrice ? null : minimumPrice ?? this.minimumPrice,
      maximumPrice: clearPrice ? null : maximumPrice ?? this.maximumPrice,
      rating: clearRating ? null : rating ?? this.rating,

      isLoading: isLoading ?? this.isLoading,

      hasSearched: hasSearched ?? this.hasSearched,

      data: clearData ? null : data ?? this.data,
      errorMessage: clearErrorMessage
          ? null
          : errorMessage ?? this.errorMessage,
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

    regionId,
    minimumPrice,
    maximumPrice,
    rating,

    isLoading,

    hasSearched,

    data,
    errorMessage,
  ];
}
