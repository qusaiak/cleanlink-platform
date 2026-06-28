import 'storable.dart';

enum StorageData<T> implements Storable {

  // General app settings
  isOnboarding,
  languageCode,
  isLight,

  // Auth token
  token(secure: true, clearOnLogout: true),

  // User data
  userId(clearOnLogout: true),
  accountId(clearOnLogout: true),
  mobile(clearOnLogout: true),
  fullName(clearOnLogout: true),
  email(clearOnLogout: true),
  userProfilePhoto(clearOnLogout: true),
  pushNotifications(clearOnLogout: true),
  phone(clearOnLogout: true),
  address(clearOnLogout: true),
  image(clearOnLogout: true),

  // App preferences
  connectionType(secure: true, clearOnLogout: true),
  subscriptionExpired(secure: true, clearOnLogout: true),
  fcmToken(secure: true),

  // Search
  recentSearchesList(clearOnLogout: true);

  const StorageData({this.secure = false, this.clearOnLogout = false});

  @override
  final bool secure;

  @override
  String get storableKey => name;

  @override
  final bool clearOnLogout;

}
