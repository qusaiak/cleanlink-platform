import 'package:client_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/routes/app_router.dart';
import '../../../../core/widgets/app_primary_button.dart';
import '../../../../l10n/app_localizations.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_link_button.dart';
import '../widgets/auth_logo.dart';
import '../widgets/auth_password_field.dart';
import '../widgets/auth_phone_field.dart';
import '../widgets/auth_scaffold.dart';

class LoginBody extends StatelessWidget {
  const LoginBody({super.key, required this.state});

  final AuthState state;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final bloc = context.read<AuthBloc>();
    final f = bloc.forms;

    return AuthScaffold(
      child: Form(
        key: f.loginFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 16.h),
            const Center(child: AuthLogo()),
            SizedBox(height: 28.h),
            AuthHeader(
              title: l.auth_login_title,
              subtitle: l.auth_login_subtitle,
            ),
            SizedBox(height: 32.h),
            AuthPhoneField(
              controller: f.loginPhone,
              focusNode: f.loginPhoneFocus,
              label: l.auth_phone_label,
              hint: l.auth_phone_hint,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) => f.loginPasswordFocus.requestFocus(),
            ),
            SizedBox(height: 16.h),
            AuthPasswordField(
              controller: f.loginPassword,
              focusNode: f.loginPasswordFocus,
              label: l.auth_password_label,
              hint: l.auth_password_hint,
              textInputAction: TextInputAction.done,
              // onFieldSubmitted: (_) => bloc.submitLogin(),
            ),
            SizedBox(height: 30.h),
            AppPrimaryButton(
              label: l.auth_login_button,
              // loading: state.isLoading,
              // onPressed: bloc.submitLogin,
              onPressed: () {},
            ),
            SizedBox(height: 14.h),
            Center(
              child: AuthLinkButton(
                label: l.auth_create_account,
                onTap: () => context.push(AppRouter.kRegister),
              ),
            ),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }
}
