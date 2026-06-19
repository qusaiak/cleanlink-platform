part of 'bookings_bloc.dart';

enum BookingTab { all, ongoing, upcoming, completed, cancelled }

class BookingsState extends Equatable {
  final bool loading;

  final bool loadingMore;

  final bool refreshing;

  final String? error;

  final BookingTab selectedTab;

  final List bookings;

  final bool hasReachedMax;

  const BookingsState({
    required this.loading,
    required this.loadingMore,
    required this.refreshing,
    required this.selectedTab,
    required this.bookings,
    required this.hasReachedMax,
    required this.error,
  });

  factory BookingsState.initial() {
    return const BookingsState(
      loading: false,
      loadingMore: false,
      refreshing: false,
      selectedTab: BookingTab.all,
      bookings: [],
      hasReachedMax: false,
      error: null,
    );
  }

  BookingsState copyWith({
    bool? loading,
    bool? loadingMore,
    bool? refreshing,
    BookingTab? selectedTab,
    List? bookings,
    bool? hasReachedMax,
    String? error,
  }) {
    return BookingsState(
      loading: loading ?? this.loading,

      loadingMore: loadingMore ?? this.loadingMore,

      refreshing: refreshing ?? this.refreshing,

      selectedTab: selectedTab ?? this.selectedTab,

      bookings: bookings ?? this.bookings,

      hasReachedMax: hasReachedMax ?? this.hasReachedMax,

      error: error,
    );
  }

  bool get isEmpty => bookings.isEmpty;

  @override
  List<Object?> get props => [
    loading,
    loadingMore,
    refreshing,
    selectedTab,
    bookings,
    hasReachedMax,
    error,
  ];
}
