import '../../domain/entities/service_summary.dart';

/// Data-layer representation of [ServiceSummary] with JSON deserialization for
/// the search endpoint. Accepts both camelCase and snake_case keys so it works
/// regardless of the backend's JSON style.
class ServiceSummaryModel extends ServiceSummary {
  const ServiceSummaryModel({
    required super.id,
    required super.serviceName,
    required super.clientName,
    required super.location,
    required super.scheduledAt,
    super.requestId,
    super.price,
  });

  factory ServiceSummaryModel.fromJson(Map<String, dynamic> json) {
    return ServiceSummaryModel(
      id: json['id'].toString(),
      serviceName: (json['serviceName'] ?? json['service_name'] ?? '')
          .toString(),
      clientName: (json['clientName'] ?? json['client_name'] ?? '').toString(),
      location: (json['location'] ?? '').toString(),
      scheduledAt:
          DateTime.tryParse(
            (json['scheduledAt'] ?? json['scheduled_at'] ?? '').toString(),
          ) ??
          DateTime.fromMillisecondsSinceEpoch(0),
      requestId: (json['requestId'] ?? json['request_id'])?.toString(),
      price: json['price'] == null
          ? null
          : (json['price'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'serviceName': serviceName,
    'clientName': clientName,
    'location': location,
    'scheduledAt': scheduledAt.toIso8601String(),
    'requestId': requestId,
    'price': price,
  };
}
