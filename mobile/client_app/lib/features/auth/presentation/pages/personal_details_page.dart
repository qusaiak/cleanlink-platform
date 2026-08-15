import 'package:client_app/config/routes/app_router.dart';
import 'package:client_app/core/widgets/app_primary_button.dart';
import 'package:client_app/core/widgets/custom_toast.dart';
import 'package:client_app/features/auth/presentation/bloc/personal_details_bloc.dart';
import 'package:client_app/features/auth/presentation/widgets/profile_image_picker.dart';
import 'package:client_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../injection_container.dart';
import '../../../locations/domain/entities/selected_map_location.dart';
import '../widgets/auth_phone_field.dart';
import '../widgets/auth_scaffold.dart';

class PersonalDetailsPage extends StatelessWidget {
  const PersonalDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PersonalDetailsBloc>(
      create: (_) => sl<PersonalDetailsBloc>(),
      child: BlocConsumer<PersonalDetailsBloc, PersonalDetailsState>(
        listener: (context, state) {
          if (state.status == PersonalDetailsStatus.success) {
            context.go(AppRouter.kHome);
          } else if (state.status == PersonalDetailsStatus.failure &&
              state.error != null) {
            AppSnackBar.showError(
              context: context,
              title: AppLocalizations.of(context)!.error,
              message: state.error!.message == 'select_service_location'
                  ? AppLocalizations.of(context)!.please_select_service_location
                  : state.error!.message,
            );
          } else if (state.status == PersonalDetailsStatus.validationError) {
            AppSnackBar.showWarning(
              context: context,
              title: AppLocalizations.of(context)!.warning,
              message: state.error?.message == 'select_service_location'
                  ? AppLocalizations.of(context)!.please_select_service_location
                  : state.error?.message ?? '',
            );
          }
        },
        builder: (context, state) => _PersonalDetailsBody(state: state),
      ),
    );
  }
}

class _PersonalDetailsBody extends StatefulWidget {
  const _PersonalDetailsBody({required this.state});

  final PersonalDetailsState state;

  @override
  State<_PersonalDetailsBody> createState() => _PersonalDetailsBodyState();
}

class _PersonalDetailsBodyState extends State<_PersonalDetailsBody> {
  late final TextEditingController _phoneController;
  final _phoneFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _phoneController = TextEditingController(text: widget.state.phone);
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _phoneFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final bloc = context.read<PersonalDetailsBloc>();
    final theme = Theme.of(context).colorScheme;

    return AuthScaffold(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l.personal_details,
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: theme.onSurface,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              l.personal_details_subtitle,
              style: TextStyle(
                fontSize: 14.sp,
                color: theme.onSurface.withValues(alpha: 0.6),
              ),
            ),
            SizedBox(height: 32.h),
            Center(
              child: ProfileImagePicker(
                imagePath: widget.state.imagePath,
                onTap: () => bloc.add(const PersonalDetailsImagePicked()),
              ),
            ),
            SizedBox(height: 8.h),
            Center(
              child: Text(
                l.optional,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: theme.onSurface.withValues(alpha: 0.5),
                ),
              ),
            ),
            SizedBox(height: 32.h),
            InkWell(
              onTap: () => _selectLocation(bloc),
              borderRadius: BorderRadius.circular(14.r),
              child: Ink(
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(
                    color: widget.state.location == null
                        ? theme.outlineVariant
                        : theme.primary,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.map_outlined, color: theme.primary),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.state.location == null
                                ? l.choose_location_on_map
                                : l.home,
                          ),
                          if (widget.state.location != null) ...[
                            SizedBox(height: 4.h),
                            Text(
                              widget.state.location!.formattedAddress,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16.h),
            AuthPhoneField(
              controller: _phoneController,
              focusNode: _phoneFocus,
              label: l.auth_phone_label,
              hint: l.auth_phone_hint,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _submit(bloc),
            ),
            SizedBox(height: 40.h),
            AppPrimaryButton(
              label: l.complete_profile,
              loading: widget.state.status == PersonalDetailsStatus.loading,
              onPressed: () => _submit(bloc),
            ),
          ],
        ),
      ),
    );
  }

  void _submit(PersonalDetailsBloc bloc) {
    if (widget.state.status == PersonalDetailsStatus.loading) return;
    FocusScope.of(context).unfocus();
    bloc.add(PersonalDetailsPhoneChanged(stripPhone(_phoneController.text)));
    bloc.add(const PersonalDetailsSubmitted());
  }

  Future<void> _selectLocation(PersonalDetailsBloc bloc) async {
    final location = await context.push<SelectedMapLocation>(
      AppRouter.kMapLocationPicker,
      extra: widget.state.location,
    );
    if (!mounted || location == null) return;
    bloc.add(PersonalDetailsLocationChanged(location));
    _phoneFocus.requestFocus();
  }
}
