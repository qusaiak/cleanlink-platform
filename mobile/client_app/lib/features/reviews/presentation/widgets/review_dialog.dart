import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/theme/app_theme_info.dart';
import '../../../../config/theme/styles.dart';
import '../../../../core/widgets/custom_toast.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/reviewable_type.dart';
import '../../domain/usecases/add_review_use_case.dart';
import '../bloc/review_bloc.dart';

Future<void> showReviewDialog({
  required BuildContext context,
  required ReviewableType type,
  required int id,
  required VoidCallback onSuccess,
}) async {
  context.read<ReviewBloc>().add(const ResetReviewEvent());

  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withValues(alpha: 0.45),
    builder: (_) {
      return BlocProvider.value(
        value: context.read<ReviewBloc>(),
        child: _ReviewSheet(
          type: type,
          id: id,
          parentContext: context,
          onSuccess: onSuccess,
        ),
      );
    },
  );
}

class _ReviewSheet extends StatefulWidget {
  const _ReviewSheet({
    required this.type,
    required this.id,
    required this.parentContext,
    required this.onSuccess,
  });

  final ReviewableType type;
  final int id;
  final BuildContext parentContext;
  final VoidCallback onSuccess;

  @override
  State<_ReviewSheet> createState() => _ReviewSheetState();
}

class _ReviewSheetState extends State<_ReviewSheet> {
  final TextEditingController _commentController = TextEditingController();

  int _rating = 0;
  bool _showRatingError = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _selectRating(int value) {
    setState(() {
      _rating = value;
      _showRatingError = false;
    });
  }

  void _submit() {
    if (_rating == 0) {
      setState(() => _showRatingError = true);
      return;
    }

    FocusScope.of(context).unfocus();

    context.read<ReviewBloc>().add(
      SubmitReviewEvent(
        AddReviewParams(
          type: widget.type,
          id: widget.id,
          rating: _rating,
          comment: _commentController.text.trim(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final keyboardHeight = MediaQuery.viewInsetsOf(context).bottom;

    return BlocConsumer<ReviewBloc, ReviewState>(
      listenWhen: (previous, current) {
        return previous.errorMessage != current.errorMessage ||
            previous.result != current.result;
      },
      listener: (sheetContext, state) {
        if (state.errorMessage != null) {
          final errorMessage = state.errorMessage!;

          Navigator.of(sheetContext).pop();

          AppSnackBar.showError(
            context: widget.parentContext,
            title: l.error,
            message: errorMessage,
          );

          return;
        }

        if (state.result != null) {
          final message = state.result!.message.trim();

          Navigator.of(sheetContext).pop();

          widget.onSuccess();

          AppSnackBar.showSuccess(
            context: widget.parentContext,
            title: l.success,
            message: message.isEmpty ? l.review_submitted : message,
          );
        }
      },
      builder: (context, state) {
        return PopScope(
          canPop: !state.isSubmitting,
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
                color: colorScheme.surface,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
              ),
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(24.w, 12.h, 24.w, 24.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 42.w,
                      height: 4.h,
                      decoration: BoxDecoration(
                        color: colorScheme.onSurfaceVariant.withValues(
                          alpha: 0.25,
                        ),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                    ),
                    SizedBox(height: 20.h),

                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            l.write_review,
                            style: Styles.textStyle18.copyWith(
                              color: colorScheme.onSurface,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: state.isSubmitting
                              ? null
                              : () => Navigator.of(context).pop(),
                          icon: Icon(
                            Icons.close_rounded,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 24.h),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            l.search_rating,
                            style: Styles.textStyle14.copyWith(
                              color: colorScheme.onSurface,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Semantics(
                          label: l.search_rating,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: List.generate(5, (index) {
                              final value = index + 1;
                              final selected = value <= _rating;

                              return InkWell(
                                onTap: state.isSubmitting
                                    ? null
                                    : () => _selectRating(value),
                                borderRadius: BorderRadius.circular(30.r),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 2.w,
                                    vertical: 4.h,
                                  ),
                                  child: Icon(
                                    selected
                                        ? Icons.star_rounded
                                        : Icons.star_outline_rounded,
                                    size: 30.sp,
                                    color: selected
                                        ? const Color(0xFFFFB800)
                                        : colorScheme.primary,
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
                      ],
                    ),

                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 180),
                      child: _showRatingError
                          ? Padding(
                              key: const ValueKey('rating-error'),
                              padding: EdgeInsets.only(top: 6.h),
                              child: Text(
                                l.rating_required,
                                textAlign: TextAlign.center,
                                style: Styles.textStyle11.copyWith(
                                  color: colorScheme.error,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            )
                          : const SizedBox(key: ValueKey('no-rating-error')),
                    ),

                    SizedBox(height: 24.h),

                    TextField(
                      controller: _commentController,
                      enabled: !state.isSubmitting,
                      minLines: 4,
                      maxLines: 6,
                      maxLength: 500,
                      textInputAction: TextInputAction.newline,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        hintText: l.review_comment_hint,
                        hintStyle: Styles.textStyle14,
                        counterText: '',
                        filled: true,
                        fillColor: AppThemeInfo.isDark
                            ? colorScheme.surfaceContainerHighest.withValues(
                                alpha: 0.55,
                              )
                            : Colors.grey.withValues(alpha: 0.3),
                        contentPadding: EdgeInsets.all(16.r),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.r),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.r),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.r),
                          borderSide: BorderSide(
                            color: colorScheme.primary,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 24.h),

                    SizedBox(
                      width: double.infinity,
                      height: 52.h,
                      child: FilledButton(
                        onPressed: state.isSubmitting ? null : _submit,
                        style: FilledButton.styleFrom(
                          backgroundColor: colorScheme.primary,
                          foregroundColor: colorScheme.onPrimary,
                          disabledBackgroundColor: colorScheme.primary
                              .withValues(alpha: 0.55),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14.r),
                          ),
                        ),
                        child: state.isSubmitting
                            ? SizedBox(
                                width: 20.r,
                                height: 20.r,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.2,
                                  color: colorScheme.onPrimary,
                                ),
                              )
                            : Text(
                                l.submit_review,
                                style: Styles.textStyle14.copyWith(
                                  color: colorScheme.onPrimary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                      ),
                    ),

                    SizedBox(height: 8.h),

                    TextButton(
                      onPressed: state.isSubmitting
                          ? null
                          : () => Navigator.of(context).pop(),
                      child: Text(
                        l.cancel,
                        style: Styles.textStyle12.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
