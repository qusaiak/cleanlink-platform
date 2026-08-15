import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../config/theme/styles.dart';
import '../../../../core/widgets/app_primary_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/custom_appbar.dart';
import '../../../../injection_container.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/selected_map_location.dart';
import '../../../../core/utils/map_address_normalizer.dart';
import '../../domain/services/device_location_service.dart';
import '../../domain/services/reverse_geocoding_service.dart';

class MapLocationPickerPage extends StatefulWidget {
  const MapLocationPickerPage({super.key, this.initialLocation});

  final SelectedMapLocation? initialLocation;

  @override
  State<MapLocationPickerPage> createState() => _MapLocationPickerPageState();
}

class _MapLocationPickerPageState extends State<MapLocationPickerPage> {
  static const _worldCamera = CameraPosition(target: LatLng(0, 0), zoom: 2);

  final _addressController = TextEditingController();
  final DeviceLocationService _locationService = sl();
  final ReverseGeocodingService _geocodingService = sl();

  GoogleMapController? _mapController;
  Timer? _geocodingDebounce;
  LatLng? _selectedCoordinates;
  bool _isResolvingAddress = false;
  bool _isResolvingCurrentPosition = false;
  bool _cameraMoved = false;
  bool _programmaticCameraMove = false;

  CameraPosition get _initialCamera {
    final location = widget.initialLocation;
    if (location == null) return _worldCamera;
    return CameraPosition(
      target: LatLng(location.latitude, location.longitude),
      zoom: 16,
    );
  }

  @override
  void initState() {
    super.initState();
    final initial = widget.initialLocation;
    if (initial != null) {
      _selectedCoordinates = LatLng(initial.latitude, initial.longitude);
      _addressController.text = initial.formattedAddress;
    }
    _addressController.addListener(_addressChanged);
  }

