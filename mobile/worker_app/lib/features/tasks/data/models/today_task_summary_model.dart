import '../../domain/entities/today_task_summary.dart';

class TodayTaskSummaryModel extends TodayTaskSummary {
  const TodayTaskSummaryModel({required super.pending, required super.done});

  factory TodayTaskSummaryModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] is Map
        ? Map<String, dynamic>.from(json['data'] as Map)
        : json;
    return TodayTaskSummaryModel(
      pending: _asInt(data['pending']),
      done: _asInt(data['done']),
    );
  }

  static int _asInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}
