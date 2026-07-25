import '../../domain/entities/available_day_entity.dart';

class AvailableDayModel extends AvailableDayEntity {
  const AvailableDayModel({required super.date, required super.slots});

  factory AvailableDayModel.fromMap(String date, List<String> slots) {
    return AvailableDayModel(date: DateTime.parse(date), slots: slots);
  }

  AvailableDayEntity toEntity() {
    return AvailableDayEntity(date: date, slots: slots);
  }
}
