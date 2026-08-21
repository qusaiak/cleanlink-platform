import 'package:flutter/foundation.dart';

import 'local_config.dart';

class ApiConfig {
  ApiConfig._();

  static const String _apiPrefix = '/api';
  static String _baseUrl = '';

  static const Set<String> _localHosts = {
    'localhost',
    '127.0.0.1',
    '0.0.0.0',
    '10.0.2.2',
    '::1',
    '[::1]',
  };

  static Future<void> init() async {
    final configured = LocalConfig.baseUrl;
    if (configured.isEmpty) {
      throw StateError('BASE_URL is empty in the local .env file.');
    }
    _baseUrl = _normalize(configured);
    if (kDebugMode) {
      debugPrint('[ApiConfig] baseUrl=$baseUrl');
    }
  }

  static String get baseUrl => _baseUrl;

  static String get hostRoot => _baseUrl.endsWith(_apiPrefix)
      ? _baseUrl.substring(0, _baseUrl.length - _apiPrefix.length)
      : _baseUrl;

  static bool isLocalHost(String host) =>
      _localHosts.contains(host.toLowerCase());

  static String _normalize(String value) {
    var normalized = value.trim();
    while (normalized.endsWith('/')) {
      normalized = normalized.substring(0, normalized.length - 1);
    }
    return normalized;
  }
}
