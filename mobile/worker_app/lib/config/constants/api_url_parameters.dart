/// Centralized API endpoint paths.
///
/// NOTE: [baseUrl] is a placeholder — set it to the real CleanLink worker API
/// base URL (and configure it on the shared `Dio` instance in
/// `injection_container.dart`) when the backend is available. Until then the
/// app is driven by the in-memory fake data source, so these paths are unused
/// at runtime but document the expected real contract.
class ApiUrlParameters {
  static const String baseUrl = 'https://api.cleanlink.example/v1';

  /// GET → worker's tasks for today + summary stats ([DailyTasks]).
  static const String dailyTasks = '/worker/tasks/daily';

  /// GET `/worker/tasks/{id}` → a single task's full details. Used when opening
  /// a task from a search result or a notification (which only carry an id).
  static String taskById(String taskId) => '/worker/tasks/$taskId';

  /// PATCH `/worker/tasks/{id}/status` → update a task's lifecycle status.
  static String taskStatus(String taskId) => '/worker/tasks/$taskId/status';

  /// POST `/worker/tasks/{id}/photos` → upload before/after documentation.
  static String taskPhotos(String taskId) => '/worker/tasks/$taskId/photos';

  /// GET → the signed-in worker's profile.
  static const String workerProfile = '/worker/profile';

  /// PATCH → update the worker's availability (available/busy/offline).
  static const String workerAvailability = '/worker/availability';

  /// GET → the worker's notifications feed (newest first). A client requesting
  /// an available worker arrives here as a `client_request` notification.
  static const String notifications = '/worker/notifications';

  /// PATCH `/worker/notifications/{id}/read` → mark a single notification read.
  static String markNotificationRead(String id) =>
      '/worker/notifications/$id/read';

  /// PATCH → mark every notification read.
  static const String markAllNotificationsRead =
      '/worker/notifications/read-all';

  /// GET → search services / job requests.
  ///
  /// Query params:
  ///  - `mode`  → `general` (free-text across everything) or `custom`.
  ///  - `field` → when custom: `service_name` | `client_name` | `location` |
  ///              `time`.
  ///  - `q`     → the search term.
  static const String searchServices = '/worker/services/search';
}
