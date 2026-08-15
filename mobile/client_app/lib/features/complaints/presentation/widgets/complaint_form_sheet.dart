import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/theme/app_theme_info.dart';
import '../../../../config/theme/styles.dart';
import '../../../../core/widgets/custom_toast.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/complaint_entity.dart';
import '../bloc/complaints_bloc.dart';

Future<void> showFeedbackActions({
  required BuildContext context,
  required ComplaintType complaintType,
  required int targetId,
  required String targetName,
  required VoidCallback onReview,
}) async {
  final l = AppLocalizations.of(context)!;
  await showModalBottomSheet<void>(
    context: context,
    backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
    builder: (sheetContext) => SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.star_outline_rounded),
              title: Text(
                l.write_review,
                style: Styles.textStyle14.copyWith(fontWeight: FontWeight.w500),
              ),
              onTap: () {
                Navigator.pop(sheetContext);
                onReview();
              },
            ),
            ListTile(
              leading: const Icon(Icons.report_problem_outlined),
              title: Text(
                l.submit_complaint,
                style: Styles.textStyle14.copyWith(fontWeight: FontWeight.w500),
              ),
              onTap: () {
                Navigator.pop(sheetContext);
                showComplaintForm(
                  context: context,
                  type: complaintType,
                  targetId: targetId,
                  targetName: targetName,
                );
              },
            ),
          ],
        ),
      ),
    ),
  );
}

Future<void> showComplaintForm({
  required BuildContext context,
  required ComplaintType type,
  required int targetId,
  required String targetName,
}) {
  context.read<ComplaintsBloc>().add(const ClearComplaintMessagesEvent());
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withValues(alpha: 0.45),
    builder: (_) => BlocProvider.value(
      value: context.read<ComplaintsBloc>(),
      child: ComplaintFormSheet(
        type: type,
        targetId: targetId,
        targetName: targetName,
        parentContext: context,
      ),
    ),
  );
}

class ComplaintFormSheet extends StatefulWidget {
  const ComplaintFormSheet({
    super.key,
    required this.type,
    required this.targetId,
    required this.targetName,
    required this.parentContext,
  });
  final ComplaintType type;
  final int targetId;
  final String targetName;
  final BuildContext parentContext;

  @override
  State<ComplaintFormSheet> createState() => _ComplaintFormSheetState();
}

