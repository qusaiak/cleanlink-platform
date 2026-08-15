import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../locations/domain/entities/selected_map_location.dart';
import '../../../locations/presentation/bloc/locations_bloc.dart';

enum BookingLocationSheetAction { chooseOnMap, addSaved }

class BookingLocationSheet extends StatelessWidget {
  const BookingLocationSheet({super.key, required this.selectedLocation});

  final SelectedMapLocation? selectedLocation;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 20.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 42.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: colors.outlineVariant,
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            Row(
              children: [
                Expanded(
                  child: Text(
                    l.select_service_location,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                IconButton(
                  tooltip: l.try_again,
                  onPressed: () => context.read<LocationsBloc>().add(
                    const RefreshLocationsEvent(),
                  ),
                  icon: const Icon(Icons.refresh),
                ),
              ],
            ),
            Flexible(
              child: BlocBuilder<LocationsBloc, LocationsState>(
                builder: (context, state) {
                  if (state.isLoading && state.locations.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(28),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  return ListView(
                    shrinkWrap: true,
                    children: [
                      if (state.errorMessage != null)
                        Padding(
                          padding: EdgeInsets.only(bottom: 8.h),
                          child: Text(
                            state.locations.isEmpty
                                ? state.errorMessage!
                                : l.cached_locations_warning,
                            style: TextStyle(color: colors.error),
                          ),
                        ),
                      if (state.locations.isEmpty)
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 18.h),
                          child: Column(
                            children: [
                              Icon(
                                Icons.location_off_outlined,
                                size: 40.r,
                                color: colors.onSurfaceVariant,
                              ),
                              SizedBox(height: 8.h),
                              Text(l.no_saved_locations),
                              SizedBox(height: 4.h),
                              Text(
                                l.no_saved_locations_message,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        )
                      else
                        ...state.locations.map((location) {
                          final selected =
                              selectedLocation?.savedLocationId == location.id;
                          return ListTile(
                            leading: Icon(
                              selected
                                  ? Icons.radio_button_checked
                                  : Icons.radio_button_off,
                              color: selected
                                  ? colors.primary
                                  : colors.onSurfaceVariant,
                            ),
                            title: Text(
                              location.localName.isEmpty
                                  ? l.saved_location
                                  : location.localName == 'home'
                                  ? l.home
                                  : location.localName,
                            ),
                            subtitle: Text(
                              location.address.isEmpty
                                  ? '${location.latitude.toStringAsFixed(6)}, '
                                        '${location.longitude.toStringAsFixed(6)}'
                                  : location.address,
                              textDirection: location.address.isEmpty
                                  ? TextDirection.ltr
                                  : null,
                            ),
                            onTap: () => Navigator.of(
                              context,
                            ).pop(location.toSelectedMapLocation()),
                          );
                        }),
                    ],
                  );
                },
              ),
            ),
            const Divider(),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.map_outlined),
              title: Text(l.choose_another_location),
              onTap: () => Navigator.of(
                context,
              ).pop(BookingLocationSheetAction.chooseOnMap),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.add_location_alt_outlined),
              title: Text(l.add_new_saved_location),
              onTap: () => Navigator.of(
                context,
              ).pop(BookingLocationSheetAction.addSaved),
            ),
          ],
        ),
      ),
    );
  }
}
