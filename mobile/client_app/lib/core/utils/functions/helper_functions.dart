import 'dart:io';
import 'package:flutter/material.dart';
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
