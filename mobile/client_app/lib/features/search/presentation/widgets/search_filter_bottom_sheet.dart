import 'package:client_app/core/utils/functions/spinkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/theme/colors.dart';
import '../../../../config/theme/styles.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../regions/presentation/bloc/regions_bloc.dart';
import '../bloc/search_bloc.dart';

class SearchFilterBottomSheet extends StatefulWidget {
  const SearchFilterBottomSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (_) => BlocProvider.value(
        value: context.read<SearchBloc>(),
        child: const SearchFilterBottomSheet(),
      ),
    );
  }

  @override
  State<SearchFilterBottomSheet> createState() =>
      _SearchFilterBottomSheetState();
}

class _SearchFilterBottomSheetState extends State<SearchFilterBottomSheet> {
  late Availability _availability;
  // late SortOrder _sortOrder;
  int? _regionId;
  late RangeValues _priceRange;
  // late double? _distance;
  late double? _minRate;

  @override
  void initState() {
    super.initState();

    final state = context.read<SearchBloc>().state;

    _availability = state.availability;

    _priceRange = state.priceRange;

    _minRate = state.minRate;

    _regionId = state.regionId;

    context.read<RegionsBloc>().add(GetRegionNamesEvent());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context).colorScheme;

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.85,
      expand: false,
      builder: (context, scrollController) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: ListView(
            controller: scrollController,
            children: [
              SizedBox(height: 12.h),
              Center(
                child: Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: theme.onSurfaceVariant,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                l10n.search_filter,
                style: Styles.textStyle18.copyWith(color: theme.onSurface),
              ),
              SizedBox(height: 20.h),

              _buildSectionTitle(l10n.search_availability, theme),
              SizedBox(height: 8.h),
              _buildAvailabilityToggle(l10n, theme),
              SizedBox(height: 20.h),

              // _buildSectionTitle(l10n.search_order, theme),
              // SizedBox(height: 8.h),
              // _buildOrderToggle(l10n, theme),
              // SizedBox(height: 20.h),
              _buildSectionTitle(l10n.regions_title, theme),

              SizedBox(height: 8.h),

              _buildRegionsSelector(theme),

              SizedBox(height: 20.h),

              _buildSectionTitle(l10n.search_price_range, theme),
              SizedBox(height: 8.h),
              _buildPriceRangeSlider(theme),
              SizedBox(height: 20.h),

              // _buildSectionTitle(l10n.search_distance, theme),
              // SizedBox(height: 8.h),
              // _buildDistanceSlider(theme),
              // SizedBox(height: 20.h),
              _buildSectionTitle(l10n.search_rate, theme),
              SizedBox(height: 8.h),
              _buildRateSlider(theme),
              SizedBox(height: 20.h),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _resetFilters,
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: theme.primary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                      ),
                      child: Text(
                        l10n.search_reset,
                        style: Styles.textStyle14.copyWith(
                          color: theme.primary,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _applyFilters,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                      ),
                      child: Text(
                        l10n.search_apply,
                        style: Styles.textStyle14.copyWith(
                          color: theme.onPrimary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.h),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title, ColorScheme theme) {
    return Text(
      title,
      style: Styles.textStyle14.copyWith(
        color: theme.onSurface,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildAvailabilityToggle(AppLocalizations l10n, ColorScheme theme) {
    return Row(
      children: [
        _buildAvailabilityChip(
          label: l10n.search_today,
          isSelected: _availability == Availability.today,
          onTap: () => setState(() => _availability = Availability.today),
          theme: theme,
        ),
        SizedBox(width: 8.w),
        _buildAvailabilityChip(
          label: l10n.search_tomorrow,
          isSelected: _availability == Availability.tomorrow,
          onTap: () => setState(() => _availability = Availability.tomorrow),
          theme: theme,
        ),
        SizedBox(width: 8.w),
        _buildAvailabilityChip(
          label: l10n.search_week,
          isSelected: _availability == Availability.week,
          onTap: () => setState(() => _availability = Availability.week),
          theme: theme,
        ),
      ],
    );
  }

  Widget _buildAvailabilityChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    required ColorScheme theme,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColor.primaryColor
              : Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Text(
          label,
          style: Styles.textStyle12.copyWith(
            color: isSelected ? theme.onPrimary : theme.onSurfaceVariant,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // Widget _buildOrderToggle(AppLocalizations l10n, ColorScheme theme) {
  //   return Row(
  //     children: [
  //       _buildOrderChip(
  //         label: l10n.search_ascending,
  //         isSelected: _sortOrder == SortOrder.asc,
  //         onTap: () => setState(() => _sortOrder = SortOrder.asc),
  //         theme: theme,
  //       ),
  //       SizedBox(width: 8.w),
  //       _buildOrderChip(
  //         label: l10n.search_descending,
  //         isSelected: _sortOrder == SortOrder.desc,
  //         onTap: () => setState(() => _sortOrder = SortOrder.desc),
  //         theme: theme,
  //       ),
  //     ],
  //   );
  // }

  // Widget _buildOrderChip({
  //   required String label,
  //   required bool isSelected,
  //   required VoidCallback onTap,
  //   required ColorScheme theme,
  // }) {
  //   return GestureDetector(
  //     onTap: onTap,
  //     child: Container(
  //       padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
  //       decoration: BoxDecoration(
  //         color: isSelected ? AppColor.primaryColor : AppColor.surfaceDark,
  //         borderRadius: BorderRadius.circular(20.r),
  //       ),
  //       child: Text(
  //         label,
  //         style: Styles.textStyle12.copyWith(
  //           color: isSelected ? theme.onPrimary : theme.onSurfaceVariant,
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _buildRegionsSelector(ColorScheme theme) {
    return BlocBuilder<RegionsBloc, RegionsState>(
      builder: (context, state) {
        if (state is RegionNamesLoading) {
          return Center(child: spinKitApp(theme.primary));
        }

        if (state is RegionNamesLoaded) {
          return Wrap(
            spacing: 8.w,

            runSpacing: 8.h,

            children: state.regions.map((region) {
              final selected = _regionId == region.id;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (selected) {
                      _regionId = null;
                    } else {
                      _regionId = region.id;
                    }
                  });
                },

                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),

                  padding: EdgeInsets.symmetric(
                    horizontal: 18.w,

                    vertical: 10.h,
                  ),

                  decoration: BoxDecoration(
                    color: selected
                        ? theme.primary
                        : Colors.grey.withOpacity(0.1),

                    borderRadius: BorderRadius.circular(20.r),
                  ),

                  child: Text(
                    region.name,

                    style: Styles.textStyle12.copyWith(
                      color: selected
                          ? theme.onPrimary
                          : theme.onSurfaceVariant,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        }

        return const SizedBox();
      },
    );
  }

  Widget _buildPriceRangeSlider(ColorScheme theme) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: [
            Text(
              '${_priceRange.start.round()} ${AppLocalizations.of(context)!.sp}',
            ),

            Text(
              '${_priceRange.end.round()} ${AppLocalizations.of(context)!.sp}',
            ),
          ],
        ),

        RangeSlider(
          values: _priceRange,

          min: 10,

          max: 10000,

          divisions: 100,

          activeColor: theme.primary,

          onChanged: (values) {
            setState(() {
              _priceRange = values;
              print("values");
              print(values);
            });
          },
        ),
      ],
    );
  }

  Widget _buildRateSlider(ColorScheme theme) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '0',
              style: Styles.textStyle12.copyWith(color: theme.onSurfaceVariant),
            ),
            Text(
              (_minRate ?? 0).toStringAsFixed(1),
              style: Styles.textStyle14.copyWith(
                color: theme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '5',
              style: Styles.textStyle12.copyWith(color: theme.onSurfaceVariant),
            ),
          ],
        ),
        Slider(
          value: _minRate ?? 0,
          min: 0,
          max: 5,
          divisions: 10,
          activeColor: theme.primary,
          inactiveColor: theme.secondaryContainer,
          onChanged: (value) {
            setState(() {
              _minRate = value == 0 ? null : value;
            });
          },
        ),
      ],
    );
  }

  void _resetFilters() {
    final bloc = context.read<SearchBloc>();
    bloc.add(ResetFilters());
    setState(() {
      _availability = Availability.today;
      // _sortOrder = SortOrder.desc;
      _regionId = 0;
      _priceRange = const RangeValues(10, 1000);
      // _distance = 1;
      _minRate = 0;
    });
  }

  void _applyFilters() {
    final bloc = context.read<SearchBloc>();

    bloc.add(
      ApplyFiltersAndSearch(
        regionId: _regionId,
        priceRange: _priceRange,
        rate: _minRate,
      ),
    );

    Navigator.pop(context);
  }
}
