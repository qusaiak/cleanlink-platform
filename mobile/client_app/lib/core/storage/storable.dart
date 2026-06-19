abstract class Storable {
  final String storableKey;
  final bool secure;
  final bool clearOnLogout;

  Storable({
    required this.storableKey,
    this.secure = false,
    this.clearOnLogout = false,
  });
}
