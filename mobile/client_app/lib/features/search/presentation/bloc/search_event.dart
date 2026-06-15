part of 'search_bloc.dart';

abstract class SearchEvent {
  const SearchEvent();
}

/// Search
class StartSearching extends SearchEvent {
  const StartSearching();
}

class StopSearching extends SearchEvent {
  const StopSearching();
}

class UpdateSearchQuery extends SearchEvent {
  final String query;

  const UpdateSearchQuery(this.query);
}

class ClearSearch extends SearchEvent {
  const ClearSearch();
}

/// Filters
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
  final double? distance;

  const UpdateDistance(this.distance);
}

class UpdateMinRate extends SearchEvent {
  final double? rate;

  const UpdateMinRate(this.rate);
}

class ResetFilters extends SearchEvent {
  const ResetFilters();
}