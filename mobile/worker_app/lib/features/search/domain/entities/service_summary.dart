import 'package:equatable/equatable.dart';

/// A single searchable service / job request returned by a search.
///
/// Pure domain entity (only [Equatable]); independent of the tasks feature so
/// the search feature stays self-contained. `requestId` lets the UI deep-link
/// to the matching request when the backend wires it up.
class ServiceSummary extends Equatable {
  final String id;
  final String serviceName;
  final String clientName;
  final String location;
  final DateTime scheduledAt;

  /// Optional human-facing request reference (e.g. "4589").
  final String? requestId;

  /// Optional price/quote, when the backend provides one.
  final double? price;

  const ServiceSummary({
    required this.id,
    required this.serviceName,
    required this.clientName,
    required this.location,
    required this.scheduledAt,
    this.requestId,
    this.price,
  });

  @override
  List<Object?> get props => [
    id,
    serviceName,
    clientName,
    location,
    scheduledAt,
    requestId,
    price,
  ];
}
