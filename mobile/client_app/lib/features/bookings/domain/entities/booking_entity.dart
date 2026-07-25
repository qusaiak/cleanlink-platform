import 'package:equatable/equatable.dart';

enum OrderStatus {
  pending,
  assignedToWorker,
  inProgress,
  completed,
  canceled,
  unknown,
}

OrderStatus orderStatusFromApi(String? status) {
  switch (status?.trim().toLowerCase()) {
    case 'pending':
      return OrderStatus.pending;
    case 'assigned_to_worker':
      return OrderStatus.assignedToWorker;
    case 'in_progress':
      return OrderStatus.inProgress;
    case 'completed':
      return OrderStatus.completed;
    case 'canceled':
    case 'cancelled':
      return OrderStatus.canceled;
    default:
      return OrderStatus.unknown;
  }
}

String orderStatusApiValue(OrderStatus status) {
  switch (status) {
    case OrderStatus.pending:
      return 'pending';
    case OrderStatus.assignedToWorker:
      return 'assigned_to_worker';
    case OrderStatus.inProgress:
      return 'in_progress';
    case OrderStatus.completed:
      return 'completed';
    case OrderStatus.canceled:
      return 'canceled';
    case OrderStatus.unknown:
      return 'unknown';
  }
}

String formatUnknownOrderStatus(String? status) {
  final value = status?.trim();
  if (value == null || value.isEmpty) return 'Unknown';
  return value
      .split(RegExp(r'[_\s-]+'))
      .where((part) => part.isNotEmpty)
      .map((part) => '${part[0].toUpperCase()}${part.substring(1)}')
      .join(' ');
}

class OrderEntity extends Equatable {
  final int id;
  final int clientId;
  final int packageId;
  final String status;
  final String location;
  final DateTime? startTime;
  final DateTime? endTime;
  final int duration;
  final double totalPrice;
  final String? note;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final OrderClientEntity? client;
  final OrderLeaderEntity? leader;
  final OrderPackageEntity? package;
  final List<dynamic> attributes;

  const OrderEntity({
    required this.id,
    required this.clientId,
    required this.packageId,
    required this.status,
    required this.location,
    required this.startTime,
    required this.endTime,
    required this.duration,
    required this.totalPrice,
    this.note,
    this.createdAt,
    this.updatedAt,
    this.client,
    this.leader,
    this.package,
    this.attributes = const [],
  });

  OrderEntity copyWith({String? status, OrderLeaderEntity? leader}) =>
      OrderEntity(
        id: id,
        clientId: clientId,
        packageId: packageId,
        status: status ?? this.status,
        location: location,
        startTime: startTime,
        endTime: endTime,
        duration: duration,
        totalPrice: totalPrice,
        note: note,
        createdAt: createdAt,
        updatedAt: updatedAt,
        client: client,
        leader: leader ?? this.leader,
        package: package,
        attributes: attributes,
      );

  OrderStatus get statusType => orderStatusFromApi(status);

  bool get isPending => statusType == OrderStatus.pending;
  bool get isAssigned => statusType == OrderStatus.assignedToWorker;
  bool get isInProgress => statusType == OrderStatus.inProgress;
  bool get isCompleted => statusType == OrderStatus.completed;
  bool get isCanceled => statusType == OrderStatus.canceled;

  bool get canCancel {
    return statusType != OrderStatus.canceled &&
        statusType != OrderStatus.completed;
  }

  @override
  List<Object?> get props => [id, status, updatedAt, leader];
}

class OrderClientEntity extends Equatable {
  final int id;
  final String fullname;
  final String email;
  final String role;
  final OrderClientProfileEntity? profile;
  const OrderClientEntity({
    required this.id,
    required this.fullname,
    required this.email,
    required this.role,
    this.profile,
  });
  @override
  List<Object?> get props => [id, fullname, email, role, profile];
}

class OrderClientProfileEntity extends Equatable {
  final int id;
  final int userId;
  final String? image;
  final String? address;
  final String? phone;
  const OrderClientProfileEntity({
    required this.id,
    required this.userId,
    this.image,
    this.address,
    this.phone,
  });
  @override
  List<Object?> get props => [id, userId, image, address, phone];
}

class OrderLeaderEntity extends Equatable {
  final int id;
  final String fullname;
  final String email;
  final String? image;
  final String? phone;

  const OrderLeaderEntity({
    required this.id,
    required this.fullname,
    required this.email,
    this.image,
    this.phone,
  });

  @override
  List<Object?> get props => [id, fullname, email, image, phone];
}

class OrderPackageEntity extends Equatable {
  final int id;
  final int serviceId;
  final String name;
  final int duration;
  final double price;
  final double priceAfterDiscount;
  final List<String> details;
  final OrderServiceEntity? service;
  const OrderPackageEntity({
    required this.id,
    required this.serviceId,
    required this.name,
    required this.duration,
    required this.price,
    required this.priceAfterDiscount,
    this.details = const [],
    this.service,
  });
  @override
  List<Object?> get props => [id, name, duration, priceAfterDiscount, service];
}

class OrderServiceEntity extends Equatable {
  final int id;
  final int companyId;
  final int categoryId;
  final String name;
  final String description;
  final double rating;
  final int minDuration;
  final int maxDuration;
  final double price;
  final String? image;
  final double discount;
  final bool isFavorite;
  final OrderCompanyEntity? company;
  const OrderServiceEntity({
    required this.id,
    required this.companyId,
    required this.categoryId,
    required this.name,
    required this.description,
    required this.rating,
    required this.minDuration,
    required this.maxDuration,
    required this.price,
    this.image,
    required this.discount,
    required this.isFavorite,
    this.company,
  });
  @override
  List<Object?> get props => [id, name, company];
}

class OrderCompanyEntity extends Equatable {
  final int id;
  final int managerId;
  final int regionId;
  final String name;
  final String description;
  final String? image;
  final String location;
  final double rating;
  final bool isFavorite;
  final OrderRegionEntity? region;
  const OrderCompanyEntity({
    required this.id,
    required this.managerId,
    required this.regionId,
    required this.name,
    required this.description,
    this.image,
    required this.location,
    required this.rating,
    required this.isFavorite,
    this.region,
  });
  @override
  List<Object?> get props => [id, name, location, region];
}

class OrderRegionEntity extends Equatable {
  final int id;
  final String name;
  final int managerId;
  final String? image;
  const OrderRegionEntity({
    required this.id,
    required this.name,
    required this.managerId,
    this.image,
  });
  @override
  List<Object?> get props => [id, name, managerId, image];
}

typedef BookingEntity = OrderEntity;
