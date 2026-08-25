import '../../domain/entities/open_package_entities.dart';
import '../../../payments/domain/entities/payment_entities.dart';

class BookOrderRequestModel {
  final int packageId;
  final String location;
  final double latitude;
  final double longitude;
  final String startTime;
  final String? note;
  final List<SelectedOpenPackageAttribute>? attributes;
  final PaymentMethodType paymentMethod;
  const BookOrderRequestModel({
    required this.packageId,
    required this.location,
    required this.latitude,
    required this.longitude,
    required this.startTime,
    this.note,
    this.attributes,
    this.paymentMethod = PaymentMethodType.cash,
  });
  Map<String, dynamic> toJson() => {
    'package_id': packageId,
    'location': location,
    'latitude': latitude,
    'longitude': longitude,
    'start_time': startTime,
    'payment_method': paymentMethod.apiValue,
    if (note != null) 'note': note,
    if (attributes != null)
      'attributes': attributes!.map((item) => item.toJson()).toList(),
  };
}
