import 'package:equatable/equatable.dart';

class DashboardSummaryEntity extends Equatable {
  final int totalBookings;
  final int totalFavorites;
  final int totalReviews;

  const DashboardSummaryEntity({
    required this.totalBookings,
    required this.totalFavorites,
    required this.totalReviews,
  });

  @override
  List<Object> get props => [totalBookings, totalFavorites, totalReviews];
}
