abstract final class ContentValidation {
  static bool hasText(String? value) => value?.trim().isNotEmpty == true;

  static bool hasImageUrl(String? value) {
    if (!hasText(value)) return false;
    final uri = Uri.tryParse(value!.trim());
    return uri != null &&
        (uri.scheme == 'http' || uri.scheme == 'https') &&
        uri.host.isNotEmpty;
  }

  static List<T> validItems<T>(
    Iterable<T>? items,
    bool Function(T item) isValid,
  ) => items?.where(isValid).toList(growable: false) ?? const [];
}
