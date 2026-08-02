import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/booking_entity.dart';

part 'booking_model.g.dart';

double _doubleFromJson(Object? value) => value is num
    ? value.toDouble()
    : double.tryParse(value?.toString() ?? '') ?? 0;
double? _nullableDoubleFromJson(Object? value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString());
}

int _intFromJson(Object? value) =>
    value is num ? value.toInt() : int.tryParse(value?.toString() ?? '') ?? 0;

@JsonSerializable(fieldRename: FieldRename.snake)
class BookingModel {
  final int? id;
  final int? clientId;
  final int? packageId;
  final String? status;
  final String? location;
  final DateTime? startTime;
  final DateTime? endTime;
  @JsonKey(fromJson: _intFromJson)
  final int duration;
  @JsonKey(fromJson: _doubleFromJson)
  final double totalPrice;
  final String? note;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final OrderClientModel? client;
  final OrderLeaderModel? leader;
  final OrderPackageModel? package;
  final List<dynamic>? attributes;
  const BookingModel({
    this.id,
    this.clientId,
    this.packageId,
    this.status,
    this.location,
    this.startTime,
    this.endTime,
    this.duration = 0,
    this.totalPrice = 0,
    this.note,
    this.createdAt,
    this.updatedAt,
    this.client,
    this.leader,
    this.package,
    this.attributes,
  });
  factory BookingModel.fromJson(Map<String, dynamic> json) =>
      _$BookingModelFromJson(json);
  Map<String, dynamic> toJson() => _$BookingModelToJson(this);
  OrderEntity toEntity() => OrderEntity(
    id: id ?? 0,
    clientId: clientId ?? 0,
    packageId: packageId ?? 0,
    status: status ?? '',
    location: location ?? '',
    startTime: startTime,
    endTime: endTime,
    duration: duration,
    totalPrice: totalPrice,
    note: note,
    createdAt: createdAt,
    updatedAt: updatedAt,
    client: client?.toEntity(),
    leader: leader?.toEntity(),
    package: package?.toEntity(),
    attributes: attributes ?? const [],
  );
}

@JsonSerializable(fieldRename: FieldRename.snake)
class OrderClientModel {
  final int? id;
  final String? fullname;
  final String? email;
  final String? role;
  final OrderClientProfileModel? profile;
  const OrderClientModel({
    this.id,
    this.fullname,
    this.email,
    this.role,
    this.profile,
  });
  factory OrderClientModel.fromJson(Map<String, dynamic> json) =>
      _$OrderClientModelFromJson(json);
  Map<String, dynamic> toJson() => _$OrderClientModelToJson(this);
  OrderClientEntity toEntity() => OrderClientEntity(
    id: id ?? 0,
    fullname: fullname ?? '',
    email: email ?? '',
    role: role ?? '',
    profile: profile?.toEntity(),
  );
}

@JsonSerializable(fieldRename: FieldRename.snake)
class OrderClientProfileModel {
  final int? id;
  final int? userId;
  final String? image;
  final String? address;
  final String? phone;
  const OrderClientProfileModel({
    this.id,
    this.userId,
    this.image,
    this.address,
    this.phone,
  });
  factory OrderClientProfileModel.fromJson(Map<String, dynamic> json) =>
      _$OrderClientProfileModelFromJson(json);
  Map<String, dynamic> toJson() => _$OrderClientProfileModelToJson(this);
  OrderClientProfileEntity toEntity() => OrderClientProfileEntity(
    id: id ?? 0,
    userId: userId ?? 0,
    image: image,
    address: address,
    phone: phone,
  );
}

@JsonSerializable(fieldRename: FieldRename.snake)
class OrderLeaderModel {
  final int? id;
  final String? fullname;
  final String? email;
  final String? role;
  final OrderLeaderProfileModel? profile;

  const OrderLeaderModel({
    this.id,
    this.fullname,
    this.email,
    this.role,
    this.profile,
  });

  factory OrderLeaderModel.fromJson(Map<String, dynamic> json) =>
      _$OrderLeaderModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderLeaderModelToJson(this);

  OrderLeaderEntity toEntity() => OrderLeaderEntity(
    id: id ?? 0,
    fullname: fullname ?? '',
    email: email ?? '',
    image: profile?.image,
    phone: profile?.phone,
  );
}

@JsonSerializable(fieldRename: FieldRename.snake)
class OrderLeaderProfileModel {
  final int? id;
  final int? userId;
  final String? image;
  final String? address;
  final String? phone;
  final String? createdAt;
  final String? updatedAt;

  const OrderLeaderProfileModel({
    this.id,
    this.userId,
    this.image,
    this.address,
    this.phone,
    this.createdAt,
    this.updatedAt,
  });

