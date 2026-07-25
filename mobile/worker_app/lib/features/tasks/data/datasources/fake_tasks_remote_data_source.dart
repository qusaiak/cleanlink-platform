import '../../domain/entities/task.dart';
import '../../domain/entities/task_stats.dart';
import '../models/daily_tasks_model.dart';
import '../models/task_model.dart';
import 'tasks_remote_data_source.dart';

/// In-memory mock of [TasksRemoteDataSource] used while there is no backend.
///
/// It keeps a mutable list so status changes and photo uploads persist for the
/// duration of the app session (mimicking a server). It implements the exact
/// same interface as [TasksRemoteDataSourceImpl], so switching to the real API
/// later is a one-line change in `injection_container.dart`.
///
/// The sample content is in Arabic to match the worker designs; a real API
/// would return localized content from the server.
class FakeTasksRemoteDataSource implements TasksRemoteDataSource {
  // Scheduled times use a fixed date (2024-05-24) so the mock is stable and
  // doesn't depend on the wall clock during this phase.
  late final List<TaskModel> _tasks = [
    // Mirrors the customer "Residential Cleaning" booking: the package the
    // customer picked (استوديو/Studio), its price and duration, and the exact
    // "what's included" checklist they saw when booking.
    TaskModel(
      id: '1',
      requestNumber: '4589',
      title: 'تنظيف سكني',
      serviceType: ServiceType.cleaning,
      customerName: 'أحمد علي',
      companyName: 'سباركل كلين',
      location: 'حي النرجس، الرياض',
      packageName: 'استوديو',
      price: 75,
      durationLabel: 'ساعتان',
      // Subject photo (keyword-matched, free image service).
      imageUrl: 'https://loremflickr.com/800/450/cleaning,home?lock=11',
      scheduledAt: DateTime(2024, 5, 24, 10, 0),
      status: TaskStatus.assigned,
      isUrgent: true,
      details:
          'خدمة تنظيف سكني احترافية تشمل إزالة الغبار والشفط ومسح الأرضيات '
          'وتعقيم الحمام وتنظيف المطبخ باستخدام منتجات صديقة للبيئة.',
      includedItems: const [
        'إزالة الغبار عن جميع الأسطح',
        'شفط الأرضيات',
        'مسح الأرضيات',
        'تنظيف الحمام',
        'تلميع المطبخ',
      ],
      requiredTools: const ['مكنسة كهربائية', 'منظفات متعددة الأسطح', 'ممسحة'],
    ),
    TaskModel(
      id: '2',
      requestNumber: '4590',
      title: 'تنظيف عميق',
      serviceType: ServiceType.cleaning,
      customerName: 'محمد السالم',
      companyName: 'ديب كلين برو',
      location: 'حي الياسمين، الرياض',
      packageName: 'فيلا',
      price: 200,
      durationLabel: '4 ساعات',
      imageUrl: 'https://loremflickr.com/800/450/deep,cleaning?lock=22',
      scheduledAt: DateTime(2024, 5, 24, 11, 30),
      status: TaskStatus.inProgress,
      details:
          'تنظيف عميق شامل لكامل الفيلا مع التركيز على الزوايا والأماكن '
          'يصعب الوصول إليها وتعقيم المطبخ والحمامات.',
      includedItems: const [
        'تنظيف داخل الخزائن',
        'إزالة الترسبات الكلسية',
        'تلميع الزجاج والنوافذ',
        'تعقيم الحمامات',
        'تنظيف المطبخ بالكامل',
      ],
      requiredTools: const ['جهاز بخار', 'فرش متنوعة', 'منظفات قوية'],
    ),
    TaskModel(
      id: '3',
      requestNumber: '4591',
      title: 'تنظيف مكتب',
      serviceType: ServiceType.cleaning,
      customerName: 'سارة العتيبي',
      companyName: 'برايت سبيس',
      location: 'حي الملقا، الرياض',
      packageName: 'مكتب صغير',
      price: 120,
      durationLabel: '3 ساعات',
      imageUrl: 'https://loremflickr.com/800/450/office,cleaning?lock=33',
      scheduledAt: DateTime(2024, 5, 24, 13, 0),
      status: TaskStatus.assigned,
      details:
          'تنظيف مكتب احترافي يشمل المكاتب وقاعات الاجتماعات والمطبخ المشترك '
          'مع تفريغ سلال المهملات.',
      includedItems: const [
        'مسح المكاتب والأسطح',
        'شفط السجاد',
        'تنظيف قاعات الاجتماعات',
        'تفريغ سلال المهملات',
      ],
      requiredTools: const ['مكنسة كهربائية', 'مناديل تنظيف', 'معطر جو'],
    ),
    TaskModel(
      id: '4',
      requestNumber: '4592',
      title: 'تنظيف منزل شامل',
      serviceType: ServiceType.cleaning,
      customerName: 'نورة القحطاني',
      companyName: 'شاين هوم',
      location: 'حي العليا، الرياض',
      packageName: '3 غرف نوم',
      price: 300,
      durationLabel: '5 ساعات',
      imageUrl: 'https://loremflickr.com/800/450/house,cleaning?lock=44',
      scheduledAt: DateTime(2024, 5, 25, 9, 0),
      status: TaskStatus.assigned,
      details:
          'تنظيف شامل لكامل المنزل يشمل جميع الغرف والمطبخ والحمامات مع '
          'تلميع الأثاث والنوافذ.',
      includedItems: const [
        'تنظيف جميع الغرف',
        'تلميع الأثاث',
        'تنظيف المطبخ والحمامات',
        'مسح النوافذ',
        'تعقيم الأسطح',
      ],
      requiredTools: const ['مكنسة كهربائية', 'منظفات متعددة', 'ممسحة'],
    ),
    TaskModel(
      id: '5',
      requestNumber: '4593',
      title: 'تنظيف بعد الترميم',
      serviceType: ServiceType.cleaning,
      customerName: 'خالد الزهراني',
      companyName: 'فريش لوك',
      location: 'حي النخيل، جدة',
      packageName: 'فيلا',
      price: 180,
      durationLabel: '4 ساعات',
      imageUrl: 'https://loremflickr.com/800/450/post,construction,cleaning?lock=55',
      scheduledAt: DateTime(2024, 5, 25, 15, 30),
      status: TaskStatus.assigned,
      details:
          'إزالة مخلفات وغبار أعمال الترميم وتنظيف الأسطح والأرضيات بعمق '
          'لتجهيز المكان للسكن.',
      includedItems: const [
        'إزالة مخلفات الترميم',
        'إزالة الغبار العالق',
        'تنظيف الأرضيات بعمق',
        'تلميع النوافذ والزجاج',
      ],
      requiredTools: const ['مكنسة صناعية', 'أكياس نفايات', 'منظفات قوية'],
    ),
  ];

