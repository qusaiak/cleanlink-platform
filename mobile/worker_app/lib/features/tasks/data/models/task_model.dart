import '../../../../config/constants/api_url_parameters.dart';
import '../../../../config/language/app_language_info.dart';
import '../../../../core/session/login_session.dart';
import '../../domain/entities/task.dart';

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
    super.workgroupId,
    super.workgroupName,
    super.teamMembers,
    super.endAt,
    super.durationMinutes,
    super.travelBufferMinutes,
    super.latitude,
    super.longitude,
    super.serviceDescription,
    super.packageDetails,
    super.minimumWorkers,
    super.customerEmail,
    super.customerPhone,
    super.paymentMethod,
    super.paymentStatus,
    super.orderStatus,
    super.createdAt,
    super.updatedAt,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json, {String? idOverride}) {
    final order = (json['order'] as Map<String, dynamic>?) ?? const {};
    final package = (order['package'] as Map<String, dynamic>?) ?? const {};

    final service =
        (package['service'] as Map<String, dynamic>?) ??
        (json['service'] as Map<String, dynamic>?) ??
        const {};

    final company =
        (service['company'] as Map<String, dynamic>?) ??
        (json['company'] as Map<String, dynamic>?) ??
        const {};
    final workgroup = (json['workgroup'] as Map<String, dynamic>?) ?? const {};
    final client = (order['client'] as Map<String, dynamic>?) ?? const {};
    final leader = (workgroup['leader'] as Map<String, dynamic>?) ?? const {};
    final leaderId = (workgroup['leader_id'] ?? leader['id'])?.toString() ?? '';
    final teamMembers = _teamMembers(workgroup, leader, leaderId);

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
      id: (idOverride ?? json['id'] ?? json['task_id'])?.toString() ?? '',
      requestNumber:
          (json['requestNumber'] ??
                  json['request_number'] ??
                  json['order_id'] ??
                  order['id'] ??
                  '')
              .toString(),
      title: (json['title'] ?? serviceTitle ?? '').toString(),
      serviceType: _serviceTypeFromCode(
        (json['serviceType'] ?? json['service_type'])?.toString(),
      ),
      customerName:
          (json['customerName'] ??
                  json['customer_name'] ??
                  client['fullname'] ??
                  '')
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
      companyName:
          (json['companyName'] ??
                  json['company_name'] ??
                  workgroup['name'] ??
                  '')
              .toString(),
      packageName:
          (json['packageName'] ?? json['package_name'] ?? packageTitle ?? '')
              .toString(),
      price: _toDouble(json['price'] ?? order['total_price']),
      currency: (json['currency'] ?? '').toString(),
      durationLabel:
          (json['durationLabel'] ??
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

      status: _statusFromCode((json['status'] ?? order['status'])?.toString()),
      isUrgent: json['isUrgent'] ?? json['is_urgent'] ?? false,
      details: (json['details'] ?? order['note'] ?? '').toString(),
      requiredTools: _stringList(
        json['requiredTools'] ?? json['required_tools'],
      ),
      beforePhotos: _photoList(
        json['beforePhotos'] ?? json['before_photos'] ?? json['image_before'],
      ),
      afterPhotos: _photoList(
        json['afterPhotos'] ?? json['after_photos'] ?? json['image_after'],
      ),
      serviceRating: _toDouble(
        json['serviceRating'] ?? json['service_rating'] ?? service['rating'],
      ),
      isTeamLeader: _isLeader(leaderId),
      leaderName:
          (json['leaderName'] ??
                  json['leader_name'] ??
                  leader['fullname'] ??
                  '')
              .toString(),
      leaderId: (json['leaderId'] ?? json['leader_id'] ?? leaderId).toString(),
      workgroupId: (json['workgroup_id'] ?? workgroup['id'])?.toString() ?? '',
      workgroupName: (workgroup['name'] ?? '').toString(),
      teamMembers: teamMembers,
      endAt: _date(order['end_time']),
      durationMinutes: _toIntOrNull(order['duration']),
      travelBufferMinutes: _toIntOrNull(order['travel_buffer_minutes']),
      latitude: _toDoubleOrNull(order['latitude']),
      longitude: _toDoubleOrNull(order['longitude']),
      serviceDescription: (service['description'] ?? '').toString(),
      packageDetails: _stringList(packageDetails),
      minimumWorkers: _toIntOrNull(package['minimum_workers']),
      customerEmail: (client['email'] ?? '').toString(),
      customerPhone:
          (client['phone'] ??
                  (client['profile'] is Map
                      ? client['profile']['phone']
                      : null) ??
                  '')
              .toString(),
      paymentMethod: (order['payment_method'] ?? '').toString(),
      paymentStatus: (order['payment_status'] ?? '').toString(),
      orderStatus: (order['status'] ?? '').toString(),
      createdAt: _date(json['created_at']),
      updatedAt: _date(json['updated_at']),
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
    'workgroupId': workgroupId,
    'workgroupName': workgroupName,
    'teamMembers': teamMembers
        .map((member) => {'id': member.id, 'name': member.name})
        .toList(),
    'endAt': endAt?.toIso8601String(),
    'durationMinutes': durationMinutes,
    'travelBufferMinutes': travelBufferMinutes,
    'latitude': latitude,
    'longitude': longitude,
    'serviceDescription': serviceDescription,
    'packageDetails': packageDetails,
    'minimumWorkers': minimumWorkers,
    'customerEmail': customerEmail,
    'customerPhone': customerPhone,
    'paymentMethod': paymentMethod,
    'paymentStatus': paymentStatus,
    'orderStatus': orderStatus,
    'createdAt': createdAt?.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
  };

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
    workgroupId: task.workgroupId,
    workgroupName: task.workgroupName,
    teamMembers: task.teamMembers,
    endAt: task.endAt,
    durationMinutes: task.durationMinutes,
    travelBufferMinutes: task.travelBufferMinutes,
    latitude: task.latitude,
    longitude: task.longitude,
    serviceDescription: task.serviceDescription,
    packageDetails: task.packageDetails,
    minimumWorkers: task.minimumWorkers,
    customerEmail: task.customerEmail,
    customerPhone: task.customerPhone,
    paymentMethod: task.paymentMethod,
    paymentStatus: task.paymentStatus,
    orderStatus: task.orderStatus,
    createdAt: task.createdAt,
    updatedAt: task.updatedAt,
  );

  static List<TaskTeamMember> _teamMembers(
    Map<String, dynamic> workgroup,
    Map<String, dynamic> leader,
    String leaderId,
  ) {
    final rawWorkers = workgroup['workers'];
    final workers = rawWorkers is List
        ? rawWorkers.whereType<Map>()
        : const <Map>[];
    final result = <TaskTeamMember>[
      for (final raw in workers)
        _member(Map<String, dynamic>.from(raw), leaderId),
    ];
    if (leader.isNotEmpty && !result.any((member) => member.id == leaderId)) {
      result.insert(0, _member(leader, leaderId));
    }
    result.sort((a, b) {
      if (a.isLeader != b.isLeader) return a.isLeader ? -1 : 1;
      if (a.isCurrentWorker != b.isCurrentWorker) {
        return a.isCurrentWorker ? -1 : 1;
      }
      return a.name.compareTo(b.name);
    });
    return result;
  }

  static TaskTeamMember _member(Map<String, dynamic> json, String leaderId) {
    final id = json['id']?.toString() ?? '';
    final profile = json['profile'] is Map
        ? Map<String, dynamic>.from(json['profile'] as Map)
        : const <String, dynamic>{};
    return TaskTeamMember(
      id: id,
      name: (json['fullname'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      imageUrl: ApiUrlParameters.resolveImageUrl(
        (profile['image'] ?? json['image'] ?? '').toString(),
      ),
      isLeader: id.isNotEmpty && id == leaderId,
      isCurrentWorker:
          id.isNotEmpty && id == (LoginSession.employeeId ?? '').toString(),
    );
  }

  static List<String> _stringList(dynamic value) {
    if (value is List) return value.map((e) => e.toString()).toList();
    return const [];
  }

  static List<String> _photoList(dynamic value) {
    if (value is List) return value.map((e) => e.toString()).toList();
    if (value == null) return const [];
    return [value.toString()];
  }

  static bool _isLeader(dynamic leaderId) {
    final currentWorkerId = LoginSession.employeeId;
    if (leaderId == null || currentWorkerId == null) return false;
    return leaderId.toString() == currentWorkerId;
  }

  static String _durationLabel(dynamic minutes) {
    if (minutes == null) return '';
    return minutes.toString();
  }

  static double _toDouble(dynamic value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0;
    return 0;
  }

  static double? _toDoubleOrNull(dynamic value) {
    if (value == null || value.toString().isEmpty) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString());
  }

  static int? _toIntOrNull(dynamic value) {
    if (value == null || value.toString().isEmpty) return null;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString());
  }

  static DateTime? _date(dynamic value) =>
      DateTime.tryParse(value?.toString() ?? '');

  static TaskStatus _statusFromCode(String? code) {
    switch (code) {
      case 'on_the_way':
      case 'on_way':
        return TaskStatus.onTheWay;

      case 'handling':
      case 'in_progress':
        return TaskStatus.inProgress;
      case 'done':
      case 'completed':
        return TaskStatus.completed;
      case 'pending':
      case 'assigned':
      default:
        return TaskStatus.assigned;
    }
  }

  static String statusCode(TaskStatus status) {
    switch (status) {
      case TaskStatus.assigned:
        return 'pending';
      case TaskStatus.onTheWay:
        return 'on_way';
      case TaskStatus.inProgress:
        return 'handling';
      case TaskStatus.completed:
        return 'done';
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
