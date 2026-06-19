import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../config/theme/styles.dart';
import '../../../../core/utils/functions/build_app_snack_bar.dart';
import '../../../../core/widgets/custom_image_view.dart';
import '../../../../l10n/app_localizations.dart';

/// "Visual documentation" section: two slots (before / after) where the worker
/// attaches photos via camera or gallery (uses image_picker). Already-uploaded
/// photos are shown for context; newly-picked ones can be removed before
/// submitting.
class TaskPhotoDocumentation extends StatelessWidget {
  final List<String> beforeExisting;
  final List<String> afterExisting;
  final List<String> beforeNew;
  final List<String> afterNew;

  /// Called with the picked file path for the given slot.
  final void Function(bool isBefore, String path) onPicked;

  /// Called to remove a not-yet-uploaded photo at [index] from the slot.
  final void Function(bool isBefore, int index) onRemoveNew;

  const TaskPhotoDocumentation({
    super.key,
    required this.beforeExisting,
    required this.afterExisting,
    required this.beforeNew,
    required this.afterNew,
    required this.onPicked,
    required this.onRemoveNew,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(context, l.visual_documentation),
        SizedBox(height: 12.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _slot(
                context,
                label: l.photo_before,
                isBefore: true,
                existing: beforeExisting,
                picked: beforeNew,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _slot(
                context,
                label: l.photo_after,
                isBefore: false,
                existing: afterExisting,
                picked: afterNew,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _sectionTitle(BuildContext context, String text) {
    final theme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Icon(Icons.photo_camera_outlined, size: 18.r, color: theme.primary),
        SizedBox(width: 8.w),
        Text(
          text,
          style: Styles.textStyle14.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _slot(
    BuildContext context, {
    required String label,
    required bool isBefore,
    required List<String> existing,
    required List<String> picked,
  }) {
    final theme = Theme.of(context).colorScheme;
    final preview = picked.isNotEmpty
        ? picked.last
        : (existing.isNotEmpty ? existing.last : null);
    final count = existing.length + picked.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => _showSourceSheet(context, isBefore),
          child: SizedBox(
            height: 120.h,
            child: CustomPaint(
              painter: _DashedBorderPainter(
                color: theme.primary.withValues(alpha: 0.4),
                radius: 14.r,
              ),
              child: preview == null
                  ? _placeholder(theme, label)
                  : _previewTile(theme, preview, count),
            ),
          ),
        ),
        // Removable thumbnails for the not-yet-uploaded photos.
        if (picked.isNotEmpty) _pickedStrip(theme, isBefore, picked),
      ],
    );
  }

  Widget _placeholder(ColorScheme theme, String label) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.add_a_photo_outlined, size: 28.r, color: theme.primary),
          SizedBox(height: 8.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: Styles.textStyle11.copyWith(color: theme.onSurfaceVariant),
            ),
          ),
        ],
      ),
    );
  }

  Widget _previewTile(ColorScheme theme, String path, int count) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14.r),
      child: Stack(
        fit: StackFit.expand,
        children: [
          CustomImageView(imagePath: path, fit: BoxFit.cover),
          // "add more" affordance + count badge.
          PositionedDirectional(
            end: 6.w,
            bottom: 6.h,
            child: Container(
              padding: EdgeInsets.all(4.r),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.55),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add_a_photo, size: 14.r, color: Colors.white),
                  SizedBox(width: 4.w),
                  Text(
                    '$count',
                    style: Styles.textStyle11.copyWith(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _pickedStrip(ColorScheme theme, bool isBefore, List<String> picked) {
    return Padding(
      padding: EdgeInsets.only(top: 8.h),
      child: Wrap(
        spacing: 6.w,
        runSpacing: 6.h,
        children: [
          for (int i = 0; i < picked.length; i++)
            Stack(
              clipBehavior: Clip.none,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: CustomImageView(
                    imagePath: picked[i],
                    width: 44.w,
                    height: 44.w,
                    fit: BoxFit.cover,
                  ),
                ),
                PositionedDirectional(
                  end: -6.w,
                  top: -6.h,
                  child: GestureDetector(
                    onTap: () => onRemoveNew(isBefore, i),
                    child: CircleAvatar(
                      radius: 9.r,
                      backgroundColor: Colors.black.withValues(alpha: 0.7),
                      child: Icon(Icons.close, size: 11.r, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  /// Bottom sheet to choose the photo source, then pick and report it back.
  void _showSourceSheet(BuildContext context, bool isBefore) {
    final theme = Theme.of(context).colorScheme;
    final l = AppLocalizations.of(context)!;

    showModalBottomSheet(
      context: context,
      backgroundColor: theme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 16.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 4.h),
                  child: Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(
                      l.attach_photo_title,
                      style: Styles.textStyle16.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.camera_alt_rounded, color: theme.primary),
                  title: Text(l.take_photo, style: Styles.textStyle14),
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    _pick(context, ImageSource.camera, isBefore);
                  },
                ),
                ListTile(
                  leading:
                      Icon(Icons.photo_library_rounded, color: theme.primary),
                  title: Text(l.choose_from_gallery, style: Styles.textStyle14),
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    _pick(context, ImageSource.gallery, isBefore);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _pick(
    BuildContext context,
    ImageSource source,
    bool isBefore,
  ) async {
    final l = AppLocalizations.of(context)!;
    try {
      final picker = ImagePicker();
      final XFile? image =
          await picker.pickImage(source: source, imageQuality: 80);
      if (image == null) return;
      onPicked(isBefore, image.path);
      if (context.mounted) {
        showAppSnackBar(context, message: l.photo_added_message);
      }
    } catch (_) {
      if (context.mounted) {
        showAppSnackBar(
          context,
          message: l.photo_pick_failed_message,
          type: SnackBarType.error,
        );
      }
    }
  }
}

/// Paints a rounded dashed border (the design's photo-slot outline).
class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final double radius;

  _DashedBorderPainter({required this.color, required this.radius});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final rrect = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(radius),
    );
    final path = Path()..addRRect(rrect);

    const dashWidth = 6.0;
    const dashGap = 4.0;
    for (final metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        canvas.drawPath(
          metric.extractPath(distance, distance + dashWidth),
          paint,
        );
        distance += dashWidth + dashGap;
      }
    }
  }

  @override
  bool shouldRepaint(_DashedBorderPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.radius != radius;
}
