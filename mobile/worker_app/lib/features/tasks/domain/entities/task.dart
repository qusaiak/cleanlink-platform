import 'package:equatable/equatable.dart';

/// The lifecycle status of a worker task.
///
/// These mirror the badges and actions shown across the worker designs:
/// - [assigned]   ("تم التعيين")   → worker can start the job.
/// - [onTheWay]   ("في الطريق")    → worker is heading to the location.
/// - [inProgress] ("قيد التنفيذ")  → job is being executed (can be paused/completed).
/// - [paused]     ("متوقفة مؤقتاً") → temporarily paused by the worker.
/// - [completed]  ("مكتملة").
/// - [cancelled]  ("ملغاة").
enum TaskStatus { assigned, onTheWay, inProgress, paused, completed, cancelled }

/// The kind of service a task represents.
///
/// Used only to pick an icon/accent in the UI. The domain layer stays
/// framework-agnostic and never references Flutter, so the icon mapping
/// lives in the presentation layer (see `task_status_ui.dart`).
enum ServiceType { acMaintenance, plumbing, electrical, cleaning, general }

/// Core business entity describing a single cleaning/maintenance task that a
/// worker receives and progresses through its [status] lifecycle.
///
/// It is intentionally pure (only [Equatable]) so it can be shared by every
/// layer without coupling the domain to the data source or the UI.
class Task extends Equatable {
  final String id;

  /// Human-facing request reference shown as "طلب رقم #4589".
  final String requestNumber;
  final String title;
  final ServiceType serviceType;
  final String customerName;
  final String location;

  /// Name of the company/provider the booking belongs to (e.g. "SparkleClean"),
  /// shown under the service title so the worker knows who they represent.
  final String companyName;

  /// The package the customer selected (e.g. "Studio", "2 Bedroom", "Villa").
  /// Empty when the booking has no package tiers.
  final String packageName;

  /// Price the customer paid for the selected package. Zero when unset.
  final double price;

  /// Currency symbol/code paired with [price] for display (e.g. "$").
  final String currency;

  /// Human-facing estimated duration for the job (e.g. "2 hours", "2-4h").
  /// Kept as a label so the backend controls wording per locale.
  final String durationLabel;

  /// The "what's included" checklist for the selected package — exactly the
  /// items the customer saw when booking (e.g. "Dusting all surfaces").
  /// Rendered as a checklist in the task-detail screen.
  final List<String> includedItems;

  /// URL of a photo representing the task subject (e.g. the AC unit), shown in
  /// the detail header. Empty when the backend provides none.
  final String imageUrl;

  /// Combined date + time of the appointment. Formatting (e.g. "10:00 AM" or
  /// "24 مايو 2024") is done in the UI via `intl` so it respects the locale.
  final DateTime scheduledAt;
  final TaskStatus status;

  /// Whether the task is flagged urgent ("مهمة عاجلة" badge in the detail screen).
  final bool isUrgent;

  /// Long description shown in the task-detail screen.
  final String details;

  /// Tools the worker should bring, rendered as chips in the detail screen.
  final List<String> requiredTools;

  /// Photo paths/urls captured before starting and after finishing the job.
  final List<String> beforePhotos;
  final List<String> afterPhotos;

  const Task({
    required this.id,
    required this.requestNumber,
    required this.title,
    required this.serviceType,
    required this.customerName,
    required this.location,
    required this.scheduledAt,
    required this.status,
    this.imageUrl = '',
    this.companyName = '',
    this.packageName = '',
    this.price = 0,
    this.currency = '\$',
    this.durationLabel = '',
    this.includedItems = const [],
    this.isUrgent = false,
    this.details = '',
    this.requiredTools = const [],
    this.beforePhotos = const [],
    this.afterPhotos = const [],
  });

  /// Returns a copy with selected fields overridden. The bloc uses this to
  /// update a single task immutably (e.g. after a status change) instead of
  /// mutating the existing instance.
  Task copyWith({
    TaskStatus? status,
    bool? isUrgent,
    List<String>? beforePhotos,
    List<String>? afterPhotos,
  }) {
    return Task(
      id: id,
      requestNumber: requestNumber,
      title: title,
      serviceType: serviceType,
      customerName: customerName,
      location: location,
      imageUrl: imageUrl,
      companyName: companyName,
      packageName: packageName,
      price: price,
      currency: currency,
      durationLabel: durationLabel,
      includedItems: includedItems,
      scheduledAt: scheduledAt,
      status: status ?? this.status,
      isUrgent: isUrgent ?? this.isUrgent,
      details: details,
      requiredTools: requiredTools,
      beforePhotos: beforePhotos ?? this.beforePhotos,
      afterPhotos: afterPhotos ?? this.afterPhotos,
    );
  }

  @override
  List<Object?> get props => [
    id,
    requestNumber,
    title,
    serviceType,
    customerName,
    location,
    imageUrl,
    companyName,
    packageName,
    price,
    currency,
    durationLabel,
    includedItems,
    scheduledAt,
    status,
    isUrgent,
    details,
    requiredTools,
    beforePhotos,
    afterPhotos,
  ];
}
