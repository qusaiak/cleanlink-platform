import 'dart:io';

import 'package:client_app/core/utils/functions/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/functions/validator.dart';
import '../../../../core/widgets/app_primary_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/custom_appbar.dart';
import '../../../../core/widgets/custom_toast.dart';
import '../../../../l10n/app_localizations.dart';
import '../bloc/profile_bloc.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _EditProfileView();
  }
}

class _EditProfileView extends StatefulWidget {
  const _EditProfileView();

  @override
  State<_EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<_EditProfileView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _fullnameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;
  String _image = '';

  @override
  void initState() {
    super.initState();
    _fullnameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _addressController = TextEditingController();
    context.read<ProfileBloc>().add(LoadProfileDataEvent());
  }

  @override
  void dispose() {
    _fullnameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final theme = Theme.of(context).colorScheme;

    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state.status == ProfileStatus.profileLoaded) {
          _setControllers(state);
        } else if (state.status == ProfileStatus.imagePicked) {
          setState(() => _image = state.image);
        } else if (state.status == ProfileStatus.updateSuccess) {
          AppSnackBar.showSuccess(
            context: context,
            title: l.success,
            message: l.profile_updated_successfully,
          );
          context.pop(true);
        } else if (state.status == ProfileStatus.validationError) {
          AppSnackBar.showWarning(
            context: context,
            title: l.warning,
            message: _localizedProfileMessage(state.errorMessage, l),
          );
        } else if (state.status == ProfileStatus.failure &&
            state.errorMessage != null) {
          AppSnackBar.showError(
            context: context,
            title: l.error,
            message: _localizedProfileMessage(state.errorMessage, l),
          );
        }
      },
      builder: (context, state) {
        return GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Scaffold(
            appBar: customAppBar(
              l.edit_profile,
              Icons.arrow_back_ios_new,
              null,
              () => context.pop(),
              theme.onSurface,
            ),
            body: SafeArea(
              child: state.isLoadingProfile
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 32.h),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Center(
                              child: _ProfileImageEditor(
                                image: _image,
                                onTap: () => context.read<ProfileBloc>().add(
                                  PickProfileImageEvent(),
                                ),
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Center(
                              child: Text(
                                l.change_photo,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: theme.onSurface.withValues(
                                    alpha: 0.55,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 28.h),
                            AppTextField(
                              controller: _fullnameController,
                              label: l.auth_full_name,
                              hint: l.auth_full_name_hint,
                              keyboardType: TextInputType.name,
                              textInputAction: TextInputAction.next,
                              validator: (value) =>
                                  AppValidators.name(value, context),
                              prefix: Icon(
                                Icons.person_outline,
                                color: theme.onSurface.withValues(alpha: 0.55),
                                size: 20.r,
                              ),
                            ),
                            SizedBox(height: 16.h),
                            AppTextField(
                              controller: _emailController,
                              label: l.email,
                              hint: l.auth_email_hint,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              validator: (value) =>
                                  AppValidators.email(value, context),
                              prefix: Icon(
                                Icons.email_outlined,
                                color: theme.onSurface.withValues(alpha: 0.55),
                                size: 20.r,
                              ),
                            ),
                            SizedBox(height: 16.h),
                            AppTextField(
                              controller: _phoneController,
                              label: l.auth_phone_label,
                              hint: l.auth_phone_hint,
                              keyboardType: TextInputType.phone,
                              textInputAction: TextInputAction.next,
                              validator: (value) =>
                                  AppValidators.required(value, context),
                              prefix: Icon(
                                Icons.phone_outlined,
                                color: theme.onSurface.withValues(alpha: 0.55),
                                size: 20.r,
                              ),
                            ),
                            SizedBox(height: 16.h),
                            AppTextField(
                              controller: _addressController,
                              label: l.address_label,
                              hint: l.address_hint,
                              keyboardType: TextInputType.streetAddress,
                              textInputAction: TextInputAction.done,
                              validator: (value) =>
                                  AppValidators.required(value, context),
                              prefix: Icon(
                                Icons.location_on_outlined,
                                color: theme.onSurface.withValues(alpha: 0.55),
                                size: 20.r,
                              ),
                              onFieldSubmitted: (_) => _submit(context),
                            ),
                            SizedBox(height: 32.h),
                            AppPrimaryButton(
                              label: l.update_profile,
                              loading: state.isUpdatingProfile,
                              enabled: !state.isUpdatingProfile,
                              onPressed: () => _submit(context),
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }

  void _setControllers(ProfileState state) {
    _fullnameController.text = state.fullname;
    _emailController.text = state.email;
    _phoneController.text = state.phone;
    _addressController.text = state.address;
    setState(() => _image = state.image);
  }

  void _submit(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    context.read<ProfileBloc>().add(
      UpdateProfileEvent(
        fullname: _fullnameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        address: _addressController.text,
      ),
    );
  }

  String _localizedProfileMessage(String? message, AppLocalizations l) {
    return switch (message) {
      'failed_to_pick_image' => l.failed_to_pick_image,
      'failed_to_update_profile' => l.failed_to_update_profile,
      'fill_required_fields' => l.fill_required_fields,
      'validation_email_invalid' => l.validation_email_invalid,
      _ => message ?? l.failed_to_update_profile,
    };
  }
}

class _ProfileImageEditor extends StatelessWidget {
  const _ProfileImageEditor({required this.image, required this.onTap});

  final String image;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: theme.primary,
            ),
            child: CircleAvatar(
              radius: 56.r,
              backgroundColor: theme.onSurface.withValues(alpha: 0.08),
              backgroundImage: _imageProvider(image),
            ),
          ),
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: theme.primary,
              border: Border.all(color: theme.surface, width: 2),
            ),
            child: Icon(Icons.camera_alt, color: theme.onPrimary, size: 18.r),
          ),
        ],
      ),
    );
  }

  ImageProvider? _imageProvider(String image) {
    if (image.isEmpty || image == '/') return resolveImage(null);
    if (image.startsWith('http://') || image.startsWith('https://')) {
      return NetworkImage(image);
    }
    if (File(image).existsSync()) return FileImage(File(image));
    return resolveImage(null);
  }
}
