// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookingModel _$BookingModelFromJson(Map<String, dynamic> json) => BookingModel(
  id: (json['id'] as num?)?.toInt(),
  clientId: (json['client_id'] as num?)?.toInt(),
  packageId: (json['package_id'] as num?)?.toInt(),
  status: json['status'] as String?,
  location: json['location'] as String?,
  latitude: _nullableDoubleFromJson(json['latitude']),
  longitude: _nullableDoubleFromJson(json['longitude']),
  startTime: json['start_time'] == null
      ? null
      : DateTime.parse(json['start_time'] as String),
  endTime: json['end_time'] == null
      ? null
      : DateTime.parse(json['end_time'] as String),
  duration: json['duration'] == null ? 0 : _intFromJson(json['duration']),
  travelBufferMinutes: json['travel_buffer_minutes'] == null
      ? 0
      : _intFromJson(json['travel_buffer_minutes']),
  totalPrice: json['total_price'] == null
      ? 0
      : _doubleFromJson(json['total_price']),
  note: json['note'] as String?,
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  updatedAt: json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
  client: json['client'] == null
      ? null
      : OrderClientModel.fromJson(json['client'] as Map<String, dynamic>),
  leader: json['leader'] == null
      ? null
      : OrderLeaderModel.fromJson(json['leader'] as Map<String, dynamic>),
  package: json['package'] == null
      ? null
      : OrderPackageModel.fromJson(json['package'] as Map<String, dynamic>),
  attributes: (json['attributes'] as List<dynamic>?)
      ?.map((e) => OrderAttributeModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$BookingModelToJson(BookingModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'client_id': instance.clientId,
      'package_id': instance.packageId,
      'status': instance.status,
      'location': instance.location,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'start_time': instance.startTime?.toIso8601String(),
      'end_time': instance.endTime?.toIso8601String(),
      'duration': instance.duration,
      'travel_buffer_minutes': instance.travelBufferMinutes,
      'total_price': instance.totalPrice,
      'note': instance.note,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'client': instance.client,
      'leader': instance.leader,
      'package': instance.package,
      'attributes': instance.attributes,
    };

OrderClientModel _$OrderClientModelFromJson(Map<String, dynamic> json) =>
    OrderClientModel(
      id: (json['id'] as num?)?.toInt(),
      fullname: json['fullname'] as String?,
      email: json['email'] as String?,
      role: json['role'] as String?,
      profile: json['profile'] == null
          ? null
          : OrderClientProfileModel.fromJson(
              json['profile'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$OrderClientModelToJson(OrderClientModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fullname': instance.fullname,
      'email': instance.email,
      'role': instance.role,
      'profile': instance.profile,
    };

OrderClientProfileModel _$OrderClientProfileModelFromJson(
  Map<String, dynamic> json,
) => OrderClientProfileModel(
  id: (json['id'] as num?)?.toInt(),
  userId: (json['user_id'] as num?)?.toInt(),
  image: json['image'] as String?,
  address: json['address'] as String?,
  phone: json['phone'] as String?,
);

Map<String, dynamic> _$OrderClientProfileModelToJson(
  OrderClientProfileModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'user_id': instance.userId,
  'image': instance.image,
  'address': instance.address,
  'phone': instance.phone,
};

OrderLeaderModel _$OrderLeaderModelFromJson(Map<String, dynamic> json) =>
    OrderLeaderModel(
      id: (json['id'] as num?)?.toInt(),
      fullname: json['fullname'] as String?,
      email: json['email'] as String?,
      role: json['role'] as String?,
      profile: json['profile'] == null
          ? null
          : OrderLeaderProfileModel.fromJson(
              json['profile'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$OrderLeaderModelToJson(OrderLeaderModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fullname': instance.fullname,
      'email': instance.email,
      'role': instance.role,
      'profile': instance.profile,
    };

OrderLeaderProfileModel _$OrderLeaderProfileModelFromJson(
  Map<String, dynamic> json,
) => OrderLeaderProfileModel(
  id: (json['id'] as num?)?.toInt(),
  userId: (json['user_id'] as num?)?.toInt(),
  image: json['image'] as String?,
  address: json['address'] as String?,
  phone: json['phone'] as String?,
  createdAt: json['created_at'] as String?,
  updatedAt: json['updated_at'] as String?,
);

Map<String, dynamic> _$OrderLeaderProfileModelToJson(
  OrderLeaderProfileModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'user_id': instance.userId,
  'image': instance.image,
  'address': instance.address,
  'phone': instance.phone,
  'created_at': instance.createdAt,
  'updated_at': instance.updatedAt,
};

OrderPackageModel _$OrderPackageModelFromJson(Map<String, dynamic> json) =>
    OrderPackageModel(
      id: (json['id'] as num?)?.toInt(),
      serviceId: (json['service_id'] as num?)?.toInt(),
      name: json['name'] as String?,
      duration: json['duration'] == null ? 0 : _intFromJson(json['duration']),
      price: json['price'] == null ? 0 : _doubleFromJson(json['price']),
      priceAfterDiscount: json['price_after_discount'] == null
          ? 0
          : _doubleFromJson(json['price_after_discount']),
      details: (json['details'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      service: json['service'] == null
          ? null
          : OrderServiceModel.fromJson(json['service'] as Map<String, dynamic>),
      isOpenPackage: json['is_open_package'] as bool?,
    );

Map<String, dynamic> _$OrderPackageModelToJson(OrderPackageModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'service_id': instance.serviceId,
      'name': instance.name,
      'duration': instance.duration,
      'price': instance.price,
      'price_after_discount': instance.priceAfterDiscount,
      'details': instance.details,
      'service': instance.service,
      'is_open_package': instance.isOpenPackage,
    };

OrderAttributeModel _$OrderAttributeModelFromJson(Map<String, dynamic> json) =>
    OrderAttributeModel(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      type: json['type'] as String?,
      qty: _nullableIntFromJson(json['qty']),
      pivot: json['pivot'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$OrderAttributeModelToJson(
  OrderAttributeModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'type': instance.type,
  'qty': instance.qty,
  'pivot': instance.pivot,
};

OrderServiceModel _$OrderServiceModelFromJson(Map<String, dynamic> json) =>
    OrderServiceModel(
      id: (json['id'] as num?)?.toInt(),
      companyId: (json['company_id'] as num?)?.toInt(),
      categoryId: (json['category_id'] as num?)?.toInt(),
      name: json['name'] as String?,
      description: json['description'] as String?,
      rating: json['rating'] == null ? 0 : _doubleFromJson(json['rating']),
      minDuration: json['min_duration'] == null
          ? 0
          : _intFromJson(json['min_duration']),
      maxDuration: json['max_duration'] == null
          ? 0
          : _intFromJson(json['max_duration']),
      minPrice: _nullableDoubleFromJson(json['minimum_price']),
      maxPrice: _nullableDoubleFromJson(json['maximum_price']),
      image: json['image'] as String?,
      discount: json['discount'] == null
          ? 0
          : _doubleFromJson(json['discount']),
      isFavorite: json['is_favorite'] as bool?,
      company: json['company'] == null
          ? null
          : OrderCompanyModel.fromJson(json['company'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$OrderServiceModelToJson(OrderServiceModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'company_id': instance.companyId,
      'category_id': instance.categoryId,
      'name': instance.name,
      'description': instance.description,
      'rating': instance.rating,
      'min_duration': instance.minDuration,
      'max_duration': instance.maxDuration,
      'minimum_price': instance.minPrice,
      'maximum_price': instance.maxPrice,
      'image': instance.image,
      'discount': instance.discount,
      'is_favorite': instance.isFavorite,
      'company': instance.company,
    };

OrderCompanyModel _$OrderCompanyModelFromJson(Map<String, dynamic> json) =>
    OrderCompanyModel(
      id: (json['id'] as num?)?.toInt(),
      managerId: (json['manager_id'] as num?)?.toInt(),
      regionId: (json['region_id'] as num?)?.toInt(),
      name: json['name'] as String?,
      description: json['description'] as String?,
      image: json['image'] as String?,
      location: json['location'] as String?,
      rating: json['rating'] == null ? 0 : _doubleFromJson(json['rating']),
      isFavorite: json['is_favorite'] as bool?,
      region: json['region'] == null
          ? null
          : OrderRegionModel.fromJson(json['region'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$OrderCompanyModelToJson(OrderCompanyModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'manager_id': instance.managerId,
      'region_id': instance.regionId,
      'name': instance.name,
      'description': instance.description,
      'image': instance.image,
      'location': instance.location,
      'rating': instance.rating,
      'is_favorite': instance.isFavorite,
      'region': instance.region,
    };

OrderRegionModel _$OrderRegionModelFromJson(Map<String, dynamic> json) =>
    OrderRegionModel(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      managerId: (json['manager_id'] as num?)?.toInt(),
      image: json['image'] as String?,
    );

Map<String, dynamic> _$OrderRegionModelToJson(OrderRegionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'manager_id': instance.managerId,
      'image': instance.image,
    };
