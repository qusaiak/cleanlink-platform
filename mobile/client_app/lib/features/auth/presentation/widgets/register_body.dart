import 'package:client_app/config/theme/colors.dart';
import 'package:client_app/config/theme/styles.dart';
import 'package:client_app/core/utils/functions/validator.dart';
import 'package:client_app/core/widgets/app_text_field.dart';
import 'package:client_app/core/widgets/custom_toast.dart';
import 'package:client_app/features/auth/presentation/widgets/row_widget.dart';
import 'package:client_app/features/auth/presentation/widgets/title_auth_widget.dart';
import 'package:client_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/error/error_codes.dart';
import '../../../../core/utils/functions/spinkit.dart';
import '../../../../core/widgets/custom_elevated_button.dart';
import '../bloc/auth_bloc.dart';
import 'intro_auth_widget.dart';

class RegisterBody extends StatelessWidget {
  RegisterBody({super.key});

  final TextEditingController _gsmController = TextEditingController();
  final FocusNode _gsmFocusNode = FocusNode();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _passwordFocusNode = FocusNode();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final FocusNode _confirmPasswordFocusNode = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state.status == AuthStatus.errorRegister) {
          showToast(text: state.error!.message, state: ToastState.error);
          if (state.error!.errorCode == ErrorCodes.registerNotVerified) {
            // GoRouter.of(context).push(
            //   "${AppRouter.kRegister}/${AppRouter.kVerificationAccount}/${_gsmController.text}",
            // );
          }
        }
        if (state.status == AuthStatus.successRegister) {
          // GoRouter.of(context).push(
          //   "${AppRouter.kRegister}/${AppRouter.kVerificationAccount}/${_gsmController.text}",
          // );
        }
        if (state.status == AuthStatus.loadingRegister) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
        if (state.status == AuthStatus.noInternet) {
          showToast(
            text: AppLocalizations.of(context)!.error_connection,
            state: ToastState.error,
          );
        }
      },
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          // child: Form(
          //   key: _formKey,
          //   child: Column(
          //     mainAxisAlignment: MainAxisAlignment.start,
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       const IntroAuthWidget(),
          //       TitleAuthWidget(AppLocalizations.of(context)!.create_account),
          //       AppTextField(
          //         label: AppLocalizations.of(context)!.mobile_number,
          //         hint: "09xx xxx-xxx",
          //         key: const Key('gsm_field'),
          //         autovalidateMode: AutovalidateMode.onUserInteraction,
          //         keyboardType: TextInputType.phone,
          //         controller: _gsmController,
          //         focusNode: _gsmFocusNode,
          //         prefix: Icon(
          //           Icons.phone_outlined,
          //           color: theme.onSurfaceVariant,
          //           size: 26,
          //         ),
          //         onFieldSubmitted: (value) {
          //           FocusScope.of(context).requestFocus(_passwordFocusNode);
          //         },
          //         maxLength: 10,
          //         validator: (value) => Validator.validateGsm(value, context),
          //       ),
          //       SizedBox(height: 20.h),
          //       BlocBuilder<AuthBloc, AuthState>(
          //         builder: (context, state) {
          //           return AppTextField(
          //             label: AppLocalizations.of(context)!.password,
          //             key: const Key('new_password_field'),
          //             focusNode: _passwordFocusNode,
          //             keyboardType: TextInputType.visiblePassword,
          //             controller: _passwordController,
          //             obscureText: !state.isNewPasswordVis!,
          //             autovalidateMode: AutovalidateMode.onUserInteraction,
          //             onFieldSubmitted: (value) {
          //               FocusScope.of(
          //                 context,
          //               ).requestFocus(_confirmPasswordFocusNode);
          //             },
          //             prefix: Icon(
          //               Icons.lock_outline,
          //               color: theme.onSurfaceVariant,
          //             ),
          //             suffix: IconButton(
          //               onPressed: () {
          //                 context.read<AuthBloc>().add(
          //                   const ChangePasswordView('new_password_field'),
          //                 );
          //               },
          //               icon: !state.isNewPasswordVis!
          //                   ? Icon(
          //                       Icons.visibility_outlined,
          //                       color: theme.onSurfaceVariant,
          //                       size: 26,
          //                     )
          //                   : Icon(
          //                       Icons.visibility_off_outlined,
          //                       color: theme.onSurfaceVariant,
          //                       size: 26,
          //                     ),
          //             ),
          //             validator: (value) =>
          //                 Validator.validatePassword(value, context),
          //           );
          //         },
          //       ),
          //       SizedBox(height: 20.h),
          //       BlocBuilder<AuthBloc, AuthState>(
          //         builder: (context, state) {
          //           return AppTextField(
          //             label: AppLocalizations.of(
          //               context,
          //             )!.confirm_password,
          //             key: const Key('confirm_password_field'),
          //             focusNode: _confirmPasswordFocusNode,
          //             keyboardType: TextInputType.visiblePassword,
          //             controller: _confirmPasswordController,
          //             obscureText: !state.isConfirmPasswordVis!,
          //             autovalidateMode: AutovalidateMode.onUserInteraction,
          //             prefix: Icon(
          //               Icons.lock_outline,
          //               color: theme.onSurfaceVariant,
          //             ),
          //             suffix: IconButton(
          //               onPressed: () {
          //                 context.read<AuthBloc>().add(
          //                   const ChangePasswordView('confirm_password_field'),
          //                 );
          //               },
          //               icon: !state.isConfirmPasswordVis!
          //                   ? Icon(
          //                       Icons.visibility_outlined,
          //                       color: theme.onSurfaceVariant,
          //                       size: 26,
          //                     )
          //                   : Icon(
          //                       Icons.visibility_off_outlined,
          //                       color: theme.onSurfaceVariant,
          //                       size: 26,
          //                     ),
          //             ),
          //             validator: (value) => Validator.validateConfirmPassword(
          //               value,
          //               _passwordController.text,
          //               context,
          //             ),
          //           );
          //         },
          //       ),
          //       SizedBox(height: 35.h),
          //       BlocBuilder<AuthBloc, AuthState>(
          //         builder: (context, state) {
          //           bool isDisabled = state.isLoadingRegister!;
          //           return CustomElevatedButton(
          //             text: state.isLoadingRegister!
          //                 ? AppLocalizations.of(context)!.creating_account
          //                 : AppLocalizations.of(context)!.register,
          //             rightIcon: state.isLoadingRegister!
          //                 ? Padding(
          //                     padding: const EdgeInsets.symmetric(
          //                       horizontal: 10,
          //                     ),
          //                     child: spinKitApp(Colors.white),
          //                   )
          //                 : const SizedBox(),
          //             isDisabled: isDisabled,
          //             height: 40.h,
          //             buttonTextStyle: Styles.textStyle16.copyWith(
          //               color: theme.onPrimary,
          //               fontWeight: FontWeight.w400,
          //             ),
          //             margin: EdgeInsets.symmetric(vertical: 10.h),
          //             buttonStyle: ElevatedButton.styleFrom(
          //               disabledBackgroundColor: AppColor.gray300,
          //               backgroundColor: theme.primary,
          //               shape: RoundedRectangleBorder(
          //                 borderRadius: BorderRadius.circular(6.r),
          //               ),
          //               shadowColor: Colors.white,
          //             ),
          //             onPressed: () {
          //               FocusManager.instance.primaryFocus?.unfocus();
          //               if (_formKey.currentState!.validate()) {
          //                 context.read<AuthBloc>().add(
          //                   Register(
          //                     _gsmController.text,
          //                     _gsmController.text,
          //                     _gsmController.text,
          //                     _passwordController.text,
          //                   ),
          //                 );
          //               }
          //             },
          //           );
          //         },
          //       ),
          //       RowWidget(
          //         text: AppLocalizations.of(context)!.already_a_user,
          //         textButton: AppLocalizations.of(context)!.login,
          //         onTap: () {
          //           FocusManager.instance.primaryFocus?.unfocus();
          //           GoRouter.of(context).pop();
          //         },
          //       ),
          //     ],
          //   ),
          // ),
        ),
      ),
    );
  }
}
