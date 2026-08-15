final RegExp _leadingPlusCodePattern = RegExp(
  r'^[23456789CFGHJMPQRVWX]{4,8}\+[23456789CFGHJMPQRVWX]{2,3}$',
  caseSensitive: false,
);

String normalizeGoogleMapAddress(String value) {
  final parts = value
      .split(',')
      .map((part) => part.trim())
      .where((part) => part.isNotEmpty)
      .toList(growable: true);

  if (parts.isEmpty) return value.trim();
  if (_leadingPlusCodePattern.hasMatch(parts.first)) parts.removeAt(0);
  return parts.join(', ');
}