class _ComplaintFormSheetState extends State<ComplaintFormSheet> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _body = TextEditingController();

  @override
  void dispose() {
    _title.dispose();
    _body.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    context.read<ComplaintsBloc>().add(
      CreateComplaintEvent(
        type: widget.type,
        targetId: widget.targetId,
        targetName: widget.targetName,
        title: _title.text,
        body: _body.text,
      ),
    );
  }

  InputDecoration _fieldDecoration({
    required String hint,
    required ColorScheme colors,
  }) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(16.r),
      borderSide: BorderSide.none,
    );
    return InputDecoration(
      hintText: hint,
      hintStyle: Styles.textStyle14,
      counterText: '',
      filled: true,
      fillColor: AppThemeInfo.isDark
          ? colors.surfaceContainerHighest.withValues(alpha: 0.55)
          : Colors.grey.withValues(alpha: 0.3),
      contentPadding: EdgeInsets.all(16.r),
      border: border,
      enabledBorder: border,
      disabledBorder: border,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.r),
        borderSide: BorderSide(color: colors.primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.r),
        borderSide: BorderSide(color: colors.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.r),
        borderSide: BorderSide(color: colors.error, width: 1.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;
    final keyboardHeight = MediaQuery.viewInsetsOf(context).bottom;
    return BlocConsumer<ComplaintsBloc, ComplaintsState>(
      listenWhen: (previous, current) =>
          previous.createSucceeded != current.createSucceeded ||
          previous.createError != current.createError,
      listener: (context, state) {
        if (state.createSucceeded) {
          Navigator.pop(context);
          AppSnackBar.showSuccess(
            context: widget.parentContext,
            title: l.complaints,
            message: l.complaint_submitted_successfully,
          );
          widget.parentContext.read<ComplaintsBloc>().add(
            const ClearComplaintMessagesEvent(),
          );
        } else if (state.createError != null) {
          AppSnackBar.showError(
            context: widget.parentContext,
            title: l.error,
            message: state.createError!,
          );
        }
      },
      builder: (context, state) => PopScope(
        canPop: !state.isCreating,
        child: AnimatedPadding(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          padding: EdgeInsets.only(bottom: keyboardHeight),
          child: Container(
            width: double.infinity,
            constraints: BoxConstraints(
              maxHeight: MediaQuery.sizeOf(context).height * 0.85,
            ),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
            ),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(24.w, 12.h, 24.w, 24.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      child: Container(
                        width: 42.w,
                        height: 4.h,
                        decoration: BoxDecoration(
                          color: colors.onSurfaceVariant.withValues(
                            alpha: 0.25,
                          ),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            l.submit_complaint,
                            style: Styles.textStyle18.copyWith(
                              color: colors.onSurface,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: state.isCreating
                              ? null
                              : () => Navigator.of(context).pop(),
                          icon: Icon(
                            Icons.close_rounded,
                            color: colors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    if (widget.targetName.isNotEmpty) ...[
                      SizedBox(height: 8.h),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 10.h,
                        ),
                        decoration: BoxDecoration(
                          color: colors.primaryContainer.withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              widget.type == ComplaintType.company
                                  ? Icons.business_outlined
                                  : Icons.cleaning_services_outlined,
                              size: 20.sp,
                              color: colors.onPrimaryContainer,
                            ),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: Text(
                                widget.targetName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Styles.textStyle12.copyWith(
                                  color: colors.onPrimaryContainer,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    SizedBox(height: 20.h),
                    TextFormField(
                      controller: _title,
                      enabled: !state.isCreating,
                      maxLength: 255,
                      textCapitalization: TextCapitalization.sentences,
                      textInputAction: TextInputAction.next,
                      decoration: _fieldDecoration(
                        hint: l.complaint_subject,
                        colors: colors,
                      ),
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                          ? l.required_field
                          : null,
                    ),
                    SizedBox(height: 14.h),
                    TextFormField(
                      controller: _body,
                      enabled: !state.isCreating,
                      minLines: 4,
                      maxLines: 7,
                      maxLength: 5000,
                      textCapitalization: TextCapitalization.sentences,
                      textInputAction: TextInputAction.newline,
                      decoration: _fieldDecoration(
                        hint: l.complaint_message,
                        colors: colors,
                      ),
                      validator: (value) {
                        final text = value?.trim() ?? '';
                        if (text.isEmpty) return l.required_field;
                        if (text.length < 10) {
                          return l.complaint_message_too_short;
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 24.h),
                    SizedBox(
                      width: double.infinity,
                      height: 52.h,
                      child: FilledButton(
                        onPressed: state.isCreating ? null : _submit,
                        style: FilledButton.styleFrom(
                          backgroundColor: colors.primary,
                          foregroundColor: colors.onPrimary,
                          disabledBackgroundColor: colors.primary.withValues(
                            alpha: 0.55,
                          ),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14.r),
                          ),
                        ),
                        child: state.isCreating
                            ? SizedBox(
                                width: 20.r,
                                height: 20.r,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.2,
                                  color: colors.onPrimary,
                                ),
                              )
                            : Text(
                                l.submit,
                                style: Styles.textStyle14.copyWith(
                                  color: colors.onPrimary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Align(
                      child: TextButton(
                        onPressed: state.isCreating
                            ? null
                            : () => Navigator.of(context).pop(),
                        child: Text(
                          l.cancel,
                          style: Styles.textStyle12.copyWith(
                            color: colors.onSurfaceVariant,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
