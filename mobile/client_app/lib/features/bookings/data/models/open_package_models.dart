import '../../domain/entities/available_day_entity.dart';
import '../../domain/entities/open_package_entities.dart';
import 'available_day_model.dart';

class OpenPackageAttributesRequestModel {
  const OpenPackageAttributesRequestModel({required this.attributes});
  final List<SelectedOpenPackageAttribute> attributes;

  Map<String, dynamic> toJson() => {
    'attributes': attributes.map((item) => item.toJson()).toList(),
  };
}

class OpenPackageSlotsRequestModel extends OpenPackageAttributesRequestModel {
  const OpenPackageSlotsRequestModel({
    required this.latitude,
    required this.longitude,
    required super.attributes,
  });

  final double latitude;
  final double longitude;

  @override
  Map<String, dynamic> toJson() => {
    'latitude': latitude,
    'longitude': longitude,
    ...super.toJson(),
  };
}

class OpenPackageQuoteResponseModel {
  const OpenPackageQuoteResponseModel({required this.data});
  final OpenPackageQuote data;

  factory OpenPackageQuoteResponseModel.fromJson(Map<String, dynamic> json) {
    final data = Map<String, dynamic>.from(json['data'] as Map? ?? const {});
    return OpenPackageQuoteResponseModel(
      data: OpenPackageQuote(
        totalPrice: _double(data['total_price']),
        duration: _int(data['duration']),
      ),
    );
  }
}

class OpenPackageSlotsResponseModel {
  const OpenPackageSlotsResponseModel({required this.days});
  final List<AvailableDayEntity> days;

  factory OpenPackageSlotsResponseModel.fromJson(Map<String, dynamic> json) {
    final data = Map<String, dynamic>.from(json['data'] as Map? ?? const {});
    final slots = Map<String, dynamic>.from(data['slots'] as Map? ?? const {});
    return OpenPackageSlotsResponseModel(
      days: slots.entries
          .map(
            (entry) => AvailableDayModel.fromMap(
              entry.key,
              (entry.value as List? ?? const [])
                  .map((value) => value.toString())
                  .toList(),
            ),
          )
          .toList(),
    );
  }
}

double _double(Object? value) => value is num
    ? value.toDouble()
    : double.tryParse(value?.toString() ?? '') ?? 0;
int _int(Object? value) =>
    value is num ? value.toInt() : int.tryParse(value?.toString() ?? '') ?? 0;
