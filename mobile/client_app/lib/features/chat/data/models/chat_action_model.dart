import '../../domain/entities/chat_action.dart';

class ChatActionModel {
  const ChatActionModel(this.entity);

  factory ChatActionModel.fromJson(Map<String, dynamic> json) {
    final rawOptions = json['options'];
    final rawSummary = json['summary'];
    return ChatActionModel(
      ChatAction(
        type: json['type']?.toString() ?? '',
        title: json['title']?.toString(),
        orderId: _int(json['order_id']),
        confirmMessage: json['confirm_message']?.toString(),
        changeMessage: json['change_message']?.toString(),
        electronicPaymentWarning: json['electronic_payment_warning'] == true,
        options: rawOptions is List
            ? rawOptions
                  .whereType<Map>()
                  .map((item) => Map<String, dynamic>.from(item))
                  .map(
                    (item) => ChatActionOption(
                      label: item['label']?.toString() ?? '',
                      arabicLabel: item['label_ar']?.toString(),
                      arabicMessage: item['message_ar']?.toString(),
                      message:
                          item['message']?.toString() ??
                          item['label']?.toString() ??
                          '',
                      value: item['value'],
                    ),
                  )
                  .where((item) => item.label.isNotEmpty)
                  .toList(growable: false)
            : const [],
        summary: rawSummary is Map
            ? _summary(Map<String, dynamic>.from(rawSummary))
            : null,
      ),
    );
  }

  final ChatAction entity;

  static ChatBookingSummary _summary(Map<String, dynamic> json) {
    final location = _map(json['location']);
    return ChatBookingSummary(
      company: _localized(json['company']),
      service: _localized(json['service']),
      package: _localized(json['package']),
      locationName: location['name']?.toString() ?? '',
      address: location['address']?.toString() ?? '',
      date: json['date']?.toString() ?? '',
      time: json['time']?.toString() ?? '',
      paymentMethod: json['payment_method']?.toString() ?? '',
      total: json['total'] is num
          ? json['total'] as num
          : num.tryParse('${json['total']}') ?? 0,
      currency: json['currency']?.toString() ?? '',
      durationMinutes: _int(json['duration_minutes']) ?? 0,
      note: json['note']?.toString(),
    );
  }

  static LocalizedChatValue _localized(Object? value) {
    final map = _map(value);
    return LocalizedChatValue(
      english: map['en']?.toString(),
      arabic: map['ar']?.toString(),
    );
  }

  static Map<String, dynamic> _map(Object? value) =>
      value is Map ? Map<String, dynamic>.from(value) : const {};
}

int? _int(Object? value) =>
    value is int ? value : int.tryParse(value?.toString() ?? '');
