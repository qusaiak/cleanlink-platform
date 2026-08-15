import '../../core/config/api_config.dart';

/// Centralized API endpoint paths.
///
/// [baseUrl] is the HOST ROOT only (no `/api`); every path constant below
/// carries its own `/api/...` prefix, so the final URL is always
/// `<host>/api/...` — e.g. `http://10.0.2.2:8000` + [login] →
/// `http://10.0.2.2:8000/api/auth/login`.
class ApiUrlParameters {
  /// The host root, resolved at startup by [ApiConfig] from the platform the
  /// app is actually running on (emulator alias, `localhost` or the dev
  /// machine's LAN IP) — no host is hardcoded here any more, and nothing has
  /// to be edited between an emulator run and a physical-device run.
  static String get baseUrl => ApiConfig.hostRoot;

  // Auth endpoints

  /// POST → `<baseUrl>/api/auth/login`. Body: `{email, password}` as JSON.
  static const String login = '/api/auth/login';

  /// POST → logs the signed-in worker out (invalidates the current token on the
  /// server). No body; authenticated only by the bearer token the shared Dio
  /// interceptor attaches.
  static const String logout = '/api/auth/logout';

  /// POST → registers this device's FCM push token against the signed-in
  /// worker. Body: `{fcm_token, device_type, lang}`. Authenticated by the
  /// bearer token the shared Dio interceptor attaches; called on every login
  /// and whenever the app language changes.
  static const String fcmToken = '/api/auth/fcm-token';

  /// GET → the signed-in user's profile metrics (name, email, profile image,
  /// worker_profile rating/experience/leader flag). Authenticated via the
  /// bearer token saved at login; no body or query params.
  static const String authMe = '/api/auth/me';

  /// GET → the signed-in worker's full profile including
  /// `worker_profile.skills`. Same auth mechanism as [authMe] (bearer token
  /// only); supersedes it as the profile screen's source.
  static const String workerProfilesMe = '/api/worker-profiles/me';

  /// POST → update the signed-in user's account fields (fullname, email,
  /// address, phone, image). The photo is sent as multipart/form-data.
  static const String authUpdate = '/api/auth/update';

  /// GET → worker's tasks for today + summary stats ([DailyTasks]).
  static const String dailyTasks = '/api/tasks';

  /// GET `/worker/tasks/{id}` → a single task's full details. Used when opening
  /// a task from a search result or a notification (which only carry an id).
  static String taskById(String taskId) => '/api/tasks/$taskId';

  /// POST `/api/tasks/{order_id}/update-status` → advance a task's lifecycle
  /// status. Body: `{status: pending|on_way|handling|done, image_before,
  /// image_after}` — the two images may only be sent when `status` is `done`
  /// (multipart in that case; empty strings otherwise).
  static String taskStatus(String orderId) =>
      '/api/tasks/$orderId/update-status';

  /// GET → the signed-in worker's profile.
  static const String workerProfile = '/api/worker/profile';

  /// PUT → update the signed-in worker's profile. ALL fields are optional and
  /// only the changed ones are sent; the request body mixes the three tables:
  /// `{fullname, email}` (user), `{phone, address}` (profile) and
  /// `{experience_years, status}` (worker_profile). `status` is only ever
  /// `available` or `off` — `busy` is derived on the client and never sent.
  /// The response echoes the full nested worker object (see
  /// `WorkerProfileModel.fromMeJson`), so the screen updates from it without a
  /// re-fetch. Authenticated by the shared Dio bearer-token interceptor.
  static const String workerProfiles = '/api/worker-profiles';

  /// POST → persists an ALREADY-UPLOADED photo on the worker profile.
  ///
  /// JSON only — the body carries exactly one key:
  /// `{"image": "storage\\app\\public\\task_images\\<file>.jpg"}`, whose value is
  /// the stored path the upload step returned, sent back verbatim (no
  /// trimming, no escaping, no backslash→slash conversion; the JSON escaping is
  /// Dio's job). No multipart, no file bytes, no other fields.
  /// The response carries the updated profile/image, which becomes the new
  /// source of truth for the avatar. Bearer-token authenticated.
  static const String workerProfilesUpdateImage =
      '/api/worker-profiles/update-image';

  /// GET → the skills DICTIONARY: every assignable skill, already localized by
  /// the server from the `Accept-Language` header the shared Dio interceptor
  /// sends. Shape: `{status, message, data: [{id, name}]}` — a single `name`,
  /// NOT `name_ar`/`name_en` (that pair only appears inside the worker's own
  /// `worker_profile.skills`). Bearer-token authenticated.
  ///
  /// Because the server does the translating, this has to be re-fetched when
  /// the app language changes — the names are never translated client-side.
  static const String skills = '/api/skills';

  /// POST → ATTACH skill(s) the worker does not have yet.
  ///
  /// Verified against the running API: this path answers 401 (not 404) without
  /// a token, and 405 for DELETE — so POST on this exact path is correct.
  ///
  /// The body's field name lives in `SkillsPayload`, the single place it is
  /// defined. The response carries the FULL updated user
  /// (`data.worker_profile.skills`, `data.profile`, …), used as the new source
  /// of truth.
  static const String updateSkills = '/api/worker/update-skills';

