import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class NetworkAvatar extends StatelessWidget {
  final String avatarUrl;
  final double radius;
  final Color backgroundColor;
  final Color iconColor;

  const NetworkAvatar({
    super.key,
    required this.avatarUrl,
    required this.radius,
    required this.backgroundColor,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final fallback = Icon(Icons.person, size: radius, color: iconColor);
    return CircleAvatar(
      radius: radius,
      backgroundColor: backgroundColor,
      child: avatarUrl.isEmpty
          ? fallback
          : ClipOval(
              child: CachedNetworkImage(
                imageUrl: avatarUrl,
                width: radius * 2,
                height: radius * 2,
                fit: BoxFit.cover,
                placeholder: (_, __) => fallback,
                errorWidget: (_, __, ___) => fallback,
              ),
            ),
    );
  }
}
