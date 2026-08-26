import 'package:client_app/features/services/domain/entities/package_entity.dart';
import 'package:client_app/features/services/domain/entities/attribute_entity.dart';
import 'package:client_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../config/theme/styles.dart';
import '../../../../core/widgets/row_title.dart';
import '../bloc/services_bloc.dart';

class ServicePackagesSection extends StatefulWidget {
  final List<PackageEntity> packages;
  const ServicePackagesSection({super.key, required this.packages});

  @override
  State<ServicePackagesSection> createState() => _ServicePackagesSectionState();
}

class _ServicePackagesSectionState extends State<ServicePackagesSection> {
  @override
  Widget build(BuildContext context) {
    if (widget.packages.isEmpty) return const SizedBox.shrink();
    final theme = Theme.of(context).colorScheme;

    return BlocBuilder<ServicesBloc, ServicesState>(
      builder: (context, state) {
        if (state is! ServiceDetailsLoaded) {
          return const SizedBox();
        }
        final selectedPackage = state.selectedPackage ?? widget.packages.first;

        final selectedIndex = widget.packages.indexWhere(
          (e) => e.id == selectedPackage.id,
        );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RowTitle(
              iconData: Icons.home_work_outlined,
              title: AppLocalizations.of(context)!.choose_package,
              padding: EdgeInsets.all(0),
            ),
            SizedBox(height: 16.h),
            Wrap(
              spacing: 5.w,
              runSpacing: 10.h,
              children: List.generate(widget.packages.length, (index) {
                final package = widget.packages[index];

                final isSelected = selectedIndex == index;

                return GestureDetector(
                  onTap: () {
                    context.read<ServicesBloc>().add(
                      SelectPackageEvent(package),
                    );
                  },

                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 12.h,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? theme.primary
                          : theme.surfaceContainer,
                      borderRadius: BorderRadius.circular(15.r),
                      border: Border.all(
                        color: isSelected
                            ? theme.primary
                            : theme.outline.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Text(
                      package.name,
                      maxLines: 2,
                      style: Styles.textStyle12.copyWith(
                        color: isSelected ? theme.onPrimary : theme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              }),
            ),
            SizedBox(height: 24.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: theme.surfaceContainer,
                borderRadius: BorderRadius.circular(24.r),
                border: Border.all(color: theme.outline.withValues(alpha: 0.1)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          selectedPackage.name,
                          maxLines: 2,
                          style: Styles.textStyle14.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: theme.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Text(
                          "${selectedPackage.price} ${AppLocalizations.of(context)!.sp}",
                          style: Styles.textStyle12.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 14.sp,
                        color: theme.onSurface.withValues(alpha: 0.7),
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        "${selectedPackage.duration.toString()} ${AppLocalizations.of(context)!.track_minutes_short}",
                        style: Styles.textStyle12.copyWith(
                          color: theme.onSurface.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Divider(
                    height: 1,
                    color: theme.outline.withValues(alpha: 0.2),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    selectedPackage.isOpenPackage
                        ? AppLocalizations.of(context)!.customize_your_service
                        : "${AppLocalizations.of(context)!.what_is_included}:",
                    style: Styles.textStyle12.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  if (selectedPackage.isOpenPackage)
                    _ServiceOpenPackageCustomizer(
                      attributes: state.service.attributes ?? const [],
                      quantities: state.openPackageAttributeQuantities,
                    )
                  else
                    for (final feature in selectedPackage.details)
                      Padding(
                        padding: EdgeInsets.only(bottom: 8.h),
                        child: Row(
                          children: [
                            Icon(
                              Icons.check_circle_outline,
                              size: 16.sp,
                              color: theme.primary,
                            ),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: Text(
                                feature,
                                maxLines: 5,
                                style: Styles.textStyle12,
                              ),
                            ),
                          ],
                        ),
                      ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ServiceOpenPackageCustomizer extends StatelessWidget {
  const _ServiceOpenPackageCustomizer({
    required this.attributes,
    required this.quantities,
  });

  final List<AttributeEntity> attributes;
  final Map<int, int> quantities;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    if (attributes.isEmpty) return Text(l.no_attributes_available);

    return Column(
      children: [
        for (final attribute in attributes)
          Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: attribute.isBoolean
                ? CheckboxListTile(
                    key: ValueKey('service-open-boolean-${attribute.id}'),
                    value: (quantities[attribute.id] ?? 0) > 0,
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                    controlAffinity: ListTileControlAffinity.trailing,
                    title: Text(attribute.name, style: Styles.textStyle12),
                    subtitle: _AttributePriceDuration(
                      price: attribute.price,
                      duration: attribute.duration,
                    ),
                    onChanged: (value) => context.read<ServicesBloc>().add(
                      UpdateServiceOpenPackageAttributeQty(
                        attributeId: attribute.id,
                        qty: value == true ? 1 : 0,
                      ),
                    ),
                  )
                : Row(
                    key: ValueKey('service-open-number-${attribute.id}'),
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(attribute.name, style: Styles.textStyle12),
                            _AttributePriceDuration(
                              price: attribute.price,
                              duration: attribute.duration,
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        tooltip: l.decrease,
                        onPressed: (quantities[attribute.id] ?? 0) <= 0
                            ? null
                            : () => context.read<ServicesBloc>().add(
                                UpdateServiceOpenPackageAttributeQty(
                                  attributeId: attribute.id,
                                  qty: (quantities[attribute.id] ?? 0) - 1,
                                ),
                              ),
                        icon: const Icon(Icons.remove_circle_outline),
                      ),
                      SizedBox(
                        width: 28.w,
                        child: Text(
                          '${quantities[attribute.id] ?? 0}',
                          textAlign: TextAlign.center,
                        ),
                      ),
                      IconButton(
                        tooltip: l.increase,
                        onPressed: () => context.read<ServicesBloc>().add(
                          UpdateServiceOpenPackageAttributeQty(
                            attributeId: attribute.id,
                            qty: (quantities[attribute.id] ?? 0) + 1,
                          ),
                        ),
                        icon: const Icon(Icons.add_circle_outline),
                      ),
                    ],
                  ),
          ),
      ],
    );
  }
}

class _AttributePriceDuration extends StatelessWidget {
  const _AttributePriceDuration({required this.price, required this.duration});

  final num price;
  final int duration;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Text(
      '$price ${l.sp} · $duration ${l.track_minutes_short}',
      style: Styles.textStyle11.copyWith(
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }
}