  // Simulated network latency so loading states are exercised.
  Future<void> _delay() => Future.delayed(const Duration(milliseconds: 600));

  DailyTasksModel _snapshot() {
    final liveCompleted =
        _tasks.where((t) => t.status == TaskStatus.completed).length;
    final remaining = _tasks
        .where(
          (t) =>
              t.status != TaskStatus.completed &&
              t.status != TaskStatus.cancelled,
        )
        .length;

    // The design shows "12 / 15"; we pad with an illustrative base of
    // already-finished tasks that aren't kept in the live list.
    const baseCompleted = 12;
    final total = _tasks.length + baseCompleted;

    return DailyTasksModel(
      stats: TaskStats(
        remainingToday: remaining,
        completed: baseCompleted + liveCompleted,
        total: total,
      ),
      tasks: List<TaskModel>.from(_tasks),
    );
  }

  @override
  Future<DailyTasksModel> getDailyTasks() async {
    await _delay();
    return _snapshot();
  }

  @override
  Future<TaskModel> getTaskById(String id) async {
    await _delay();
    // Match by the task id first, then fall back to the human-facing request
    // number (notifications/search may reference either).
    final index = _tasks.indexWhere(
      (t) => t.id == id || t.requestNumber == id,
    );
    if (index == -1) {
      throw StateError('Task $id not found');
    }
    return _tasks[index];
  }

  @override
  Future<TaskModel> updateTaskStatus({
    required String taskId,
    required TaskStatus status,
  }) async {
    await _delay();
    final index = _tasks.indexWhere((t) => t.id == taskId);
    if (index == -1) {
      throw StateError('Task $taskId not found');
    }
    final updated = TaskModel.fromEntity(_tasks[index].copyWith(status: status));
    _tasks[index] = updated;
    return updated;
  }

  @override
  Future<TaskModel> uploadTaskPhotos({
    required String taskId,
    required List<String> beforePaths,
    required List<String> afterPaths,
  }) async {
    await _delay();
    final index = _tasks.indexWhere((t) => t.id == taskId);
    if (index == -1) {
      throw StateError('Task $taskId not found');
    }
    final current = _tasks[index];
    final updated = TaskModel.fromEntity(
      current.copyWith(
        beforePhotos: [...current.beforePhotos, ...beforePaths],
        afterPhotos: [...current.afterPhotos, ...afterPaths],
      ),
    );
    _tasks[index] = updated;
    return updated;
  }
}
