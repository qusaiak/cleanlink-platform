import '../../core/config/api_config.dart';

class ApiUrlParameters {
  static String get baseUrl => ApiConfig.hostRoot;

  static const String login = '/api/auth/login';

  static const String logout = '/api/auth/logout';

  static const String fcmToken = '/api/auth/fcm-token';

  static const String authMe = '/api/auth/me';

  static const String changePassword = '/api/auth/change-password';

  static const String workerProfilesMe = '/api/worker-profiles/me';

  static const String authUpdate = '/api/auth/update';

  static const String dailyTasks = '/api/tasks';

  static const String todayTaskSummary = '/api/tasks/today-summary';

  static String taskById(String taskId) => '/api/tasks/$taskId';

  static String taskStatus(String taskId) => '/api/tasks/$taskId/update-status';

  static const String workerProfiles = '/api/worker-profiles';

  static const String workerProfilesUpdateImage =
      '/api/worker-profiles/update-image';

  static const String skills = '/api/skills';

  static const String updateSkills = '/api/worker/update-skills';

  static const String detachSkills = '/api/worker/detach-skills';

  static const String notifications = '/api/notifications';

  static String markNotificationRead(String id) =>
      '/api/notifications/$id/mark-as-read';

  static const String notificationsUnreadCount =
      '/api/notifications/unread-count';

  static String resolveImageUrl(String rawUrl) {
    if (rawUrl.isEmpty) return rawUrl;
    if (baseUrl.isEmpty) return rawUrl;

    final apiHost = Uri.parse(baseUrl);
    final uri = Uri.tryParse(rawUrl);
    if (uri == null || !uri.hasScheme) {
      return '$baseUrl${_publicStoragePath(rawUrl)}';
    }

    final normalizedPath = _publicStoragePath(uri.path);
    if (ApiConfig.isLocalHost(uri.host)) {
      return uri
          .replace(host: apiHost.host, port: apiHost.port, path: normalizedPath)
          .toString();
    }

    if (normalizedPath != uri.path) {
      return uri.replace(path: normalizedPath).toString();
    }

    return rawUrl;
  }

  static String _publicStoragePath(String rawPath) {
    var path = rawPath.replaceAll(r'\', '/');

    const diskPrefix = 'storage/app/public/';
    final index = path.indexOf(diskPrefix);
    if (index != -1) {
      path = 'storage/${path.substring(index + diskPrefix.length)}';
    }

    return path.startsWith('/') ? path : '/$path';
  }

  static const String _cacheBusterKey = 'v';

  static String withCacheBuster(String url, {required String version}) {
    if (url.isEmpty || version.isEmpty) return url;
    final base = stripCacheBuster(url);
    final separator = base.contains('?') ? '&' : '?';
    return '$base$separator$_cacheBusterKey=$version';
  }

  static String stripCacheBuster(String url) {
    final queryStart = url.indexOf('?');
    if (queryStart == -1) return url;

    final base = url.substring(0, queryStart);
    final kept = url
        .substring(queryStart + 1)
        .split('&')
        .where((param) => !param.startsWith('$_cacheBusterKey='))
        .toList();

    return kept.isEmpty ? base : '$base?${kept.join('&')}';
  }
}
