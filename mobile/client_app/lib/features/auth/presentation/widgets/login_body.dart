// import 'package:client_app/config/routes/app_router.dart';
// import 'package:client_app/config/theme/colors.dart';
// import 'package:client_app/config/theme/styles.dart';
// import 'package:client_app/core/error/error_codes.dart';
// import 'package:client_app/core/utils/functions/spinkit.dart';
// import 'package:client_app/core/utils/functions/validator.dart';
// import 'package:client_app/core/widgets/app_text_field.dart';
// import 'package:client_app/core/widgets/custom_elevated_button.dart';
// import 'package:client_app/core/widgets/custom_toast.dart';
// import 'package:client_app/features/auth/presentation/bloc/auth_bloc.dart';
// import 'package:client_app/features/auth/presentation/widgets/intro_auth_widget.dart';
// import 'package:client_app/features/auth/presentation/widgets/row_widget.dart';
// import 'package:client_app/features/auth/presentation/widgets/title_auth_widget.dart';
// import 'package:client_app/l10n/app_localizations.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:go_router/go_router.dart';

// class LoginBody extends StatelessWidget {
//   LoginBody({super.key});

//   final TextEditingController _gsmController = TextEditingController();
//   final FocusNode _gsmFocusNode = FocusNode();
//   final TextEditingController _passwordController = TextEditingController();
//   final FocusNode _passwordFocusNode = FocusNode();
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

//   @override
//   Widget build(BuildContext context) {
//     var theme = Theme.of(context).colorScheme;
//     var appLocalizations = AppLocalizations.of(context);
//     return BlocListener<AuthBloc, AuthState>(
//       listener: (context, state) async {
//         if (state.status == AuthStatus.errorLogin) {
//           showToast(text: state.error!.message, state: ToastState.error);
//           if (state.error!.errorCode == ErrorCodes.loginNotVerified) {
//             // GoRouter.of(context).push(
//             //   "${AppRouter.kRegisterPage}/${AppRouter.kVerificationAccountPage}/${_gsmController.text}",
//             // );
//           }
//         }
//         if (state.status == AuthStatus.successLogin) {
//           GoRouter.of(context).go(AppRouter.kHome);
//         }
//         if (state.status == AuthStatus.loadingLogin) {
//           FocusManager.instance.primaryFocus?.unfocus();
//         }
//         if (state.status == AuthStatus.noInternet) {
//           showToast(
//             text: appLocalizations!.error_connection,
//             state: ToastState.error,
//           );
//         }
//       },
//       child: SingleChildScrollView(
//         child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 40.h),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const IntroAuthWidget(),
//                 TitleAuthWidget(AppLocalizations.of(context)!.login),
//                 AppTextField(
//                   label: AppLocalizations.of(context)!.mobile_number,
//                   hint: "09xx xxx-xxx",
//                   keyboardType: TextInputType.phone,
//                   controller: _gsmController,
//                   focusNode: _gsmFocusNode,
//                   key: const Key('gsm'),
//                   prefix: Icon(
//                     Icons.phone_outlined,
//                     color: theme.onSurfaceVariant,
//                     size: 26,
//                   ),
//                   onFieldSubmitted: (value) {
//                     FocusScope.of(context).requestFocus(_passwordFocusNode);
//                   },
//                   maxLength: 10,
//                   autovalidateMode: AutovalidateMode.onUserInteraction,
//                   validator: (value) => Validator.validateGsm(value, context),
//                 ),
//                 SizedBox(height: 20.h),
//                 BlocBuilder<AuthBloc, AuthState>(
//                   builder: (context, state) {
//                     return AppTextField(
//                       label: AppLocalizations.of(context)!.password,
//                       key: const Key('login_password'),
//                       focusNode: _passwordFocusNode,
//                       keyboardType: TextInputType.visiblePassword,
//                       controller: _passwordController,
//                       obscureText: !(state.isPasswordVis ?? false),
//                       prefix: Icon(
//                         Icons.lock_outline,
//                         color: theme.onSurfaceVariant,
//                       ),
//                       suffix: IconButton(
//                         onPressed: () {
//                           context.read<AuthBloc>().add(
//                             const ChangePasswordView('login_password'),
//                           );
//                         },
//                         icon: !state.isPasswordVis!
//                             ? Icon(
//                                 Icons.visibility_outlined,
//                                 color: theme.onSurfaceVariant,
//                                 size: 26,
//                               )
//                             : Icon(
//                                 Icons.visibility_off_outlined,
//                                 color: theme.onSurfaceVariant,
//                                 size: 26,
//                               ),
//                       ),
//                       autovalidateMode: AutovalidateMode.onUserInteraction,
//                       validator: (value) =>
//                           Validator.validatePassword(value, context),
//                     );
//                   },
//                 ),
//                 SizedBox(height: 10.h),
//                 Align(
//                   alignment: Alignment.centerRight,
//                   child: TextButton(
//                     onPressed: () {
//                       FocusManager.instance.primaryFocus?.unfocus();
//                       // GoRouter.of(context).push(
//                       //   "${AppRouter.kLogin}/${AppRouter.kForgotPasswordPage}",
//                       // );
//                     },
//                     child: Text(
//                       AppLocalizations.of(context)!.forget_password,
//                       style: Styles.textStyle12.copyWith(
//                         color: theme.primary,
//                         fontWeight: FontWeight.w400,
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 10.h),
//                 BlocBuilder<AuthBloc, AuthState>(
//                   builder: (context, state) {
//                     bool isDisabled = state.isLoadingLogin!;
//                     return CustomElevatedButton(
//                       text: state.isLoadingLogin!
//                           ? AppLocalizations.of(context)!.logging_in
//                           : AppLocalizations.of(context)!.login,
//                       rightIcon: state.isLoadingLogin!
//                           ? Padding(
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 10,
//                               ),
//                               child: spinKitApp(Colors.white),
//                             )
//                           : const SizedBox(),
//                       isDisabled: isDisabled,
//                       height: 40.h,
//                       buttonTextStyle: Styles.textStyle16.copyWith(
//                         color: theme.onPrimary,
//                         fontWeight: FontWeight.w400,
//                       ),
//                       margin: EdgeInsets.symmetric(vertical: 10.h),
//                       buttonStyle: ElevatedButton.styleFrom(
//                         disabledBackgroundColor: AppColor.gray300,
//                         backgroundColor: theme.primary,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(6.r),
//                         ),
//                         shadowColor: Colors.white,
//                       ),
//                       onPressed: () {
//                         FocusManager.instance.primaryFocus?.unfocus();
//                         if (_formKey.currentState!.validate()) {
//                           BlocProvider.of<AuthBloc>(context).add(
//                             Login(
//                               _gsmController.text,
//                               _passwordController.text,
//                             ),
//                           );
//                         }
//                       },
//                     );
//                   },
//                 ),
//                 SizedBox(height: 40.h),
//                 RowWidget(
//                   text: AppLocalizations.of(context)!.do_not_have_an_account,
//                   textButton: AppLocalizations.of(context)!.register,
//                   onTap: () {
//                     FocusManager.instance.primaryFocus?.unfocus();
//                     // GoRouter.of(context).push(AppRouter.kRegister);
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
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
            SizedBox(height: 8.h),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: AuthLinkButton(
                label: l.auth_forgot_password,
                onTap: () => context.push(AppRouter.kForgotPassword),
              ),
            ),
            SizedBox(height: 16.h),
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
