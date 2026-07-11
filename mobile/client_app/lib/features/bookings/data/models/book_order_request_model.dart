import 'package:json_annotation/json_annotation.dart';

part 'book_order_request_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class BookOrderRequestModel {
  final int packageId;
  final String location;
  final String startTime;
  final String? note;
  const BookOrderRequestModel(
      {required this.packageId,
      required this.location,
      required this.startTime,
      this.note});
  factory BookOrderRequestModel.fromJson(Map<String, dynamic> json) =>
      _$BookOrderRequestModelFromJson(json);
  Map<String, dynamic> toJson() => _$BookOrderRequestModelToJson(this);
}
