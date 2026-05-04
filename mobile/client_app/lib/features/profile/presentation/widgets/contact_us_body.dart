
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/theme/styles.dart';
import '../../../../core/utils/functions/validator.dart';
import '../../../../core/widgets/app_primary_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../l10n/app_localizations.dart';

class ContactUsBody extends StatefulWidget {
  const ContactUsBody({super.key});

  @override
  State<ContactUsBody> createState() => _ContactUsBodyState();
}

class _ContactUsBodyState extends State<ContactUsBody> {
  final _formKey = GlobalKey<FormState>();

  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  final _phoneFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _titleFocus = FocusNode();
  final _descFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Icon(Icons.support_agent_outlined, color: theme.primary, size: 100),
            SizedBox(height: 15.h),
            Text(
              AppLocalizations.of(context)!.contact_us_title,
              style: Styles.textStyle16.copyWith(fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 5.h),
            Text(
              AppLocalizations.of(context)!.contact_us_body,
              style: Styles.textStyle12.copyWith(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.h),
            AppTextField(
              controller: _phoneController,
              focusNode: _phoneFocus,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) =>
                  FocusScope.of(context).requestFocus(_emailFocus),
              label: AppLocalizations.of(context)!.mobile_number,
              hint: AppLocalizations.of(context)!.auth_phone_hint,
              prefix: const Icon(Icons.phone_outlined),
              keyboardType: TextInputType.phone,
              validator: (v) => AppValidators.empty(v!, context),
            ),
            SizedBox(height: 14.h),
            AppTextField(
              controller: _emailController,
              focusNode: _emailFocus,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) =>
                  FocusScope.of(context).requestFocus(_titleFocus),
              label:
                  "${AppLocalizations.of(context)!.email} (${AppLocalizations.of(context)!.optional})",
              hint: AppLocalizations.of(context)!.hint_email,
              prefix: const Icon(Icons.email_outlined),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 14.h),
            AppTextField(
              controller: _titleController,
              focusNode: _titleFocus,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) =>
                  FocusScope.of(context).requestFocus(_descFocus),
              label: AppLocalizations.of(context)!.title,
              hint: AppLocalizations.of(context)!.hint_title,
              prefix: const Icon(Icons.title),
              validator: (v) => AppValidators.empty(v!, context),
            ),
            SizedBox(height: 14.h),
            AppTextField(
              controller: _descriptionController,
              focusNode: _descFocus,
              textInputAction: TextInputAction.done,
              label: AppLocalizations.of(context)!.description,
              hint: AppLocalizations.of(context)!.hint_description,
              prefix: const Icon(Icons.description_outlined),
              maxLength: 300,
              validator: (v) => AppValidators.empty(v!, context),
            ),
            SizedBox(height: 28.h),
            AppPrimaryButton(
              label: AppLocalizations.of(context)!.send,
              // loading: state.isLoading,
              onPressed: () {},
            ),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }
}
