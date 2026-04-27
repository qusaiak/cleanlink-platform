import 'package:client_app/config/theme/colors.dart';
import 'package:client_app/config/theme/styles.dart';
import 'package:client_app/core/widgets/custom_toast.dart';
import 'package:client_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:client_app/features/auth/presentation/widgets/auth_widgets.dart';
import 'package:client_app/features/auth/presentation/widgets/row_widget.dart';
import 'package:client_app/features/auth/presentation/widgets/title_auth_widget.dart';
import 'package:client_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/functions/spinkit.dart';
import '../../../../core/widgets/custom_elevated_button.dart';
import 'intro_auth_widget.dart';

class VerificationCodeBody extends StatelessWidget {
  const VerificationCodeBody(
    this.gsm,
    this._pinCodeController,
    this._formKey,
    this._pinCodeFocusNode, {
    super.key,
  });

  final String gsm;

  final TextEditingController _pinCodeController;

  final FocusNode _pinCodeFocusNode;

  final GlobalKey<FormState> _formKey;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state.status == AuthStatus.errorVerifyAccount) {
          showToast(text: state.error!.message, state: ToastState.error);
        }
        if (state.status == AuthStatus.successVerifyAccount) {
          // GoRouter.of(context).push(
          //   "${AppRouter.kRegister}/${AppRouter.kVerificationAccountPage}/$gsm/${AppRouter.kPersonalDetailsPage}/$gsm",
          // );
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
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 40.h),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const IntroAuthWidget(),
                TitleAuthWidget(AppLocalizations.of(context)!.verify_account),
                CustomPinPut(_pinCodeController, _pinCodeFocusNode),
                SizedBox(height: 20.h),
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    return CustomElevatedButton(
                      text: state.isVerifyAccountLoading!
                          ? AppLocalizations.of(context)!.verifying
                          : AppLocalizations.of(context)!.verify_account_action,
                      rightIcon: state.isVerifyAccountLoading!
                          ? Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              child: spinKitApp(Colors.white),
                            )
                          : const SizedBox(),
                      isDisabled: state.isVerifyAccountLoading!,
                      height: 40.h,
                      buttonTextStyle: Styles.textStyle16.copyWith(
                        color: theme.onPrimary,
                        fontWeight: FontWeight.w400,
                      ),
                      margin: EdgeInsets.symmetric(vertical: 10.h),
                      buttonStyle: ElevatedButton.styleFrom(
                        disabledBackgroundColor: AppColor.primaryLight,
                        backgroundColor: theme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        shadowColor: Colors.white,
                      ),
                      onPressed: () {
                        FocusManager.instance.primaryFocus?.unfocus();
                        if (_formKey.currentState!.validate()) {
                          context.read<AuthBloc>().add(
                            VerifyAccount(gsm, _pinCodeController.text),
                          );
                        }
                      },
                    );
                  },
                ),
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    return !state.isRequestResendVerificationCodeLoading!
                        ? RowWidget(
                            text: AppLocalizations.of(
                              context,
                            )!.did_not_receive_code,
                            textButton: AppLocalizations.of(
                              context,
                            )!.resend_code,
                            onTap: () {
                              FocusManager.instance.primaryFocus?.unfocus();
                              context.read<AuthBloc>().add(
                                RequestResendVerificationCode(gsm),
                              );
                            },
                          )
                        : spinKitApp(AppColor.primaryLight);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
