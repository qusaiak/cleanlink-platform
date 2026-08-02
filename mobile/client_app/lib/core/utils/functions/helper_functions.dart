import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../features/services/domain/entities/service_entity.dart';
import '../../../l10n/app_localizations.dart';
import '../gen/assets.gen.dart';

ImageProvider? resolveImage(String? image) {
  if (image == null || image.isEmpty || image == '/') {
    return AssetImage(Assets.images.placeholders.personPlaceholder.path);
  }
  if (image.startsWith('http://') || image.startsWith('https://')) {
    return NetworkImage(image);
  }
  final file = File(image);
  if (file.existsSync()) {
    return FileImage(file);
  }
  return AssetImage(Assets.images.placeholders.personPlaceholder.path);
}

class DateHelper {
  static String formatDate(DateTime? date) {
    if (date == null) return '';

    final year = date.year;
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');

    return '$year-$month-$day';
  }
}

String formatServicePriceRange(BuildContext context, ServiceEntity service) {
  final l = AppLocalizations.of(context)!;
  final locale = Localizations.localeOf(context).toLanguageTag();

  String price(double value) {
    final number = NumberFormat('#,##0.##', locale).format(value);
    return number;
  }

  final min = service.minPrice;
  final max = service.maxPrice;

  if (min == null && max == null) return l.price_unavailable;
  if (min != null && max != null) {
    if (min == max) return price(min);
    return '${price(min)}-${price(max)} ${l.sp}';
  }
  if (min != null) return '${l.from_price} ${price(min)}';
  return '${l.up_to_price} ${price(max!)}';
}
