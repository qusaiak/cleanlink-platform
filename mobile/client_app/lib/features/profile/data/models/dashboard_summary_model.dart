import '../../domain/entities/dashboard_summary_entity.dart';

class DashboardSummaryResponseModel {
  final int status;
  final String message;
  final DashboardSummaryModel? data;

  const DashboardSummaryResponseModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory DashboardSummaryResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    return DashboardSummaryResponseModel(
      status: _toInt(json['status']),
      message: json['message']?.toString() ?? '',
      data: data is Map
          ? DashboardSummaryModel.fromJson(Map<String, dynamic>.from(data))
          : null,
    );
  }
}

class DashboardSummaryModel {
  final int totalBookings;
  final int totalFavorites;
  final int totalReviews;

  const DashboardSummaryModel({
    required this.totalBookings,
    required this.totalFavorites,
    required this.totalReviews,
  });

  factory DashboardSummaryModel.fromJson(Map<String, dynamic> json) {
    return DashboardSummaryModel(
      totalBookings: _toInt(json['total_bookings']),
      totalFavorites: _toInt(json['total_favorites']),
      totalReviews: _toInt(json['total_reviews']),
    );
  }

  DashboardSummaryEntity toEntity() => DashboardSummaryEntity(
    totalBookings: totalBookings,
    totalFavorites: totalFavorites,
    totalReviews: totalReviews,
  );
}

int _toInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? 0;
}
