import '../../../../config/constants/api_url_parameters.dart';
import '../../../../config/language/app_language_info.dart';
import '../../../../core/session/login_session.dart';
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
    super.companyImageUrl,
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
    super.serviceRating,
    super.isTeamLeader,
    super.leaderName,
    super.leaderId,
  });

  /// Builds a [TaskModel] from either the flat contract (used by the mock
  /// data source, camelCase/snake_case keys) or the real worker-tasks-log
  /// contract, which nests the booking under `order` (with
  /// `order.package.service`) and the crew under `workgroup`. That real
  /// contract has two shapes in practice: the `GET /api/tasks` list gives
  /// localized `name_en`/`name_ar`/`details_en`/`details_ar`, while the
  /// `GET /api/tasks/{id}` detail gives a single unlocalized `name`/`details`
  /// — both are handled here.
  ///
  /// [idOverride] is used when the caller already knows the task's id (e.g.
  /// the id it requested `/api/tasks/{id}` with) because the detail endpoint's
  /// response body doesn't include the task's own `id` field at all.
  factory TaskModel.fromJson(Map<String, dynamic> json, {String? idOverride}) {
    final order = (json['order'] as Map<String, dynamic>?) ?? const {};
    final package = (order['package'] as Map<String, dynamic>?) ?? const {};
    // Both `GET /api/tasks` (list) and `GET /api/tasks/{id}` (detail) nest
    // `service` the same way: `order.package.service`. A top-level `service`
    // key is kept as a fallback for older/flat payloads (e.g. the mock data).
    final service = (package['service'] as Map<String, dynamic>?) ??
        (json['service'] as Map<String, dynamic>?) ??
        const {};
    // The provider's photo lives under `service.company.image`.
    final company = (service['company'] as Map<String, dynamic>?) ??
        (json['company'] as Map<String, dynamic>?) ??
        const {};
    final workgroup = (json['workgroup'] as Map<String, dynamic>?) ?? const {};
    final client = (order['client'] as Map<String, dynamic>?) ?? const {};
    final leader = (workgroup['leader'] as Map<String, dynamic>?) ?? const {};

    final useEn = AppLanguageInfo.isEn;
    final serviceTitle = useEn
        ? (service['name_en'] ?? service['name_ar'] ?? service['name'])
        : (service['name_ar'] ?? service['name_en'] ?? service['name']);
    final packageTitle = useEn
        ? (package['name_en'] ?? package['name_ar'] ?? package['name'])
        : (package['name_ar'] ?? package['name_en'] ?? package['name']);
    final packageDetails = useEn
        ? (package['details_en'] ?? package['details'])
        : (package['details_ar'] ?? package['details']);

    return TaskModel(
      // The task is addressed by its `workgroup_id` on the API: the routes
      // `GET /api/tasks/{id}` and `POST /api/tasks/{id}/update-status` resolve
      // the task by workgroup (see `Task::getRouteKeyName()` on the backend),
      // because the payload never exposes the task's own primary key. Both the
      // list and the detail responses carry `workgroup_id` at the top level.
      // (`requestNumber` below keeps the human-facing order id for display.)
      id: (idOverride ??
                  json['workgroup_id'] ??
                  json['id'] ??
                  json['order_id'] ??
                  order['id'])
              ?.toString() ??
          '',
      requestNumber: (json['requestNumber'] ??
              json['request_number'] ??
              json['order_id'] ??
              order['id'] ??
              '')
          .toString(),
      title: (json['title'] ?? serviceTitle ?? '').toString(),
      serviceType: _serviceTypeFromCode(
        (json['serviceType'] ?? json['service_type'])?.toString(),
      ),
      customerName: (json['customerName'] ??
              json['customer_name'] ??
              client['fullname'] ??
              _clientLabel(order['client_id']))
          .toString(),
      location: (json['location'] ?? order['location'] ?? '').toString(),
      imageUrl: ApiUrlParameters.resolveImageUrl(
        (service['image'] ??
                json['imageUrl'] ??
                json['image_url'] ??
                json['image_before'] ??
                '')
            .toString(),
      ),
      companyImageUrl: ApiUrlParameters.resolveImageUrl(
        (company['image'] ?? '').toString(),
      ),
      companyName: (json['companyName'] ??
              json['company_name'] ??
              workgroup['name'] ??
              '')
          .toString(),
      packageName: (json['packageName'] ??
              json['package_name'] ??
              packageTitle ??
              '')
          .toString(),
      price: _toDouble(json['price'] ?? order['total_price']),
      currency: (json['currency'] ?? '\$').toString(),
      durationLabel: (json['durationLabel'] ??
              json['duration_label'] ??
              _durationLabel(order['duration']))
          .toString(),
      includedItems: _stringList(
        json['includedItems'] ?? json['included_items'] ?? packageDetails,
      ),
      scheduledAt:
          DateTime.tryParse(
            (json['scheduledAt'] ??
                    json['scheduled_at'] ??
                    order['start_time'] ??
                    '')
                .toString(),
          ) ??
          DateTime.fromMillisecondsSinceEpoch(0),
      // The task's own `status` (e.g. "done") is authoritative; the order's
      // `status` (e.g. "completed") is only a fallback for payloads that
      // don't carry a task-level status.
      status: _statusFromCode((json['status'] ?? order['status'])?.toString()),
      isUrgent: json['isUrgent'] ?? json['is_urgent'] ?? false,
      details: (json['details'] ?? order['note'] ?? '').toString(),
      requiredTools: _stringList(json['requiredTools'] ?? json['required_tools']),
      beforePhotos: _photoList(
        json['beforePhotos'] ?? json['before_photos'] ?? json['image_before'],
      ),
      afterPhotos: _photoList(
        json['afterPhotos'] ?? json['after_photos'] ?? json['image_after'],
      ),
      serviceRating: _toDouble(
        json['serviceRating'] ?? json['service_rating'] ?? service['rating'],
      ),
      isTeamLeader: _isLeader(leader['id']),
      leaderName: (json['leaderName'] ?? json['leader_name'] ?? leader['fullname'] ?? '')
          .toString(),
      leaderId: (json['leaderId'] ?? json['leader_id'] ?? leader['id'])?.toString() ?? '',
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
    'companyImageUrl': companyImageUrl,
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
    'serviceRating': serviceRating,
    'isTeamLeader': isTeamLeader,
    'leaderName': leaderName,
    'leaderId': leaderId,
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
    companyImageUrl: task.companyImageUrl,
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
    serviceRating: task.serviceRating,
    isTeamLeader: task.isTeamLeader,
    leaderName: task.leaderName,
    leaderId: task.leaderId,
  );

  // ---- enum <-> string code mapping (kept here so the contract is in one place) ----

  static List<String> _stringList(dynamic value) {
    if (value is List) return value.map((e) => e.toString()).toList();
    return const [];
  }

  /// Wraps a single nullable photo URL (as returned by `image_before`/
  /// `image_after`) into a list, or passes an already-a-list value through.
  static List<String> _photoList(dynamic value) {
    if (value is List) return value.map((e) => e.toString()).toList();
    if (value == null) return const [];
    return [value.toString()];
  }

  /// The task log only carries the customer's `client_id`, not their name, so
  /// this is the best label available until the backend includes the client.
  static String _clientLabel(dynamic clientId) {
    if (clientId == null) return '';
    return 'Client #$clientId';
  }

  /// Whether the signed-in worker (from [LoginSession.employeeId], set on
  /// login) is the workgroup's [leaderId].
  static bool _isLeader(dynamic leaderId) {
    final currentWorkerId = LoginSession.employeeId;
    if (leaderId == null || currentWorkerId == null) return false;
    return leaderId.toString() == currentWorkerId;
  }

  static String _durationLabel(dynamic minutes) {
    if (minutes == null) return '';
    return '$minutes mins';
  }

  static double _toDouble(dynamic value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0;
    return 0;
  }

  static TaskStatus _statusFromCode(String? code) {
    switch (code) {
      case 'on_the_way':
      case 'on_way':
        return TaskStatus.onTheWay;
      // "handling" is the backend's code for a task being executed.
      case 'handling':
      case 'in_progress':
        return TaskStatus.inProgress;
      case 'paused':
        return TaskStatus.paused;
      // The backend marks a finished task "done" (its order becomes
      // "completed") — both map to the same UI status.
      case 'done':
      case 'completed':
        return TaskStatus.completed;
      case 'cancelled':
        return TaskStatus.cancelled;
      case 'pending':
      case 'assigned':
      default:
        return TaskStatus.assigned;
    }
  }

  /// The backend's status codes: the update-status contract accepts exactly
  /// `pending | on_way | handling | done`. `paused`/`cancelled` are legacy
  /// UI-only statuses that the progression logic never sends.
  static String statusCode(TaskStatus status) {
    switch (status) {
      case TaskStatus.assigned:
        return 'pending';
      case TaskStatus.onTheWay:
        return 'on_way';
      case TaskStatus.inProgress:
        return 'handling';
      case TaskStatus.paused:
        return 'paused';
      case TaskStatus.completed:
        return 'done';
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
