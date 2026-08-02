import 'package:json_annotation/json_annotation.dart';
import '../../../../core/pagination/paginated_result.dart';
import '../../../../core/pagination/pagination_model.dart';
import '../../domain/entities/booking_entity.dart';
import 'booking_model.dart';

part 'order_response_models.g.dart';

class GetOrdersResponseModel {
  final int? status;
  final String? message;
  final PaginatedResult<OrderEntity> data;
  const GetOrdersResponseModel({this.status, this.message, required this.data});

  factory GetOrdersResponseModel.fromJson(Map<String, dynamic> json) {
    final envelope = json['data'];
    if (envelope is! Map<String, dynamic>) {
      throw const FormatException('Invalid orders response data');
    }

    final rawItems = envelope['data'];
    final rawPagination = envelope['pagination'];
    if (rawItems is! List || rawPagination is! Map<String, dynamic>) {
      throw const FormatException('Invalid orders pagination response');
    }

    return GetOrdersResponseModel(
      status: int.tryParse(json['status']?.toString() ?? ''),
      message: json['message']?.toString(),
      data: PaginatedResult(
        items: rawItems
            .whereType<Map<String, dynamic>>()
            .map(BookingModel.fromJson)
            .map((item) => item.toEntity())
            .toList(growable: false),
        pagination: PaginationModel.fromJson(rawPagination),
      ),
    );
  }
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
