part of 'my_reviews_bloc.dart';

sealed class MyReviewsEvent extends Equatable {
  const MyReviewsEvent();

  @override
  List<Object?> get props => [];
}

class GetMyReviewsEvent extends MyReviewsEvent {}

class RefreshMyReviewsEvent extends MyReviewsEvent {}
