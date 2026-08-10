import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // مكتبة اختيار الصور
import 'package:worker_app/config/theme/colors.dart';

class TaskModel {
  final String title;
  final String department;
  final String time;
  final String location;
  final String note;

  TaskModel({
    required this.title,
    required this.department,
    required this.time,
    required this.location,
    required this.note,
  });
}

void main() => runApp(const MaterialApp(debugShowCheckedModeBanner: false, home: SuperExplosiveUI()));

class SuperExplosiveUI extends StatefulWidget {
  const SuperExplosiveUI({super.key});

  @override
  State<SuperExplosiveUI> createState() => _SuperExplosiveUIState();
}

class _SuperExplosiveUIState extends State<SuperExplosiveUI> {
  String _currentStatus = 'متاح';
  final List<String> _statusOptions = ['متاح', 'مشغول', 'غير متصل'];
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  final List<TaskModel> tasks = [
    TaskModel(
      title: "تركيب نظام طاقة",
      department: "قسم الطاقة الشمسية",
      time: "الآن - يبدأ العمل فوراً",
      location: "دبي، نخلة جميرا، فيلا 104",
      note: "الرجاء ارتداء الزي الرسمي والأدوات كاملة.",
    ),
    TaskModel(
      title: "صيانة شبكة كهرباء",
      department: "قسم الدعم الفني",
      time: "غداً - الساعة 10 صباحاً",
      location: "أبوظبي، شارع الكورنيش، برج 5",
      note: "احضار أدوات القياس الرقمية الحديثة.",
    ),
    TaskModel(
      title: "فحص ألواح شمسية",
      department: "قسم الجودة السلامة",
      time: "الجمعة - الساعة 2 ظهراً",
      location: "الشارقة، منطقة مويلح، مستودع B",
      note: "الالتزام بخوذة الأمان وحزام الأمان.",
    ),
  ];

