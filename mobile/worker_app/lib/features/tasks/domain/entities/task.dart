import 'package:equatable/equatable.dart';

enum TaskStatus { assigned, onTheWay, inProgress, completed }

extension TaskStatusProgression on TaskStatus {
  static const List<TaskStatus> sequence = [
    TaskStatus.assigned,
    TaskStatus.onTheWay,
    TaskStatus.inProgress,
    TaskStatus.completed,
  ];

  TaskStatus? get next {
    switch (this) {
      case TaskStatus.assigned:
        return TaskStatus.onTheWay;
      case TaskStatus.onTheWay:
        return TaskStatus.inProgress;
      case TaskStatus.inProgress:
        return TaskStatus.completed;
      case TaskStatus.completed:
        return null;
    }
  }

  bool canAdvanceTo(TaskStatus target) => next == target;
}

enum ServiceType { acMaintenance, plumbing, electrical, cleaning, general }

class TaskTeamMember extends Equatable {
  final String id;
  final String name;
  final String email;
  final String imageUrl;
  final bool isLeader;
  final bool isCurrentWorker;

  const TaskTeamMember({
    required this.id,
    required this.name,
    this.email = '',
    this.imageUrl = '',
    this.isLeader = false,
    this.isCurrentWorker = false,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    email,
    imageUrl,
    isLeader,
    isCurrentWorker,
  ];
}

class Task extends Equatable {
  final String id;

  final String requestNumber;
  final String title;
  final ServiceType serviceType;
  final String customerName;
  final String location;

  final String companyName;

  final String packageName;

  final double price;

  final String currency;

  final String durationLabel;

  final List<String> includedItems;

  final String imageUrl;

  final String companyImageUrl;

  final DateTime scheduledAt;
  final TaskStatus status;

  final bool isUrgent;

  final String details;

  final List<String> requiredTools;

  final List<String> beforePhotos;
  final List<String> afterPhotos;

  final double serviceRating;

  final bool isTeamLeader;

  final String leaderName;

  final String leaderId;
  final String workgroupId;
  final String workgroupName;
  final List<TaskTeamMember> teamMembers;
  final DateTime? endAt;
  final int? durationMinutes;
  final int? travelBufferMinutes;
  final double? latitude;
  final double? longitude;
  final String serviceDescription;
  final List<String> packageDetails;
  final int? minimumWorkers;
  final String customerEmail;
  final String customerPhone;
  final String paymentMethod;
  final String paymentStatus;
  final String orderStatus;
  final DateTime? createdAt;
  final DateTime? updatedAt;

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
    this.companyImageUrl = '',
    this.companyName = '',
    this.packageName = '',
    this.price = 0,
    this.currency = '',
    this.durationLabel = '',
    this.includedItems = const [],
    this.isUrgent = false,
    this.details = '',
    this.requiredTools = const [],
    this.beforePhotos = const [],
    this.afterPhotos = const [],
    this.serviceRating = 0,
    this.isTeamLeader = false,
    this.leaderName = '',
    this.leaderId = '',
    this.workgroupId = '',
    this.workgroupName = '',
    this.teamMembers = const [],
    this.endAt,
    this.durationMinutes,
    this.travelBufferMinutes,
    this.latitude,
    this.longitude,
    this.serviceDescription = '',
    this.packageDetails = const [],
    this.minimumWorkers,
    this.customerEmail = '',
    this.customerPhone = '',
    this.paymentMethod = '',
    this.paymentStatus = '',
    this.orderStatus = '',
    this.createdAt,
    this.updatedAt,
  });

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
      companyImageUrl: companyImageUrl,
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
      serviceRating: serviceRating,
      isTeamLeader: isTeamLeader,
      leaderName: leaderName,
      leaderId: leaderId,
      workgroupId: workgroupId,
      workgroupName: workgroupName,
      teamMembers: teamMembers,
      endAt: endAt,
      durationMinutes: durationMinutes,
      travelBufferMinutes: travelBufferMinutes,
      latitude: latitude,
      longitude: longitude,
      serviceDescription: serviceDescription,
      packageDetails: packageDetails,
      minimumWorkers: minimumWorkers,
      customerEmail: customerEmail,
      customerPhone: customerPhone,
      paymentMethod: paymentMethod,
      paymentStatus: paymentStatus,
      orderStatus: orderStatus,
      createdAt: createdAt,
      updatedAt: updatedAt,
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
    companyImageUrl,
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
    serviceRating,
    isTeamLeader,
    leaderName,
    leaderId,
    workgroupId,
    workgroupName,
    teamMembers,
    endAt,
    durationMinutes,
    travelBufferMinutes,
    latitude,
    longitude,
    serviceDescription,
    packageDetails,
    minimumWorkers,
    customerEmail,
    customerPhone,
    paymentMethod,
    paymentStatus,
    orderStatus,
    createdAt,
    updatedAt,
  ];
}
