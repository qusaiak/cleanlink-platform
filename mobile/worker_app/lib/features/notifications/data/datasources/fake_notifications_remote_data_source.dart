import '../../domain/entities/app_notification.dart';
import '../models/app_notification_model.dart';
import 'notifications_remote_data_source.dart';

/// In-memory mock of [NotificationsRemoteDataSource] used while there is no
/// backend. Keeps a mutable list so read-state changes persist for the session
/// (mimicking a server). Implements the same interface as the real source, so
/// switching to the API later is a one-line change in `injection_container`.
///
/// The headline sample is a `client_request`: a client requested this worker
/// for a service while the worker is scheduled as available — exactly the event
/// the feature is meant to surface.
class FakeNotificationsRemoteDataSource
    implements NotificationsRemoteDataSource {
  // Fixed timestamps so the mock is stable and doesn't depend on the wall clock
  // during this phase.
  late final List<AppNotificationModel> _items = [
    // Each notification's requestId maps to a task (see the fake tasks source),
    // so tapping it opens that task's details.
    AppNotificationModel(
      id: 'n1',
      type: AppNotificationType.clientRequest,
      title: 'طلب خدمة جديد',
      body: 'طلب منك العميل سارة العتيبي خدمة تنظيف مكتب.',
      createdAt: DateTime(2024, 5, 24, 9, 15),
      isRead: false,
      requestId: '4591',
      clientName: 'سارة العتيبي',
      serviceName: 'تنظيف مكتب',
      location: 'حي الملقا، الرياض',
      scheduledAt: DateTime(2024, 5, 24, 13, 0),
    ),
    AppNotificationModel(
      id: 'n2',
      type: AppNotificationType.taskReminder,
      title: 'تذكير بموعد',
      body: 'لديك مهمة تنظيف عميق تبدأ الساعة 11:30 صباحاً.',
      createdAt: DateTime(2024, 5, 24, 8, 0),
      isRead: false,
      requestId: '4590',
      scheduledAt: DateTime(2024, 5, 24, 11, 30),
    ),
    AppNotificationModel(
      id: 'n3',
      type: AppNotificationType.taskAssigned,
      title: 'تم تعيين مهمة',
      body: 'تم تعيين مهمة تنظيف سكني لك من قبل الإدارة.',
      createdAt: DateTime(2024, 5, 23, 18, 30),
      isRead: true,
      requestId: '4589',
    ),
  ];

  Future<void> _delay() => Future.delayed(const Duration(milliseconds: 500));

  @override
  Future<List<AppNotificationModel>> getNotifications() async {
    await _delay();
    // Newest first.
    final sorted = [..._items]
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return sorted;
  }

  @override
  Future<AppNotificationModel> markAsRead(String id) async {
    await _delay();
    final index = _items.indexWhere((n) => n.id == id);
    if (index == -1) {
      throw StateError('Notification $id not found');
    }
    final updated =
        AppNotificationModel.fromEntity(_items[index].copyWith(isRead: true));
    _items[index] = updated;
    return updated;
  }

  @override
  Future<List<AppNotificationModel>> markAllAsRead() async {
    await _delay();
    for (var i = 0; i < _items.length; i++) {
      _items[i] =
          AppNotificationModel.fromEntity(_items[i].copyWith(isRead: true));
    }
    return [..._items]..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }
}