  void _showCustomSnackBar(BuildContext context, String message, {bool isDelete = false, VoidCallback? onUndo}) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold, color: Colors.white, fontSize: 14),
          textAlign: onUndo != null ? TextAlign.start : TextAlign.center,
        ),
        backgroundColor: isDelete ? Colors.redAccent : AppColor.primaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        margin: const EdgeInsets.all(16),
        duration: Duration(seconds: isDelete ? 5 : 2),
        action: onUndo != null
            ? SnackBarAction(
          label: "تراجع",
          textColor: Colors.white,
          onPressed: onUndo,
        )
            : null,
      ),
    );
  }

  void _deleteCard(int index) {
    final TaskModel deletedTask = tasks[index];
    final int deletedIndex = index;

    setState(() {
      tasks.removeAt(index);
    });

    _listKey.currentState?.removeItem(
      deletedIndex,
          (context, animation) => _buildAnimatedItem(deletedTask, deletedIndex, animation),
      duration: const Duration(milliseconds: 400),
    );

    _showCustomSnackBar(
      context,
      "تم حذف طلب ${deletedTask.title}",
      isDelete: true,
      onUndo: () {
        setState(() {
          tasks.insert(deletedIndex, deletedTask);
        });
        _listKey.currentState?.insertItem(deletedIndex, duration: const Duration(milliseconds: 400));
        _showCustomSnackBar(context, "تم استعادة طلب ${deletedTask.title} بنجاح");
      },
    );
  }

  Color _getBackgroundColor() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    switch (_currentStatus) {
      case 'متاح':
        return isDark ? AppColor.backgroundColorDark : AppColor.backgroundColorLight;
      case 'مشغول':
        return isDark
            ? Color.alphaBlend(AppColor.warningColor.withValues(alpha: 0.18), AppColor.surfaceContainerDark)
            : const Color(0xFFFFF3CD);
      case 'غير متصل':
        return isDark
            ? Color.alphaBlend(AppColor.errorDark.withValues(alpha: 0.18), AppColor.surfaceContainerDark)
            : const Color(0xFFF8D7DA);
      default:
        return isDark ? AppColor.backgroundColorDark : AppColor.backgroundColorLight;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'متاح': return Colors.green;
      case 'مشغول': return Colors.orange;
      case 'غير متصل': return Colors.red;
      default: return AppColor.primaryColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _getBackgroundColor(),
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        color: _getBackgroundColor(),
        child: Stack(
          children: [
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    _buildStatusDropdown(),
                    const SizedBox(height: 30),

                    tasks.isEmpty
                        ? const Expanded(child: Center(child: Text("لا توجد مهام حالية", style: TextStyle(color: AppColor.primaryColor, fontSize: 18, fontWeight: FontWeight.bold))))
                        : SizedBox(
                      height: 480,
                      child: AnimatedList(
                        key: _listKey,
                        scrollDirection: Axis.horizontal,
                        initialItemCount: tasks.length,
                        itemBuilder: (context, index, animation) {
                          return _buildAnimatedItem(tasks[index], index, animation);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedItem(TaskModel task, int index, Animation<double> animation) {
    return SlideTransition(
      position: animation.drive(
        Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero).chain(CurveTween(curve: Curves.easeOutCubic)),
      ),
      child: FadeTransition(
        opacity: animation,
        child: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: _buildMainGlassCard(task, index),
        ),
      ),
    );
  }

  Widget _buildStatusDropdown() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: AppColor.primaryColor.withOpacity(0.08),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColor.primaryColor.withOpacity(0.2), width: 1.5),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButtonFormField<String>(
              initialValue: _currentStatus,
              decoration: const InputDecoration(
                labelText: "حالة العامل الحالية",
                labelStyle: TextStyle(color: AppColor.primaryColor, fontWeight: FontWeight.bold, fontSize: 14),
                border: InputBorder.none,
              ),
              dropdownColor: Theme.of(context).brightness == Brightness.dark
                  ? AppColor.surfaceContainerHighDark.withValues(alpha: 0.95)
                  : Colors.white.withOpacity(0.95),
              icon: const Icon(Icons.arrow_drop_down_circle_outlined, color: AppColor.primaryColor),
              style: const TextStyle(color: AppColor.primaryColor, fontSize: 16, fontWeight: FontWeight.bold),
              items: _statusOptions.map((String status) {
                return DropdownMenuItem<String>(
                  value: status,
                  child: Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(color: _getStatusColor(status), shape: BoxShape.circle),
                      ),
                      const SizedBox(width: 12),
                      Text(status, style: const TextStyle(fontFamily: 'Cairo')),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() { _currentStatus = newValue; });
                  _showCustomSnackBar(context, "تم تغيير حالتك الحالية إلى: $_currentStatus");
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMainGlassCard(TaskModel task, int index) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(40),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          width: 320,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(40),
            border: Border.all(color: AppColor.primaryColor.withOpacity(0.3), width: 2.5),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(30),
                child: Row(
                  children: [
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(task.title, style: const TextStyle(color: AppColor.primaryColor, fontSize: 22, fontWeight: FontWeight.bold)),
                          Text(task.department, style: const TextStyle(color: AppColor.primaryColor, fontWeight: FontWeight.bold, fontSize: 12)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              _buildGlassDetail(Icons.alarm, "الوقت", task.time),
              _buildGlassDetail(Icons.near_me_rounded, "الموقع", task.location),
              _buildGlassDetail(Icons.auto_awesome_motion, "ملاحظة", task.note),
              Padding(
                padding: const EdgeInsets.all(30),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          _showCustomSnackBar(context, "تم قبول الطلب: ${task.title}");
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => TaskDetailsUI(task: task)),
                          );
                        },
                        child: _buildActionBtn("قبول المهمة"),
                      ),
                    ),
                    const SizedBox(width: 15),
                    GestureDetector(
                      onTap: () => _deleteCard(index),
                      child: _buildCircleBtn(Icons.close, AppColor.primaryColor),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGlassDetail(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
      child: Row(
        children: [
          Icon(icon, color: AppColor.primaryColor, size: 20),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(color: AppColor.primaryColor, fontSize: 11)),
                Text(value, style: const TextStyle(color: AppColor.primaryColor, fontSize: 14, fontWeight: FontWeight.w500), maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionBtn(String text) {
    return Container(
      height: 65,
      decoration: BoxDecoration(color: AppColor.primaryColor, borderRadius: BorderRadius.circular(25), border: Border.all(color: Colors.white10)),
      child: Center(child: Text(text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
    );
  }

  Widget _buildCircleBtn(IconData icon, Color color) {
    return Container(
      height: 65,
      width: 65,
      decoration: BoxDecoration(color: AppColor.primaryColor, borderRadius: BorderRadius.circular(25), border: Border.all(color: Colors.white10)),
      child: Icon(icon, color: Colors.white),
    );
  }
}

// ==========================================================
// واجهة التفاصيل - تدعم الآن اختيار ومعاينة مجموعة صور متعددة
// ==========================================================
class TaskDetailsUI extends StatefulWidget {
  final TaskModel task;
  const TaskDetailsUI({super.key, required this.task});

  @override
  State<TaskDetailsUI> createState() => _TaskDetailsUIState();
}

class _TaskDetailsUIState extends State<TaskDetailsUI> {
  final List<String> _steps = ["تم التعيين", "في الطريق", "قيد التنفيذ", "مكتملة"];
  int _currentStepIndex = 0;

  // 1. تحويل المتغير إلى قائمة (List) لتخزين وإدارة عدة ملفات صور معاً
  final List<File> _pickedImagesList = [];
  final ImagePicker _picker = ImagePicker();

  // دالة جلب عدة صور من الاستوديو دفعة واحدة
  Future<void> _getMultipleImagesFromGallery() async {
    try {
      final List<XFile> images = await _picker.pickMultiImage(imageQuality: 80);
      if (images.isNotEmpty) {
        setState(() {
          _pickedImagesList.addAll(images.map((img) => File(img.path)));
        });
        _showCustomSnackBar("تمت إضافة ${images.length} صور للقائمة.");
      }
    } catch (e) {
      _showCustomSnackBar("فشل الوصول للاستوديو.");
    }
  }

  // دالة التقاط صورة واحدة بالكاميرا وإضافتها التتابعية للقائمة الحالية
  Future<void> _captureImageFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.camera, imageQuality: 80);
      if (image != null) {
        setState(() {
          _pickedImagesList.add(File(image.path));
        });
        _showCustomSnackBar("تم التقاط الصورة وإضافتها المجموعتك.");
      }
    } catch (e) {
      _showCustomSnackBar("فشل تشغيل كاميرا الهاتف.");
    }
  }

  void _showImageSourceBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? AppColor.surfaceContainerHighDark.withValues(alpha: 0.95)
          : Colors.white.withOpacity(0.9),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      builder: (context) {
        return ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(width: 40, height: 5, decoration: BoxDecoration(color: AppColor.primaryColor.withOpacity(0.3), borderRadius: BorderRadius.circular(10))),
                  const SizedBox(height: 20),
                  const Text("إرفاق تقرير مصور لإنهاء العمل", style: TextStyle(fontFamily: 'Cairo', fontSize: 16, fontWeight: FontWeight.bold, color: AppColor.primaryColor)),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildSourceOptionTile(Icons.camera_alt_rounded, "لقطة بالكاميرا", () {
                        Navigator.pop(context);
                        _captureImageFromCamera();
                      }),
                      _buildSourceOptionTile(Icons.photo_library_rounded, "اختيار متعدد", () {
                        Navigator.pop(context);
                        _getMultipleImagesFromGallery();
                      }),
                    ],
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSourceOptionTile(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 65,
            height: 65,
            decoration: BoxDecoration(color: AppColor.primaryColor, shape: BoxShape.circle, boxShadow: [BoxShadow(color: AppColor.primaryColor.withOpacity(0.3), blurRadius: 10, spreadRadius: 1)]),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(height: 10),
          Text(label, style: const TextStyle(fontFamily: 'Cairo', fontSize: 13, fontWeight: FontWeight.bold, color: AppColor.primaryColor)),
        ],
      ),
    );
  }

  void _showCustomSnackBar(String msg) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: const TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold), textAlign: TextAlign.center),
        backgroundColor: AppColor.primaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  Color _getStepBackgroundColor() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    switch (_currentStepIndex) {
      case 0:
        return isDark ? AppColor.backgroundColorDark : AppColor.backgroundColorLight;
      case 1:
        return isDark
            ? Color.alphaBlend(AppColor.successColor.withValues(alpha: 0.18), AppColor.surfaceContainerDark)
            : const Color(0xFFE2F0D9);
      case 2:
        return isDark
            ? Color.alphaBlend(AppColor.warningColor.withValues(alpha: 0.18), AppColor.surfaceContainerDark)
            : const Color(0xFFFFF3CD);
      case 3:
        return isDark
            ? Color.alphaBlend(AppColor.infoColor.withValues(alpha: 0.18), AppColor.surfaceContainerDark)
            : const Color(0xFFD1ECF1);
      default:
        return isDark ? AppColor.backgroundColorDark : AppColor.backgroundColorLight;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _getStepBackgroundColor(),
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        color: _getStepBackgroundColor(),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, color: AppColor.primaryColor),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(height: 20),

                  _buildDetailsCard(),

                  const SizedBox(height: 40),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text("تحديث حالة الخدمة الحالية:", style: TextStyle(color: AppColor.primaryColor, fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 24),

                  _buildHorizontalStepper(),

                  const SizedBox(height: 40),

                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    child: _currentStepIndex == 3
                        ? _buildUploadPhotosSection()
                        : const SizedBox.shrink(),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUploadPhotosSection() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.3),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.green.withOpacity(0.4), width: 2),
          ),
          child: Column(
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle, color: Colors.green, size: 24),
                  SizedBox(width: 8),
                  Text("اكتملت المهمة بنجاح!", style: TextStyle(color: AppColor.primaryColor, fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 12),
              const Text("يرجى إرفاق صور العمل المنجز لإرسالها للتدقيق التقني.", style: TextStyle(color: AppColor.primaryColor, fontSize: 13), textAlign: TextAlign.center),
              const SizedBox(height: 20),

              // 2. بناء شبكة عرض تفاعلية مرنة (Grid) لمعاينة كافة الصور المختارة معاً
              if (_pickedImagesList.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: GridView.builder(
                    shrinkWrap: true, // لكي يأخذ الـ Grid مساحة العناصر فقط ولا يحدث خطأ تجاوز
                    physics: const NeverScrollableScrollPhysics(), // تعطيل السحب الداخلي
                    itemCount: _pickedImagesList.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, // عرض 3 صور في كل سطر بشكل متناسق
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemBuilder: (context, index) {
                      return Stack(
                        children: [
                          Positioned.fill(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.file(_pickedImagesList[index], fit: BoxFit.cover),
                            ),
                          ),
                          // زر X أعلى كل صورة مستقلة لحذفها الفوري من المصفوفة
                          Positioned(
                            top: 4,
                            right: 4,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _pickedImagesList.removeAt(index);
                                });
                              },
                              child: CircleAvatar(
                                backgroundColor: Colors.black.withOpacity(0.7),
                                radius: 12,
                                child: const Icon(Icons.close, color: Colors.white, size: 12),
                              ),
                            ),
                          )
                        ],
                      );
                    },
                  ),
                ),

              ElevatedButton.icon(
                onPressed: _showImageSourceBottomSheet,
                icon: const Icon(Icons.add_photo_alternate_outlined, color: Colors.white),
                // تبديل نص الزر بذكاء بناء على محتوى القائمة المرفقة
                label: Text(_pickedImagesList.isEmpty ? "إضافة صور العمل" : "إضافة المزيد من الصور", style: const TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.primaryColor,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  elevation: 5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailsCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: AppColor.primaryColor.withOpacity(0.3), width: 2),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.task.title, style: const TextStyle(color: AppColor.primaryColor, fontSize: 24, fontWeight: FontWeight.bold)),
              Text(widget.task.department, style: const TextStyle(color: AppColor.primaryColor, fontSize: 14, fontWeight: FontWeight.bold)),
              const Divider(color: AppColor.primaryColor, height: 30, thickness: 1),
              _buildDetailItem(Icons.alarm, "الوقت", widget.task.time),
              _buildDetailItem(Icons.near_me_rounded, "الموقع", widget.task.location),
              _buildDetailItem(Icons.auto_awesome_motion, "ملاحظة خاصة", widget.task.note),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: AppColor.primaryColor, size: 22),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(color: AppColor.primaryColor.withOpacity(0.6), fontSize: 12)),
                Text(value, style: const TextStyle(color: AppColor.primaryColor, fontSize: 15, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHorizontalStepper() {
    return Stack(
      children: [
        Positioned(
          top: 20,
          left: 30,
          right: 30,
          child: Container(
            height: 4,
            color: AppColor.primaryColor.withOpacity(0.2),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(_steps.length, (index) {
            bool isCurrentOrPast = index <= _currentStepIndex;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _currentStepIndex = index;
                });
                _showCustomSnackBar("تم تحديث حالة الطلب إلى: ${_steps[index]}");
              },
              child: Column(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: isCurrentOrPast ? AppColor.primaryColor : Colors.white.withOpacity(0.8),
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColor.primaryColor, width: 3),
                      boxShadow: isCurrentOrPast
                          ? [BoxShadow(color: AppColor.primaryColor.withOpacity(0.4), blurRadius: 10, spreadRadius: 1)]
                          : [],
                    ),
                    child: Center(
                      child: Icon(
                        index < _currentStepIndex ? Icons.check : Icons.circle,
                        size: index < _currentStepIndex ? 18 : 12,
                        color: isCurrentOrPast ? Colors.white : AppColor.primaryColor.withOpacity(0.4),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _steps[index],
                    style: TextStyle(
                      color: isCurrentOrPast ? AppColor.primaryColor : AppColor.primaryColor.withOpacity(0.5),
                      fontSize: 12,
                      fontWeight: isCurrentOrPast ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ],
    );
  }
}
