import 'package:client_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:client_app/features/auth/presentation/widgets/auth_email_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/functions/validator.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../l10n/app_localizations.dart';
import '../widgets/auth_password_field.dart';
import '../widgets/auth_phone_field.dart';

class RegisterAccountFields extends StatelessWidget {
  const RegisterAccountFields({super.key, required this.state});

  final AuthState state;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final bloc = context.read<AuthBloc>();
    final f = bloc.forms;
    var theme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppTextField(
          controller: f.registerName,
          focusNode: f.registerNameFocus,
          label: l.auth_full_name,
          hint: l.auth_full_name_hint,
          keyboardType: TextInputType.name,
          textInputAction: TextInputAction.next,
          autofocus: true,
          validator: (v) => AppValidators.name(v, context),
          onFieldSubmitted: (_) => f.registerEmailFocus.requestFocus(),
          prefix: Icon(
            Icons.person_outline_rounded,
            color: theme.onSurface.withValues(alpha: 0.55),
            size: 20.r,
          ),
        ),
        SizedBox(height: 16.h),
        AuthEmailField(
          controller: f.registerEmail,
          focusNode: f.registerEmailFocus,
          label: l.auth_email_label,
          hint: l.auth_email_hint,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (_) => f.registerPasswordFocus.requestFocus(),
        ),
        SizedBox(height: 16.h),
        AuthPasswordField(
          controller: f.registerPassword,
          focusNode: f.registerPasswordFocus,
          label: l.auth_password_label,
          hint: l.auth_password_hint,
          useStrongValidator: true,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (_) => f.registerConfirmFocus.requestFocus(),
        ),
        SizedBox(height: 16.h),
        AuthPasswordField(
          controller: f.registerConfirmPassword,
          focusNode: f.registerConfirmFocus,
          label: l.auth_confirm_password_label,
          hint: l.auth_confirm_password_hint,
          textInputAction: TextInputAction.done,
          validator: (v) => AppValidators.confirmPassword(
            v,
            f.registerPassword.text,
            context,
          ),
        ),
      ],
    );
  }
}
