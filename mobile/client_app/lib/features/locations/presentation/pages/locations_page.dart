import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/routes/app_router.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/custom_dialog.dart';
import '../../../../core/widgets/custom_toast.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/client_location_entity.dart';
import '../bloc/locations_bloc.dart';

class LocationsPage extends StatefulWidget {
  const LocationsPage({super.key});

  @override
  State<LocationsPage> createState() => _LocationsPageState();
}

class _LocationsPageState extends State<LocationsPage> {
  @override
  void initState() {
    super.initState();
    final bloc = context.read<LocationsBloc>();
    if (!bloc.state.hasLoaded) bloc.add(const LoadLocationsEvent());
  }

  Future<void> _refresh() {
    final completer = Completer<void>();
    context.read<LocationsBloc>().add(
      RefreshLocationsEvent(completer: completer),
    );
    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return BlocConsumer<LocationsBloc, LocationsState>(
      listenWhen: (previous, current) =>
          previous.errorMessage != current.errorMessage ||
          previous.mutation != current.mutation,
      listener: (context, state) {
        if (state.errorMessage != null && state.locations.isNotEmpty) {
          AppSnackBar.showError(
            context: context,
            title: l.error,
            message: state.errorMessage!,
          );
        }
        final message = switch (state.mutation) {
          LocationMutation.added => l.location_added_successfully,
          LocationMutation.updated => l.location_updated_successfully,
          LocationMutation.deleted => l.location_deleted_successfully,
          null => null,
        };
        if (message != null) {
          AppSnackBar.showSuccess(
            context: context,
            title: l.success,
            message: message,
          );
          context.read<LocationsBloc>().add(
            const ClearLocationsFeedbackEvent(),
          );
        }
      },
      builder: (context, state) => Scaffold(
        appBar: AppBar(title: Text(l.my_locations)),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: state.isMutating
              ? null
              : () => context.push(AppRouter.kAddLocation),
          icon: const Icon(Icons.add_location_alt_outlined),
          label: Text(l.add_location),
        ),
        body: _body(context, state),
      ),
    );
  }

  Widget _body(BuildContext context, LocationsState state) {
    final l = AppLocalizations.of(context)!;
    if (state.isLoading && state.locations.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state.errorMessage != null && state.locations.isEmpty) {
      return Center(
        child: AppEmptyState(
          icon: Icons.location_off_outlined,
          title: l.could_not_load_locations,
          body: state.errorMessage!,
          action: FilledButton.tonal(
            onPressed: () =>
                context.read<LocationsBloc>().add(const LoadLocationsEvent()),
            child: Text(l.try_again),
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _refresh,
      child: state.locations.isEmpty
          ? ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.fromLTRB(24.w, 96.h, 24.w, 120.h),
              children: [
                AppEmptyState(
                  icon: Icons.add_location_alt_outlined,
                  title: l.no_saved_locations,
                  body: l.no_saved_locations_message,
                  action: FilledButton.icon(
                    onPressed: () => context.push(AppRouter.kAddLocation),
                    icon: const Icon(Icons.add_location_alt_outlined),
                    label: Text(l.add_location),
                  ),
                ),
              ],
            )
          : ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 112.h),
              itemCount:
                  state.locations.length + (state.errorMessage == null ? 0 : 1),
              separatorBuilder: (_, _) => SizedBox(height: 12.h),
              itemBuilder: (context, index) {
                if (state.errorMessage != null && index == 0) {
                  return _CachedWarning(message: l.cached_locations_warning);
                }
                final offset = state.errorMessage == null ? 0 : 1;
                final location = state.locations[index - offset];
                return _LocationCard(
                  location: location,
                  isUpdating: state.updatingLocationId == location.id,
                  isDeleting: state.deletingLocationId == location.id,
                  onEdit: () =>
                      context.push(AppRouter.kEditLocation, extra: location),
                  onDelete: () => _confirmDelete(location.id),
                );
              },
            ),
    );
  }

  void _confirmDelete(int id) {
    final l = AppLocalizations.of(context)!;
    showAdaptiveDialog<void>(
      context: context,
      builder: (dialogContext) => CustomDialog(
        title: l.delete_location,
        body: l.delete_location_confirmation,
        cancelButtonText: l.cancel,
        doneButtonText: l.delete_location,
        onCancel: () => Navigator.of(dialogContext).pop(),
        onTap: () {
          Navigator.of(dialogContext).pop();
          context.read<LocationsBloc>().add(DeleteLocationEvent(id));
        },
      ),
    );
  }
}

class _LocationCard extends StatelessWidget {
  const _LocationCard({
    required this.location,
    required this.isUpdating,
    required this.isDeleting,
    required this.onEdit,
    required this.onDelete,
  });

  final ClientLocationEntity location;
  final bool isUpdating;
  final bool isDeleting;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: colors.primaryContainer,
              foregroundColor: colors.onPrimaryContainer,
              child: const Icon(Icons.location_on_outlined),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    location.localName.isEmpty
                        ? AppLocalizations.of(context)!.saved_location
                        : location.localName == 'home'
                        ? AppLocalizations.of(context)!.home
                        : location.localName,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    location.address.isEmpty
                        ? '${location.latitude.toStringAsFixed(6)}, '
                              '${location.longitude.toStringAsFixed(6)}'
                        : location.address,
                    textDirection: location.address.isEmpty
                        ? TextDirection.ltr
                        : null,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            if (isUpdating || isDeleting)
              SizedBox(
                width: 24.r,
                height: 24.r,
                child: const CircularProgressIndicator(strokeWidth: 2),
              )
            else
              PopupMenuButton<String>(
                onSelected: (value) => value == 'edit' ? onEdit() : onDelete(),
                itemBuilder: (_) => [
                  PopupMenuItem(value: 'edit', child: Text(l.edit_location)),
                  PopupMenuItem(
                    value: 'delete',
                    child: Text(
                      l.delete_location,
                      style: TextStyle(color: colors.error),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _CachedWarning extends StatelessWidget {
  const _CachedWarning({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: colors.tertiaryContainer,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Icon(Icons.cloud_off_outlined, color: colors.onTertiaryContainer),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: colors.onTertiaryContainer),
            ),
          ),
        ],
      ),
    );
  }
}
