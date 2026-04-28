import 'package:client_app/core/utils/functions/spinkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../config/theme/colors.dart';
import '../../config/theme/styles.dart';

class AppPrimaryButton extends StatefulWidget {
  const AppPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.loading = false,
    this.enabled = true,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  final bool enabled;
  final IconData? icon;

  @override
  State<AppPrimaryButton> createState() => _AppPrimaryButtonState();
}

class _AppPrimaryButtonState extends State<AppPrimaryButton> {
  DateTime _lastTap = DateTime.fromMillisecondsSinceEpoch(0);

  void _handleTap() {
    final now = DateTime.now();
    if (now.difference(_lastTap) < const Duration(milliseconds: 350)) return;
    _lastTap = now;
    widget.onPressed?.call();
  }

  @override
  Widget build(BuildContext context) {
    final disabled =
        !widget.enabled || widget.loading || widget.onPressed == null;

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: disabled ? 0.5 : 1,
      child: InkWell(
        onTap: disabled ? null : _handleTap,
        borderRadius: BorderRadius.circular(14.r),
        child: Ink(
          height: 52.h,
          decoration: BoxDecoration(
            color: disabled ? AppColor.gray300 : AppColor.primaryColor,
            borderRadius: BorderRadius.circular(14.r),
          ),
          child: Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: widget.loading
                  ? spinKitApp(Colors.white)
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.icon != null) ...[
                          Icon(widget.icon, color: Colors.white, size: 20.r),
                          SizedBox(width: 8.w),
                        ],
                        Text(
                          widget.label,
                          style: Styles.textStyle16.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
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