  void _addressChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _geocodingDebounce?.cancel();
    _addressController
      ..removeListener(_addressChanged)
      ..dispose();
    _mapController?.dispose();
    super.dispose();
  }

  void _onCameraMove(CameraPosition position) {
    if (_programmaticCameraMove) return;
    _cameraMoved = true;
    _selectedCoordinates = position.target;
  }

  void _onCameraIdle() {
    if (_programmaticCameraMove) {
      _programmaticCameraMove = false;
      return;
    }
    if (!_cameraMoved || _selectedCoordinates == null) return;
    _cameraMoved = false;
    _scheduleReverseGeocoding(_selectedCoordinates!);
  }

  void _scheduleReverseGeocoding(LatLng coordinates) {
    _geocodingDebounce?.cancel();
    _geocodingDebounce = Timer(
      const Duration(milliseconds: 550),
      () => _reverseGeocode(coordinates),
    );
  }

  Future<void> _reverseGeocode(LatLng coordinates) async {
    if (!mounted) return;
    setState(() => _isResolvingAddress = true);
    try {
      final address = await _geocodingService.resolveAddress(
        latitude: coordinates.latitude,
        longitude: coordinates.longitude,
      );
      if (!mounted || _selectedCoordinates != coordinates) return;
      _addressController.text = address ?? '';
    } catch (_) {
      if (mounted && _selectedCoordinates == coordinates) {
        _addressController.clear();
      }
    } finally {
      if (mounted && _selectedCoordinates == coordinates) {
        setState(() => _isResolvingAddress = false);
      }
    }
  }

  Future<void> _useCurrentLocation() async {
    if (_isResolvingCurrentPosition) return;
    setState(() => _isResolvingCurrentPosition = true);
    try {
      final position = await _locationService.getCurrentPosition();
      final coordinates = LatLng(position.latitude, position.longitude);
      _selectedCoordinates = coordinates;
      _programmaticCameraMove = true;
      await _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(coordinates, 17),
      );
      await _reverseGeocode(coordinates);
    } on LocationAccessException catch (error) {
      if (mounted) await _showLocationAccessDialog(error.failure);
    } finally {
      if (mounted) setState(() => _isResolvingCurrentPosition = false);
    }
  }

  Future<void> _showLocationAccessDialog(LocationAccessFailure failure) async {
    final l = AppLocalizations.of(context)!;
    final requiresAppSettings =
        failure == LocationAccessFailure.permissionDeniedForever;
    final requiresLocationSettings =
        failure == LocationAccessFailure.serviceDisabled;
    final message = switch (failure) {
      LocationAccessFailure.permissionDenied =>
        l.location_permission_denied_message,
      LocationAccessFailure.permissionDeniedForever =>
        l.location_permission_denied_forever_message,
      LocationAccessFailure.serviceDisabled =>
        l.location_service_disabled_message,
    };

    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l.service_location),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(l.continue_manually),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              if (requiresAppSettings) {
                await _locationService.openApplicationSettings();
              } else if (requiresLocationSettings) {
                await _locationService.openDeviceLocationSettings();
              } else {
                if (mounted) {
                  setState(() => _isResolvingCurrentPosition = false);
                }
                await _useCurrentLocation();
              }
            },
            child: Text(
              requiresAppSettings
                  ? l.open_settings
                  : requiresLocationSettings
                  ? l.open_location_settings
                  : l.try_again,
            ),
          ),
        ],
      ),
    );
  }

  void _confirm() {
    final coordinates = _selectedCoordinates;
    final address = _addressController.text.trim();
    if (coordinates == null || address.isEmpty || _isResolvingAddress) return;
    context.pop(
      SelectedMapLocation(
        latitude: coordinates.latitude,
        longitude: coordinates.longitude,
        formattedAddress: normalizeGoogleMapAddress(address),
        placeId: widget.initialLocation?.placeId,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;
    final canConfirm =
        _selectedCoordinates != null &&
        _addressController.text.trim().isNotEmpty &&
        !_isResolvingAddress;

    return Scaffold(
      appBar: customAppBar(
        l.select_location,
        null,
        const [],
        () {},
        colors.onSurface,
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: _initialCamera,
            myLocationButtonEnabled: false,
            myLocationEnabled: false,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
            onMapCreated: (controller) => _mapController = controller,
            onCameraMoveStarted: () {
              if (!_programmaticCameraMove) _cameraMoved = true;
            },
            onCameraMove: _onCameraMove,
            onCameraIdle: _onCameraIdle,
          ),
          IgnorePointer(
            child: Center(
              child: Padding(
                padding: EdgeInsets.only(bottom: 42.h),
                child: Icon(
                  Icons.location_pin,
                  size: 46.sp,
                  color: colors.primary,
                  shadows: const [Shadow(color: Colors.black38, blurRadius: 5)],
                ),
              ),
            ),
          ),
          PositionedDirectional(
            top: 16.h,
            start: 16.w,
            end: 16.w,
            child: Material(
              color: colors.surface.withValues(alpha: 0.94),
              borderRadius: BorderRadius.circular(14.r),
              child: Padding(
                padding: EdgeInsets.all(12.r),
                child: Text(
                  l.move_map_to_select_location,
                  textAlign: TextAlign.center,
                  style: Styles.textStyle12.copyWith(color: colors.onSurface),
                ),
              ),
            ),
          ),
          PositionedDirectional(
            end: 16.w,
            bottom: 224.h,
            child: FloatingActionButton.small(
              heroTag: 'current-location',
              tooltip: l.use_current_location,
              onPressed: _isResolvingCurrentPosition
                  ? null
                  : _useCurrentLocation,
              backgroundColor: colors.surface,
              foregroundColor: colors.primary,
              child: _isResolvingCurrentPosition
                  ? SizedBox(
                      width: 20.w,
                      height: 20.w,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: colors.primary,
                      ),
                    )
                  : const Icon(Icons.my_location_rounded),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Material(
              color: colors.surface,
              elevation: 12,
              borderRadius: BorderRadius.vertical(top: Radius.circular(22.r)),
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 18.h, 16.w, 16.h),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppTextField(
                        controller: _addressController,
                        label: l.address_label,
                        hint: _isResolvingAddress
                            ? l.loading_address
                            : l.address_unavailable,
                        readOnly: _isResolvingAddress,
                        suffix: _isResolvingAddress
                            ? SizedBox(
                                width: 18.w,
                                height: 18.w,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: colors.primary,
                                ),
                              )
                            : Icon(
                                Icons.edit_location_alt_outlined,
                                color: colors.primary,
                              ),
                      ),
                      SizedBox(height: 12.h),
                      AppPrimaryButton(
                        label: l.confirm_location,
                        enabled: canConfirm,
                        onPressed: canConfirm ? _confirm : null,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
