import '../../domain/entities/task.dart';

/// Data-layer representation of [Task]. Extends the entity so it can be used
/// anywhere a [Task] is expected, while adding JSON (de)serialization for the
/// API. Enum values are mapped to/from stable string codes shared with the
/// backend contract.
class TaskModel extends Task {
  const TaskModel({
    required super.id,
    required super.requestNumber,
    required super.title,
    required super.serviceType,
    required super.customerName,
    required super.location,
    required super.scheduledAt,
    required super.status,
    super.imageUrl,
    super.companyName,
    super.packageName,
    super.price,
    super.currency,
    super.durationLabel,
    super.includedItems,
    super.isUrgent,
    super.details,
    super.requiredTools,
    super.beforePhotos,
    super.afterPhotos,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'].toString(),
      requestNumber: (json['requestNumber'] ?? json['request_number'] ?? '')
          .toString(),
      title: (json['title'] ?? '').toString(),
      serviceType: _serviceTypeFromCode(
        (json['serviceType'] ?? json['service_type'])?.toString(),
      ),
      customerName: (json['customerName'] ?? json['customer_name'] ?? '')
          .toString(),
      location: (json['location'] ?? '').toString(),
      imageUrl: (json['imageUrl'] ?? json['image_url'] ?? '').toString(),
      companyName: (json['companyName'] ?? json['company_name'] ?? '')
          .toString(),
      packageName: (json['packageName'] ?? json['package_name'] ?? '')
          .toString(),
      price: _toDouble(json['price']),
      currency: (json['currency'] ?? '\$').toString(),
      durationLabel: (json['durationLabel'] ?? json['duration_label'] ?? '')
          .toString(),
      includedItems: _stringList(
        json['includedItems'] ?? json['included_items'],
      ),
      scheduledAt:
          DateTime.tryParse(
            (json['scheduledAt'] ?? json['scheduled_at'] ?? '').toString(),
          ) ??
          DateTime.fromMillisecondsSinceEpoch(0),
      status: _statusFromCode((json['status'])?.toString()),
      isUrgent: json['isUrgent'] ?? json['is_urgent'] ?? false,
      details: (json['details'] ?? '').toString(),
      requiredTools: _stringList(json['requiredTools'] ?? json['required_tools']),
      beforePhotos: _stringList(json['beforePhotos'] ?? json['before_photos']),
      afterPhotos: _stringList(json['afterPhotos'] ?? json['after_photos']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'requestNumber': requestNumber,
    'title': title,
    'serviceType': serviceTypeCode(serviceType),
    'customerName': customerName,
    'location': location,
    'imageUrl': imageUrl,
    'companyName': companyName,
    'packageName': packageName,
    'price': price,
    'currency': currency,
    'durationLabel': durationLabel,
    'includedItems': includedItems,
    'scheduledAt': scheduledAt.toIso8601String(),
    'status': statusCode(status),
    'isUrgent': isUrgent,
    'details': details,
    'requiredTools': requiredTools,
    'beforePhotos': beforePhotos,
    'afterPhotos': afterPhotos,
  };

  /// Builds a model from a domain [Task] (used by the fake data source and
  /// when echoing locally-updated tasks back through the layers).
  factory TaskModel.fromEntity(Task task) => TaskModel(
    id: task.id,
    requestNumber: task.requestNumber,
    title: task.title,
    serviceType: task.serviceType,
    customerName: task.customerName,
    location: task.location,
    imageUrl: task.imageUrl,
    companyName: task.companyName,
    packageName: task.packageName,
    price: task.price,
    currency: task.currency,
    durationLabel: task.durationLabel,
    includedItems: task.includedItems,
    scheduledAt: task.scheduledAt,
    status: task.status,
    isUrgent: task.isUrgent,
    details: task.details,
    requiredTools: task.requiredTools,
    beforePhotos: task.beforePhotos,
    afterPhotos: task.afterPhotos,
  );

  // ---- enum <-> string code mapping (kept here so the contract is in one place) ----

  static List<String> _stringList(dynamic value) {
    if (value is List) return value.map((e) => e.toString()).toList();
    return const [];
  }

  static double _toDouble(dynamic value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0;
    return 0;
  }

  static TaskStatus _statusFromCode(String? code) {
    switch (code) {
      case 'on_the_way':
        return TaskStatus.onTheWay;
      case 'in_progress':
        return TaskStatus.inProgress;
      case 'paused':
        return TaskStatus.paused;
      case 'completed':
        return TaskStatus.completed;
      case 'cancelled':
        return TaskStatus.cancelled;
      case 'assigned':
      default:
        return TaskStatus.assigned;
    }
  }

  static String statusCode(TaskStatus status) {
    switch (status) {
      case TaskStatus.assigned:
        return 'assigned';
      case TaskStatus.onTheWay:
        return 'on_the_way';
      case TaskStatus.inProgress:
        return 'in_progress';
      case TaskStatus.paused:
        return 'paused';
      case TaskStatus.completed:
        return 'completed';
      case TaskStatus.cancelled:
        return 'cancelled';
    }
  }

  static ServiceType _serviceTypeFromCode(String? code) {
    switch (code) {
      case 'ac_maintenance':
        return ServiceType.acMaintenance;
      case 'plumbing':
        return ServiceType.plumbing;
      case 'electrical':
        return ServiceType.electrical;
      case 'cleaning':
        return ServiceType.cleaning;
      case 'general':
      default:
        return ServiceType.general;
    }
  }

  static String serviceTypeCode(ServiceType type) {
    switch (type) {
      case ServiceType.acMaintenance:
        return 'ac_maintenance';
      case ServiceType.plumbing:
        return 'plumbing';
      case ServiceType.electrical:
        return 'electrical';
      case ServiceType.cleaning:
        return 'cleaning';
      case ServiceType.general:
        return 'general';
    }
  }
}
