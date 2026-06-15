part of 'search_bloc.dart';

enum SearchTab {
  all,
  companies,
  services,
  categories,
  regions,
  providers,
  offers,
}

enum Availability { today, tomorrow, week }

enum SortOrder { asc, desc }

class SearchState extends Equatable {
  final bool isSearching;
  final String searchQuery;
  final SearchTab selectedTab;
  final Availability availability;
  final SortOrder sortOrder;
  final RangeValues priceRange;
  final double distance;
  final double minRate;
  final bool isLoading;

  const SearchState({
    this.isSearching = false,
    this.searchQuery = '',
    this.selectedTab = SearchTab.all,
    this.availability = Availability.today,
    this.sortOrder = SortOrder.asc,
    this.priceRange = const RangeValues(10, 100),
    this.distance = 1,
    this.minRate = 0,
    this.isLoading = false,
  });

  SearchState copyWith({
    bool? isSearching,
    String? searchQuery,
    SearchTab? selectedTab,
    Availability? availability,
    SortOrder? sortOrder,
    RangeValues? priceRange,
    double? distance,
    double? minRate,
    bool? isLoading,
  }) => SearchState(
    isSearching: isSearching ?? this.isSearching,
    searchQuery: searchQuery ?? this.searchQuery,
    selectedTab: selectedTab ?? this.selectedTab,
    availability: availability ?? this.availability,
    sortOrder: sortOrder ?? this.sortOrder,
    priceRange: priceRange ?? this.priceRange,
    distance: distance ?? this.distance,
    minRate: minRate ?? this.minRate,
    isLoading: isLoading ?? this.isLoading,
  );

  @override
  List<Object?> get props => [
    isSearching,
    searchQuery,
    selectedTab,
    availability,
    sortOrder,
    priceRange,
    distance,
    minRate,
    isLoading,
  ];
}