  /// DELETE → DETACH skill(s) from the worker. Same body and same response
  /// shape as [updateSkills].
  ///
  /// Verified the same way: 401 (not 404) without a token, and 405 for POST —
  /// so DELETE on this exact path is correct.
  ///
  /// The id travels in a JSON body on a DELETE, which not every client sends
  /// by default — see `WorkerProfileRemoteDataSourceImpl`, which passes `data:`
  /// explicitly and falls back to a `skill_ids[]=` query parameter.
  static const String detachSkills = '/api/worker/detach-skills';

  /// Update the worker's status (available/offline ONLY — `busy` is set by the
  /// system when a task is assigned and can never be sent manually).
  ///
  /// PLACEHOLDER — the real endpoint has not been provided yet. When it is,
  /// set the path here (and adjust the HTTP verb in
  /// `WorkerProfileRemoteDataSourceImpl.updateAvailability` if needed); no
  /// other code has to change.
  static const String workerStatusUpdate = '/api/worker-profiles/status';

  /// GET → the worker's notifications feed (newest first), each item shaped
  /// `{id, title, body, is_read, created_at, data: {type, order_id, status}}`.
  /// A `data.type` of `new_task_assigned` links to the order in
  /// `data.order_id`.
  static const String notifications = '/api/notifications';

  /// POST `/api/notifications/{id}/mark-as-read` → mark a single notification
  /// read. Authenticated by the bearer token the shared Dio interceptor
  /// attaches; no body.
  static String markNotificationRead(String id) =>
      '/api/notifications/$id/mark-as-read';

  /// PATCH → mark every notification read.
  static const String markAllNotificationsRead =
      '/api/worker/notifications/read-all';

  /// GET → search services / job requests.
  ///
  /// Query params:
  ///  - `mode`  → `general` (free-text across everything) or `custom`.
  ///  - `field` → when custom: `service_name` | `client_name` | `location` |
  ///              `time`.
  ///  - `q`     → the search term.
  static const String searchServices = '/api/worker/services/search';

  /// Makes a media URL coming back from the API (e.g. `service.image`,
  /// `company.image`) actually reachable from this client.
  ///
  /// The backend builds absolute image URLs from its own host — this one's
  /// `APP_URL` is `http://localhost`, so that is literally what comes back —
  /// but `localhost` on a phone means the PHONE, not the machine running the
  /// backend. The request then "succeeds" at the API level while every image
  /// silently fails to load. This rewrites the host of any such URL to
  /// [baseUrl]'s host, and prefixes bare relative paths (e.g. `/storage/x.jpg`)
  /// with [baseUrl].
  ///
  /// The set of hosts treated as local lives in [ApiConfig.isLocalHost] and
  /// deliberately includes `10.0.2.2`: a URL resolved on the emulator can be
  /// PERSISTED (`LoginSession.avatarUrl`) and read back on a physical device,
  /// which cannot reach that alias at all. Rewriting it there is what stops an
  /// avatar from staying broken after switching from emulator to real hardware.
  ///
  /// It also converts a STORED (on-disk) path into the URL that actually serves
  /// it — see [_publicStoragePath]. An upload endpoint answers with where it
  /// wrote the file, not with where the browser can read it, and feeding that
  /// straight to an image widget yields a URL that can never load.
  static String resolveImageUrl(String rawUrl) {
    if (rawUrl.isEmpty) return rawUrl;

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

  /// Turns the path Laravel STORES a file at into the path it SERVES it from.
  ///
  /// `Storage::disk('public')` writes to `storage/app/public/<dir>/<file>` on
  /// disk, and the `public/storage` symlink exposes exactly that folder at
  /// `/storage/<dir>/<file>`. So the value an upload returns
  /// (`storage\app\public\task_images\x.jpg`) is a filesystem path, not a URL:
  /// it has to lose the `app/public` segment — and its Windows backslashes —
  /// before an image widget can load it.
  ///
  /// Display-only. The raw value is still sent back to the API verbatim
  /// wherever the contract asks for the stored path.
  static String _publicStoragePath(String rawPath) {
    var path = rawPath.replaceAll(r'\', '/');

    const diskPrefix = 'storage/app/public/';
    final index = path.indexOf(diskPrefix);
    if (index != -1) {
      path = 'storage/${path.substring(index + diskPrefix.length)}';
    }

    return path.startsWith('/') ? path : '/$path';
  }

  /// Query key appended to an image URL to force a re-download.
  static const String _cacheBusterKey = 'v';

  /// Returns [url] with a cache-busting `?v=<version>` (replacing any previous
  /// one), so a photo that was REPLACED at the same path is fetched again.
  ///
  /// After an update the server usually keeps serving the avatar from the very
  /// same URL. Flutter's `ImageCache` and `CachedNetworkImage` both key on that
  /// URL, so they keep handing back the OLD bytes no matter how the state
  /// changes. A changed URL is a changed cache key — the widget itself needs no
  /// modification.
  static String withCacheBuster(String url, {required String version}) {
    if (url.isEmpty || version.isEmpty) return url;
    final base = stripCacheBuster(url);
    final separator = base.contains('?') ? '&' : '?';
    return '$base$separator$_cacheBusterKey=$version';
  }

  /// The inverse of [withCacheBuster]: [url] without its `v=` parameter, so two
  /// URLs can be compared for "same underlying image", and so the cache entry
  /// for the un-busted URL can be evicted too.
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
