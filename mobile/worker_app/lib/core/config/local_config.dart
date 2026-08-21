import 'package:flutter/services.dart';

class LocalConfig {
  LocalConfig._();

  static Map<String, String> _values = const {};

  static Future<void> load() async {
    final source = await rootBundle.loadString('.env');
    final values = <String, String>{};
    for (final rawLine in source.split(RegExp(r'\r?\n'))) {
      final line = rawLine.trim();
      if (line.isEmpty || line.startsWith('#')) continue;
      final separator = line.indexOf('=');
      if (separator < 1) continue;
      final key = line.substring(0, separator).trim();
      var value = line.substring(separator + 1).trim();
      if (value.length >= 2 &&
          ((value.startsWith('"') && value.endsWith('"')) ||
              (value.startsWith("'") && value.endsWith("'")))) {
        value = value.substring(1, value.length - 1);
      }
      values[key] = value;
    }
    _values = Map.unmodifiable(values);
  }

  static String value(String key) => _values[key]?.trim() ?? '';

  static String get baseUrl => value('BASE_URL');
}
