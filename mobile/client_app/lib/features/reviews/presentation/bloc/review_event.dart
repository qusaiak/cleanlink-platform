part of 'review_bloc.dart';

sealed class ReviewEvent extends Equatable {
  const ReviewEvent();

  @override
  List<Object?> get props => const [];
}

class SubmitReviewEvent extends ReviewEvent {
  final AddReviewParams params;

  const SubmitReviewEvent(this.params);

  @override
  List<Object?> get props => [params];
}

class ResetReviewEvent extends ReviewEvent {
  const ResetReviewEvent();
}
