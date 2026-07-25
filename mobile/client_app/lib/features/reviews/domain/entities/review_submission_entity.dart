import 'package:equatable/equatable.dart';

class ReviewSubmissionEntity extends Equatable {
  final int status;
  final String message;
  final int? reviewId;

  const ReviewSubmissionEntity({
    required this.status,
    required this.message,
    this.reviewId,
  });

  @override
  List<Object?> get props => [status, message, reviewId];
}
