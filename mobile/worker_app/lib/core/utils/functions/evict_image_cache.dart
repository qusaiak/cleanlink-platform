import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/painting.dart';

import '../../../config/constants/api_url_parameters.dart';

Future<void> evictImageUrl(String url) async {
  if (url.isEmpty) return;

  final urls = <String>{url, ApiUrlParameters.stripCacheBuster(url)};

  for (final target in urls) {
    try {
      await CachedNetworkImage.evictFromCache(target);

      final provider = NetworkImage(target);
      await provider.evict();
      PaintingBinding.instance.imageCache.evict(provider);
    } catch (e) {
      log('evictImageUrl failed for $target: $e');
    }
  }

  try {
    PaintingBinding.instance.imageCache.clearLiveImages();
  } catch (e) {
    log('evictImageUrl: clearLiveImages failed: $e');
  }
}
