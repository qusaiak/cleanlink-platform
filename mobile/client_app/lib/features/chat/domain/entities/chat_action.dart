import 'package:equatable/equatable.dart';

class ChatAction extends Equatable {
  const ChatAction({
    required this.type,
    this.title,
    this.options = const [],
    this.summary,
    this.orderId,
    this.confirmMessage,
    this.changeMessage,
    this.electronicPaymentWarning = false,
  });

  final String type;
  final String? title;
  final List<ChatActionOption> options;
  final ChatBookingSummary? summary;
  final int? orderId;
  final String? confirmMessage;
  final String? changeMessage;
  final bool electronicPaymentWarning;

  bool get requiresPayment => type == 'payment_required' && orderId != null;
  bool get isBookingResult =>
      type == 'payment_required' || type == 'booking_created';

  @override
  List<Object?> get props => [
    type,
    title,
    options,
    summary,
    orderId,
    confirmMessage,
    changeMessage,
    electronicPaymentWarning,
  ];
}

class ChatActionOption extends Equatable {
  const ChatActionOption({
    required this.label,
    required this.message,
    this.arabicLabel,
    this.arabicMessage,
    this.value,
  });

  final String label;
  final String? arabicLabel;
  final String? arabicMessage;
  final String message;
  final Object? value;

  String localizedLabel(bool isArabic) =>
      isArabic && arabicLabel?.isNotEmpty == true ? arabicLabel! : label;

  String localizedMessage(bool isArabic) =>
      isArabic && arabicMessage?.isNotEmpty == true ? arabicMessage! : message;

  @override
  List<Object?> get props => [
    label,
    arabicLabel,
    message,
    arabicMessage,
    value,
  ];
}

class LocalizedChatValue extends Equatable {
  const LocalizedChatValue({this.english, this.arabic});
  final String? english;
  final String? arabic;

  String resolve(bool isArabic) =>
      (isArabic ? arabic : english) ?? english ?? arabic ?? '';

  @override
  List<Object?> get props => [english, arabic];
}

class ChatBookingSummary extends Equatable {
  const ChatBookingSummary({
    required this.company,
    required this.service,
    required this.package,
    required this.locationName,
    required this.address,
    required this.date,
    required this.time,
    required this.paymentMethod,
    required this.total,
    required this.currency,
    required this.durationMinutes,
    this.note,
  });

  final LocalizedChatValue company;
  final LocalizedChatValue service;
  final LocalizedChatValue package;
  final String locationName;
  final String address;
  final String date;
  final String time;
  final String paymentMethod;
  final num total;
  final String currency;
  final int durationMinutes;
  final String? note;

  @override
  List<Object?> get props => [
    company,
    service,
    package,
    locationName,
    address,
    date,
    time,
    paymentMethod,
    total,
    currency,
    durationMinutes,
    note,
  ];
}