  factory OrderLeaderProfileModel.fromJson(Map<String, dynamic> json) =>
      _$OrderLeaderProfileModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderLeaderProfileModelToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class OrderPackageModel {
  final int? id;
  final int? serviceId;
  final String? name;
  @JsonKey(fromJson: _intFromJson)
  final int duration;
  @JsonKey(fromJson: _doubleFromJson)
  final double price;
  @JsonKey(fromJson: _doubleFromJson)
  final double priceAfterDiscount;
  final List<String>? details;
  final OrderServiceModel? service;
  const OrderPackageModel({
    this.id,
    this.serviceId,
    this.name,
    this.duration = 0,
    this.price = 0,
    this.priceAfterDiscount = 0,
    this.details,
    this.service,
  });
  factory OrderPackageModel.fromJson(Map<String, dynamic> json) =>
      _$OrderPackageModelFromJson(json);
  Map<String, dynamic> toJson() => _$OrderPackageModelToJson(this);
  OrderPackageEntity toEntity() => OrderPackageEntity(
    id: id ?? 0,
    serviceId: serviceId ?? 0,
    name: name ?? '',
    duration: duration,
    price: price,
    priceAfterDiscount: priceAfterDiscount,
    details: details ?? const [],
    service: service?.toEntity(),
  );
}

@JsonSerializable(fieldRename: FieldRename.snake)
class OrderServiceModel {
  final int? id;
  final int? companyId;
  final int? categoryId;
  final String? name;
  final String? description;
  @JsonKey(fromJson: _doubleFromJson)
  final double rating;
  @JsonKey(fromJson: _intFromJson)
  final int minDuration;
  @JsonKey(fromJson: _intFromJson)
  final int maxDuration;
  @JsonKey(name: 'minimum_price', fromJson: _nullableDoubleFromJson)
  final double? minPrice;
  @JsonKey(name: 'maximum_price', fromJson: _nullableDoubleFromJson)
  final double? maxPrice;
  final String? image;
  @JsonKey(fromJson: _doubleFromJson)
  final double discount;
  final bool? isFavorite;
  final OrderCompanyModel? company;
  const OrderServiceModel({
    this.id,
    this.companyId,
    this.categoryId,
    this.name,
    this.description,
    this.rating = 0,
    this.minDuration = 0,
    this.maxDuration = 0,
    this.minPrice,
    this.maxPrice,
    this.image,
    this.discount = 0,
    this.isFavorite,
    this.company,
  });
  factory OrderServiceModel.fromJson(Map<String, dynamic> json) =>
      _$OrderServiceModelFromJson(json);
  Map<String, dynamic> toJson() => _$OrderServiceModelToJson(this);
  OrderServiceEntity toEntity() => OrderServiceEntity(
    id: id ?? 0,
    companyId: companyId ?? 0,
    categoryId: categoryId ?? 0,
    name: name ?? '',
    description: description ?? '',
    rating: rating,
    minDuration: minDuration,
    maxDuration: maxDuration,
    minPrice: minPrice,
    maxPrice: maxPrice,
    image: image,
    discount: discount,
    isFavorite: isFavorite ?? false,
    company: company?.toEntity(),
  );
}

@JsonSerializable(fieldRename: FieldRename.snake)
class OrderCompanyModel {
  final int? id;
  final int? managerId;
  final int? regionId;
  final String? name;
  final String? description;
  final String? image;
  final String? location;
  @JsonKey(fromJson: _doubleFromJson)
  final double rating;
  final bool? isFavorite;
  final OrderRegionModel? region;
  const OrderCompanyModel({
    this.id,
    this.managerId,
    this.regionId,
    this.name,
    this.description,
    this.image,
    this.location,
    this.rating = 0,
    this.isFavorite,
    this.region,
  });
  factory OrderCompanyModel.fromJson(Map<String, dynamic> json) =>
      _$OrderCompanyModelFromJson(json);
  Map<String, dynamic> toJson() => _$OrderCompanyModelToJson(this);
  OrderCompanyEntity toEntity() => OrderCompanyEntity(
    id: id ?? 0,
    managerId: managerId ?? 0,
    regionId: regionId ?? 0,
    name: name ?? '',
    description: description ?? '',
    image: image,
    location: location ?? '',
    rating: rating,
    isFavorite: isFavorite ?? false,
    region: region?.toEntity(),
  );
}

@JsonSerializable(fieldRename: FieldRename.snake)
class OrderRegionModel {
  final int? id;
  final String? name;
  final int? managerId;
  final String? image;
  const OrderRegionModel({this.id, this.name, this.managerId, this.image});
  factory OrderRegionModel.fromJson(Map<String, dynamic> json) =>
      _$OrderRegionModelFromJson(json);
  Map<String, dynamic> toJson() => _$OrderRegionModelToJson(this);
  OrderRegionEntity toEntity() => OrderRegionEntity(
    id: id ?? 0,
    name: name ?? '',
    managerId: managerId ?? 0,
    image: image,
  );
}
