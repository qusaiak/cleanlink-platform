import 'package:client_app/features/profile/data/models/dashboard_summary_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('maps mixed summary counts and defaults missing values to zero', () {
    final response = DashboardSummaryResponseModel.fromJson({
      'status': '200',
      'message': 'ok',
      'data': {
        'total_bookings': '1',
        'total_favorites': 2.9,
        'total_reviews': null,
      },
    });

    final summary = response.data!.toEntity();
    expect(summary.totalBookings, 1);
    expect(summary.totalFavorites, 2);
    expect(summary.totalReviews, 0);
  });
}
