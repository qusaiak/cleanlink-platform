part of 'search_bloc.dart';

abstract class SearchEvent {
  const SearchEvent();
}

class UpdateSearchQuery extends SearchEvent {
  final String query;

  const UpdateSearchQuery(this.query);
}

class Search extends SearchEvent {
  const Search();
}

class ClearSearch extends SearchEvent {
  const ClearSearch();
}

class SelectTab extends SearchEvent {
  final SearchTab tab;

  const SelectTab(this.tab);
}

class UpdateAvailability extends SearchEvent {
  final Availability availability;

  const UpdateAvailability(this.availability);
}

class UpdateSortOrder extends SearchEvent {
  final SortOrder order;

  const UpdateSortOrder(this.order);
}

class UpdatePriceRange extends SearchEvent {
  final RangeValues priceRange;

  const UpdatePriceRange(this.priceRange);
}

class UpdateDistance extends SearchEvent {
  final double distance;

  const UpdateDistance(this.distance);
}

class UpdateMinRate extends SearchEvent {
  final double rate;

  const UpdateMinRate(this.rate);
}

class UpdateRegion extends SearchEvent {
  final int regionId;

  const UpdateRegion(this.regionId);
}

class ResetFilters extends SearchEvent {
  const ResetFilters();
}

class ApplyFiltersAndSearch extends SearchEvent {
  final int? regionId;
  final RangeValues priceRange;
  final double? rate;

  const ApplyFiltersAndSearch({
    this.regionId,
    required this.priceRange,
    this.rate,
  });
}
