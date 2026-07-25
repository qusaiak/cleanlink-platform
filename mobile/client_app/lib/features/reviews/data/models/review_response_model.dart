import '../../domain/entities/review_submission_entity.dart';

class ReviewResponseModel {
  final int? status;
  final String? message;
  final int? reviewId;

  const ReviewResponseModel({this.status, this.message, this.reviewId});

  factory ReviewResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    return ReviewResponseModel(
      status: _parseInt(json['status']),
      message: json['message']?.toString(),
      reviewId: data is Map ? _parseInt(data['id']) : null,
    );
  }

  ReviewSubmissionEntity toEntity({required int fallbackStatus}) =>
      ReviewSubmissionEntity(
        status: status ?? fallbackStatus,
        message: message ?? '',
        reviewId: reviewId,
      );
}

int? _parseInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '');
}
