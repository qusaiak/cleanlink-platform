import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:worker_app/features/auth/presentation/widgets/password_strength_indicator.dart';

import '../../../../core/utils/functions/validator.dart';
import '../../../../core/widgets/app_primary_button.dart';
import '../../../../l10n/app_localizations.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_logo.dart';
import '../widgets/auth_password_field.dart';
import '../widgets/auth_scaffold.dart';

class ChangePasswordBody extends StatelessWidget {
  const ChangePasswordBody({super.key, required this.state});

  final AuthState state;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final bloc = context.read<AuthBloc>();
    final f = bloc.forms;

    return AuthScaffold(
      child: Form(
        key: f.changeFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 8.h),
            const Center(child: AuthLogo()),
            SizedBox(height: 24.h),
            AuthHeader(
              title: l.auth_change_password_title,
              subtitle: l.auth_change_password_subtitle,
            ),
            SizedBox(height: 28.h),
            AuthPasswordField(
              controller: f.changeOldPassword,
              focusNode: f.changeOldFocus,
              label: l.auth_old_password_label,
              hint: l.auth_password_hint,
              textInputAction: TextInputAction.next,
              validator: (v) => AppValidators.required(v, context),
              onFieldSubmitted: (_) => f.changeNewFocus.requestFocus(),
            ),
            SizedBox(height: 18.h),
            AuthPasswordField(
              controller: f.changeNewPassword,
              focusNode: f.changeNewFocus,
              label: l.auth_new_password_label,
              hint: l.auth_password_hint,
              useStrongValidator: true,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) => f.changeConfirmFocus.requestFocus(),
            ),
            SizedBox(height: 12.h),
            PasswordStrengthIndicator(controller: f.changeNewPassword),
            SizedBox(height: 18.h),
            AuthPasswordField(
              controller: f.changeConfirmPassword,
              focusNode: f.changeConfirmFocus,
              label: l.auth_confirm_password_label,
              hint: l.auth_confirm_password_hint,
              textInputAction: TextInputAction.done,
              validator: (v) => AppValidators.confirmPassword(
                v,
                f.changeNewPassword.text,
                context,
              ),
              // onFieldSubmitted: (_) => bloc.submitChangePassword(),
              onFieldSubmitted: (_) {},
            ),
            SizedBox(height: 28.h),
            AppPrimaryButton(
              label: l.auth_update_password,
              loading: state.status == AuthStatus.loadingChangePassword,
              onPressed: () {
                if (!f.changeFormKey.currentState!.validate()) return;
                bloc.add(
                  SubmitChangePassword(
                    oldPassword: f.changeOldPassword.text,
                    newPassword: f.changeNewPassword.text,
                    newPasswordConfirmation: f.changeConfirmPassword.text,
                  ),
                );
              },
            ),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }
}
