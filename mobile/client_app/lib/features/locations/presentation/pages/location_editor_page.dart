import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/routes/app_router.dart';
import '../../../../core/widgets/app_primary_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/client_location_entity.dart';
import '../../domain/entities/selected_map_location.dart';
import '../bloc/locations_bloc.dart';

class LocationEditorPage extends StatefulWidget {
  const LocationEditorPage({super.key, this.location});
  final ClientLocationEntity? location;

  @override
  State<LocationEditorPage> createState() => _LocationEditorPageState();
}

class _LocationEditorPageState extends State<LocationEditorPage> {
  late final TextEditingController _nameController;
  SelectedMapLocation? _selection;
  bool _submitted = false;

  bool get _isEditing => widget.location != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.location?.localName ?? '',
    );
    _selection = widget.location?.toSelectedMapLocation();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _chooseOnMap() async {
    final selected = await context.push<SelectedMapLocation>(
      AppRouter.kMapLocationPicker,
      extra: _selection,
    );
    if (!mounted || selected == null) return;
    setState(() => _selection = selected);
  }

  void _submit() {
    final selection = _selection;
    if (selection == null) {
      _chooseOnMap();
      return;
    }
    setState(() => _submitted = true);
    final bloc = context.read<LocationsBloc>();
    final name = _nameController.text.trim();
    if (_isEditing) {
      bloc.add(
        UpdateLocationEvent(
          id: widget.location!.id,
          location: selection,
          name: name.isEmpty ? null : name,
        ),
      );
    } else {
      bloc.add(
        AddLocationEvent(location: selection, name: name.isEmpty ? null : name),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;
    return BlocListener<LocationsBloc, LocationsState>(
      listenWhen: (previous, current) =>
          _submitted &&
          (previous.mutation != current.mutation ||
              previous.errorMessage != current.errorMessage),
      listener: (context, state) {
        final expected = _isEditing
            ? LocationMutation.updated
            : LocationMutation.added;
        if (state.mutation == expected) context.pop(state.mutatedLocation);
        if (state.errorMessage != null) setState(() => _submitted = false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(_isEditing ? l.edit_location : l.add_location),
        ),
        body: SafeArea(
          child: ListView(
            padding: EdgeInsets.all(20.r),
            children: [
              AppTextField(
                controller: _nameController,
                label: l.location_name,
                hint: l.location_name_hint,
                textInputAction: TextInputAction.done,
              ),
              SizedBox(height: 18.h),
              InkWell(
                onTap: _chooseOnMap,
                borderRadius: BorderRadius.circular(16.r),
                child: Ink(
                  padding: EdgeInsets.all(16.r),
                  decoration: BoxDecoration(
                    color: colors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(
                      color: _selection == null
                          ? colors.outlineVariant
                          : colors.primary,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.map_outlined, color: colors.primary),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _selection == null
                                  ? l.choose_location_on_map
                                  : l.selected_location,
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            if (_selection != null) ...[
                              SizedBox(height: 4.h),
                              Text(
                                '${_selection!.latitude.toStringAsFixed(6)}, '
                                '${_selection!.longitude.toStringAsFixed(6)}',
                                textDirection: TextDirection.ltr,
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
              // SizedBox(height: 12.h),
              // Text(
              //   l.map_address_not_saved,
              //   style: Theme.of(
              //     context,
              //   ).textTheme.bodySmall?.copyWith(color: colors.onSurfaceVariant),
              // ),
              SizedBox(height: 32.h),
              BlocBuilder<LocationsBloc, LocationsState>(
                builder: (context, state) {
                  final loading = _isEditing
                      ? state.updatingLocationId == widget.location!.id
                      : state.isAdding;
                  return AppPrimaryButton(
                    label: _isEditing ? l.update_location : l.save_location,
                    loading: loading,
                    enabled: !loading,
                    onPressed: _submit,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
