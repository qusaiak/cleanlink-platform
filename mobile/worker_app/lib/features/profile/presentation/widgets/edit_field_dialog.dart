import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/theme/styles.dart';
import '../../../../core/utils/functions/localized_failure_message.dart';
import '../../../../core/utils/functions/spinkit.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/custom_elevated_button.dart';
import '../../../../core/widgets/custom_outlined_button.dart';
import '../../../../l10n/app_localizations.dart';
import '../bloc/worker_profile_bloc.dart';

class EditFieldDialog extends StatefulWidget {
  final String title;
  final String label;
  final String initialValue;
  final TextInputType keyboardType;
  final FormFieldValidator<String>? validator;

  final SaveProfileField Function(String value) buildEvent;

  const EditFieldDialog({
    super.key,
    required this.title,
    required this.label,
    required this.initialValue,
    required this.buildEvent,
    this.keyboardType = TextInputType.text,
    this.validator,
  });

  @override
  State<EditFieldDialog> createState() => _EditFieldDialogState();
}

class _EditFieldDialogState extends State<EditFieldDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _controller = TextEditingController(
    text: widget.initialValue,
  );

  bool _submitting = false;
  String? _serverError;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _save() {
    if (_submitting) return;
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final value = _controller.text.trim();

    if (value == widget.initialValue.trim()) {
      Navigator.of(context).pop();
      return;
    }
    setState(() {
      _submitting = true;
      _serverError = null;
    });
    context.read<WorkerProfileBloc>().add(widget.buildEvent(value));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final l = AppLocalizations.of(context)!;

    return BlocListener<WorkerProfileBloc, WorkerProfileState>(
      listenWhen: (prev, curr) =>
          curr.status == WorkerProfileStatus.saveFieldSuccess ||
          curr.status == WorkerProfileStatus.saveFieldFailure,
      listener: (context, state) {
        if (!_submitting) return;
        if (state.status == WorkerProfileStatus.saveFieldSuccess) {
          Navigator.of(context).pop();
        } else if (state.status == WorkerProfileStatus.saveFieldFailure) {
          setState(() {
            _submitting = false;
            _serverError = localizedFailureMessage(context, state.error);
          });
        }
      },
      child: Dialog(
        backgroundColor: theme.surface,
        surfaceTintColor: theme.surface,
        insetPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 16.h),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: Styles.textStyle16.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16.h),
                AppTextField(
                  controller: _controller,
                  label: widget.label,
                  keyboardType: widget.keyboardType,
                  textInputAction: TextInputAction.done,
                  autofocus: true,
                  validator: widget.validator,
                  onFieldSubmitted: (_) => _save(),
                ),
                if (_serverError != null) ...[
                  SizedBox(height: 8.h),
                  Text(
                    _serverError!,
                    style: Styles.textStyle12.copyWith(color: theme.error),
                  ),
                ],
                SizedBox(height: 16.h),
                Row(
                  children: [
                    Expanded(
                      child: CustomOutlinedButton(
                        text: l.cancel,
                        height: 44.h,

                        isDisabled: _submitting,
                        onPressed: () => Navigator.of(context).pop(),
                        buttonTextStyle: Styles.textStyle14.copyWith(
                          color: theme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                        buttonStyle: OutlinedButton.styleFrom(
                          side: BorderSide(color: theme.primary),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: CustomElevatedButton(
                        text: l.save,
                        height: 44.h,

                        isDisabled: _submitting,
                        onPressed: _save,
                        leftIcon: _submitting
                            ? SizedBox(
                                width: 18.r,
                                height: 18.r,
                                child: spinKitApp(Colors.white),
                              )
                            : null,
                        buttonTextStyle: Styles.textStyle14.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                        buttonStyle: ElevatedButton.styleFrom(
                          backgroundColor: theme.primary,
                          disabledBackgroundColor: theme.primary.withValues(
                            alpha: 0.6,
                          ),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> showEditFieldDialog(
  BuildContext context, {
  required WorkerProfileBloc bloc,
  required String title,
  required String label,
  required String initialValue,
  required SaveProfileField Function(String value) buildEvent,
  TextInputType keyboardType = TextInputType.text,
  FormFieldValidator<String>? validator,
}) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,

    builder: (_) => BlocProvider.value(
      value: bloc,
      child: EditFieldDialog(
        title: title,
        label: label,
        initialValue: initialValue,
        keyboardType: keyboardType,
        validator: validator,
        buildEvent: buildEvent,
      ),
    ),
  );
}
