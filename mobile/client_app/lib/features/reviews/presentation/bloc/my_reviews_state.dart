part of 'my_reviews_bloc.dart';

class MyReviewsState extends Equatable {
  final List<MyReviewEntity> companyReviews;
  final List<MyReviewEntity> serviceReviews;
  final bool isLoading;
  final bool isRefreshing;
  final bool hasLoaded;
  final String? errorMessage;

  const MyReviewsState({
    this.companyReviews = const [],
    this.serviceReviews = const [],
    this.isLoading = false,
    this.isRefreshing = false,
    this.hasLoaded = false,
    this.errorMessage,
  });

  bool get hasContent => companyReviews.isNotEmpty || serviceReviews.isNotEmpty;

  MyReviewsState copyWith({
    List<MyReviewEntity>? companyReviews,
    List<MyReviewEntity>? serviceReviews,
    bool? isLoading,
    bool? isRefreshing,
    bool? hasLoaded,
    String? errorMessage,
    bool clearError = false,
  }) {
    return MyReviewsState(
      companyReviews: companyReviews ?? this.companyReviews,
      serviceReviews: serviceReviews ?? this.serviceReviews,
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      hasLoaded: hasLoaded ?? this.hasLoaded,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    companyReviews,
    serviceReviews,
    isLoading,
    isRefreshing,
    hasLoaded,
    errorMessage,
  ];
}
