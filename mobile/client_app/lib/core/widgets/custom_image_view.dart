import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:client_app/core/utils/functions/spinkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../config/theme/colors.dart';

class CustomImageView extends StatelessWidget {
  ///[imagePath] is required parameter for showing image
  final String? imagePath;
  final double? height;
  final double? width;
  final Color? color;
  final BoxFit? fit;
  final String? placeHolder;
  final Alignment? alignment;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? radius;
  final BoxBorder? border;
  final Gradient? gradient;

  ///a [CustomImageView] it can be used for showing any type of images
  /// it will shows the placeholder image if image is not found on network image
  const CustomImageView({
    super.key,
    this.imagePath,
    this.height,
    this.width,
    this.color,
    this.fit,
    this.alignment,
    this.onTap,
    this.radius,
    this.margin,
    this.border,
    this.placeHolder,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment!,
            child: _buildWidget(),
          )
        : _buildWidget();
  }

  Widget _buildWidget() {
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        child: _buildCircleImage(),
      ),
    );
  }

  ///build the image with border radius
  _buildCircleImage() {
    if (radius != null) {
      return ClipRRect(
        borderRadius: radius ?? BorderRadius.zero,
        child: _buildImageWithBorder(),
      );
    } else {
      return _buildImageWithBorder();
    }
  }

  ///build the image with border and border radius style
  _buildImageWithBorder() {
    if (border != null) {
      return Container(
        decoration: BoxDecoration(
          border: border,
          borderRadius: radius,
          gradient: gradient,
        ),
        child: _buildImageView(),
      );
    } else {
      return _buildImageView();
    }
  }

  Widget _buildImageView() {
    if (imagePath!.split('/').last != '') {
      switch (imagePath!.imageType) {
        case ImageType.svg:
          return SizedBox(
            height: height,
            width: width,
            child: SvgPicture.asset(
              imagePath!,
              height: height,
              width: width,
              fit: fit ?? BoxFit.contain,
            ),
          );
        case ImageType.file:
          final file = File(imagePath!);
          if (file.existsSync()) {
            return Image.file(
              file,
              height: height,
              width: width,
              fit: fit ?? BoxFit.cover,
              color: color,
            );
          } else {
            return const Icon(
              Icons.error,
              color: AppColor.primaryLight,
            );
          }
        case ImageType.network:
          return CachedNetworkImage(
            filterQuality: FilterQuality.high,
            height: height,
            width: width,
            fit: fit,
            imageUrl: imagePath!,
            placeholder: (context, url) => placeHolder != null
                ? Image.asset(
                    placeHolder!,
                    height: height,
                    width: width,
              fit: BoxFit.cover,
                    color: color,
                  )
                : spinKitApp(AppColor.primaryLight),
            errorWidget: (context, url, error) => const Icon(
              Icons.error,
              color: AppColor.primaryLight,
            ),
          );
        case ImageType.png:
        default:
          return Image.asset(
            imagePath!,
            height: height,
            width: width,
            fit: fit ?? BoxFit.cover,
            color: color,
          );
      }
    }
    return ClipRRect(
      // borderRadius: BorderRadius.circular(10.r),
      child: Image.asset(
        placeHolder!,
        height: height,
        width: width,
        fit: BoxFit.cover,
      ),
    );
  }
}

extension ImageTypeExtension on String {
  ImageType get imageType {
    if (startsWith('http') || startsWith('https')) {
      return ImageType.network;
    } else if (endsWith('.svg')) {
      return ImageType.svg;
    } else if (startsWith('file://') || File(this).existsSync()) {
      return ImageType.file;
    } else {
      return ImageType.png;
    }
  }
}

enum ImageType { svg, png, network, file, unknown }
