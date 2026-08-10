import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/painting.dart';

import '../../../config/constants/api_url_parameters.dart';

/// Drops every cached copy of [url] so the next widget that asks for it
/// re-downloads the bytes.
///
/// Needed whenever a picture is REPLACED at an unchanged URL — a new profile
/// photo saved over the previous one. Two independent caches have to be told:
///  - `CachedNetworkImage`'s disk+memory store (`flutter_cache_manager`), keyed
///    by the image URL;
///  - Flutter's own in-memory [ImageCache], keyed by the [NetworkImage]
///    provider, which additionally keeps "live" images that are still painted
///    on screen.
///
/// Both the given URL and its cache-buster-free form are evicted, so an entry
/// stored under either spelling is cleared.
///
/// Never throws: a cache miss, or a cache manager that has not been opened yet,
/// must not turn a successful upload into a visible error.
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

  // An avatar that is currently on screen is held as a "live" image, which
  // survives `evict()`; clearing those makes the rebuild pick up the new bytes
  // instead of repainting the retained ones.
  try {
    PaintingBinding.instance.imageCache.clearLiveImages();
  } catch (e) {
    log('evictImageUrl: clearLiveImages failed: $e');
  }
}
