part of 'review_bloc.dart';

class ReviewState extends Equatable {
  final bool isSubmitting;
  final String? errorMessage;
  final ReviewSubmissionEntity? result;
  final AddReviewParams? params;

  const ReviewState({
    this.isSubmitting = false,
    this.errorMessage,
    this.result,
    this.params,
  });

  @override
  List<Object?> get props => [isSubmitting, errorMessage, result, params];
}
