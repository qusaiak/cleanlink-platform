import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/available_day_entity.dart';
import 'available_day_model.dart';

part 'available_slots_response_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, createFactory: false)
class AvailableSlotsResponseModel {
  final int status;

  final String message;

  final Map<String, List<String>> data;

  const AvailableSlotsResponseModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory AvailableSlotsResponseModel.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];

    Map<String, List<String>> parsedData = {};

    if (rawData is Map) {
      parsedData = rawData.map(
        (key, value) => MapEntry(key.toString(), List<String>.from(value)),
      );
    }

    return AvailableSlotsResponseModel(
      status: json['status'],
      message: json['message'],
      data: parsedData,
    );
  }

  Map<String, dynamic> toJson() => _$AvailableSlotsResponseModelToJson(this);

  List<AvailableDayEntity> toEntity() {
    return data.entries
        .map((e) => AvailableDayModel.fromMap(e.key, e.value))
        .toList();
  }
}
