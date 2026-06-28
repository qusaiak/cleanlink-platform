import 'dart:io';
import 'package:client_app/core/widgets/custom_image_view.dart';
import 'package:flutter/material.dart';
import '../gen/assets.gen.dart';

ImageProvider? resolveImage(String? image) {
  if (image == null || image.isEmpty) {
    return AssetImage(Assets.images.placeholders.personPlaceholder.path);
  }
  return FileImage(File(image));
}
