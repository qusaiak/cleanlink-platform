import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/routes/app_router.dart';
import '../../../../config/theme/styles.dart';
import '../../../../core/widgets/app_primary_button.dart';
import '../../../../l10n/app_localizations.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_link_button.dart';
import '../widgets/auth_logo.dart';
import '../widgets/auth_scaffold.dart';
import 'register_account_fields.dart';

class RegisterBody extends StatelessWidget {
  const RegisterBody({super.key, required this.state});

  final AuthState state;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final bloc = context.read<AuthBloc>();
    var theme = Theme.of(context).colorScheme;

    return AuthScaffold(
      child: Form(
        key: bloc.forms.registerFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 8.h),
            const Center(child: AuthLogo()),
            SizedBox(height: 24.h),
            AuthHeader(
              title: l.auth_register_title,
              subtitle: l.auth_register_subtitle,
            ),
            SizedBox(height: 28.h),
            RegisterAccountFields(state: state),
            // RegisterPersonalFields(state: state),
            SizedBox(height: 14.h),
            // AcceptTermsTile(
            //   accepted: state.termsAccepted,
            //   showError: state.showTermsError && !state.termsAccepted,
            //   onChanged: bloc.toggleTerms,
            // ),
            SizedBox(height: 18.h),
            AppPrimaryButton(
              label: l.auth_register_button,
              // loading: state.isLoading,
              // onPressed: () => bloc.submitRegister(context),
              onPressed: () {},
            ),
            SizedBox(height: 14.h),
            Center(
              child: Text.rich(
                TextSpan(
                  style: Styles.textStyle12.copyWith(
                    color: theme.onSurface.withValues(alpha: 0.6),
                  ),
                  children: [
                    TextSpan(text: l.auth_have_account),
                    WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: AuthLinkButton(
                        label: l.auth_sign_in,
                        onTap: () {
                          if (context.canPop()) {
                            context.pop();
                          } else {
                            context.go(AppRouter.kLogin);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }
}
