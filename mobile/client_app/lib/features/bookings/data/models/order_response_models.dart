import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/booking_entity.dart';
import 'booking_model.dart';

part 'order_response_models.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class GetOrdersResponseModel {
  final int? status;
  final String? message;
  final List<BookingModel>? data;
  const GetOrdersResponseModel({this.status, this.message, this.data});
  factory GetOrdersResponseModel.fromJson(Map<String, dynamic> json) =>
      _$GetOrdersResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$GetOrdersResponseModelToJson(this);
  List<OrderEntity> toEntity() =>
      (data ?? const []).map((item) => item.toEntity()).toList();
}

@JsonSerializable(fieldRename: FieldRename.snake)
class BookOrderResponseModel {
  final int? status;
  final String? message;
  final BookingModel? data;
  const BookOrderResponseModel({this.status, this.message, this.data});
  factory BookOrderResponseModel.fromJson(Map<String, dynamic> json) =>
      _$BookOrderResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$BookOrderResponseModelToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class ShowOrderResponseModel {
  final int? status;
  final String? message;
  final BookingModel? data;
  const ShowOrderResponseModel({this.status, this.message, this.data});
  factory ShowOrderResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ShowOrderResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$ShowOrderResponseModelToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class CancelOrderResponseModel {
  final int? status;
  final String? message;
  final BookingModel? data;
  const CancelOrderResponseModel({this.status, this.message, this.data});
  factory CancelOrderResponseModel.fromJson(Map<String, dynamic> json) =>
      _$CancelOrderResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$CancelOrderResponseModelToJson(this);
}
