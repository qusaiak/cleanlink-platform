import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/theme/styles.dart';
import '../../../../core/utils/functions/spinkit.dart';

/// A single skill pill, in the two states the skills card needs:
///
///  - [owned] `true`  → a filled, primary-tinted chip with a "×" that detaches
///    it on ONE tap;
///  - [owned] `false` → an outlined chip with a "+" that attaches it on ONE
///    tap.
///
/// While that skill's own request is in flight ([pending]) the trailing icon is
/// swapped for the app's spinner and the chip stops responding — so the chip
/// that was tapped shows its progress, cannot be tapped twice, and every OTHER
/// chip stays usable.
///
/// ## Why [maxWidth] exists
///
/// These chips live in a [Wrap], and a Wrap lays its children out with an
/// UNBOUNDED main-axis constraint. Inside unbounded width, `Flexible` has
/// nothing to flex against and `softWrap` can never trigger: the label is laid
/// out on one infinitely-wide line, so a long Arabic name is clipped by the
/// chip's own decoration no matter what the Text is told to do. Handing the
/// chip a real upper bound — the parent's measured width — is what actually
/// lets the label wrap onto a second line. Nothing here sets a fixed HEIGHT, so
/// the chip grows with its content.
class SkillChip extends StatelessWidget {
  /// The already-localized display name. Wraps freely; never truncated.
  final String label;

  /// Whether the worker currently has this skill.
  final bool owned;

  /// Whether this skill's attach/detach request is running right now.
  final bool pending;

  /// The widest this chip may be — normally the content width of the card it
  /// sits in, so a long name wraps instead of overflowing.
  final double maxWidth;

  /// Tapped. Null disables the chip.
  final VoidCallback? onPressed;

  const SkillChip({
    super.key,
    required this.label,
    required this.owned,
    required this.pending,
    required this.maxWidth,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final enabled = onPressed != null && !pending;

    final foreground = owned ? theme.primary : theme.onSurfaceVariant;
    final background = owned
        ? theme.primary.withValues(alpha: 0.08)
        : Colors.transparent;
    final border = owned
        ? theme.primary.withValues(alpha: 0.18)
        : theme.onSurface.withValues(alpha: 0.12);

    return ConstrainedBox(
      // Bounded width → the label below can actually wrap. `maxWidth` only
      // caps the chip; a short name still shrink-wraps to its text.
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: Opacity(
        opacity: enabled ? 1 : 0.55,
        child: Material(
          color: background,
          borderRadius: BorderRadius.circular(16.r),
          child: InkWell(
            borderRadius: BorderRadius.circular(16.r),
            onTap: enabled ? onPressed : null,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: border),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                // Keeps the icon aligned with the FIRST line of a name that
                // wrapped onto several, instead of floating in the middle.
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Flexible (not Expanded): a short name keeps the chip small,
                  // a long one is allowed to take the remaining width and wrap.
                  Flexible(
                    child: Text(
                      label,
                      softWrap: true,
                      // No maxLines and no overflow: the name is shown in full,
                      // however many lines that takes.
                      style: Styles.textStyle12.copyWith(
                        color: foreground,
                        fontWeight: FontWeight.w600,
                        height: 1.35,
                      ),
                    ),
                  ),
                  SizedBox(width: 6.w),
                  // Fixed box for the ICON only — never for the chip itself —
                  // so the trailing action can't be squeezed out or clip the
                  // text at either end in LTR or RTL.
                  Padding(
                    padding: EdgeInsets.only(top: 1.h),
                    child: SizedBox(
                      width: 16.r,
                      height: 16.r,
                      child: pending
                          ? spinKitApp(foreground)
                          : Icon(
                              owned ? Icons.close_rounded : Icons.add_rounded,
                              size: 16.r,
                              color: foreground,
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
