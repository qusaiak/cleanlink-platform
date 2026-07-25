import 'package:client_app/core/utils/functions/spinkit.dart';
import 'package:client_app/core/utils/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../config/routes/app_router.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../companies/domain/entities/manager_entity.dart';
import '../../domain/entities/region_entity.dart';
import '../bloc/regions_bloc.dart';
import 'region_card.dart';

class RegionsBody extends StatefulWidget {
  const RegionsBody({super.key});

  @override
  State<RegionsBody> createState() => _RegionsBodyState();
}

class _RegionsBodyState extends State<RegionsBody> {
  @override
  void initState() {
    super.initState();
    context.read<RegionsBloc>().add(const GetRegionsEvent());
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _load() => context.read<RegionsBloc>().add(const GetRegionsEvent());

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final theme = Theme.of(context).colorScheme;

    return BlocBuilder<RegionsBloc, RegionsState>(
      buildWhen: (_, current) =>
          current is RegionsLoading ||
          current is RegionsLoaded ||
          current is RegionsError,
      builder: (context, state) {
        if (state is RegionsError) {
          return _ErrorView(message: state.message, onRetry: _load);
        }

        final isLoading = state is! RegionsLoaded;
        final regions = state is RegionsLoaded ? state.regions : _skeleton;

        if (isLoading) {
          return Center(child: spinKitApp(theme.primary));
        }

        if (!isLoading && regions.isEmpty) {
          return _EmptyView(message: l.no_regions_found, onRefresh: _load);
        }

        return RefreshIndicator(
          onRefresh: () async => _load(),
          child: Skeletonizer(
            enabled: isLoading,
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 8.h, vertical: 16.h),
              itemCount: regions.length,
              separatorBuilder: (_, _) => SizedBox(height: 12.h),
              itemBuilder: (_, index) {
                final region = regions[index];
                return RegionCard(
                  region: region,
                  onTap: isLoading
                      ? null
                      : () => GoRouter.of(
                          context,
                        ).push(AppRouter.kRegionDetails, extra: region.id),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

final _skeleton = List.generate(
  6,
  (i) => RegionEntity(
    id: 0,
    name: 'Region name',
    image: Assets.images.test.test.path,
    managerId: 0,
    manager: ManagerEntity(
      id: 0,
      fullname: 'Manager fullname',
      email: 'manager@email.com',
      role: 'manager',
    ),
  ),
);

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 42.sp),
            SizedBox(height: 10.h),
            Text(message, textAlign: TextAlign.center),
            SizedBox(height: 16.h),
            ElevatedButton(
              onPressed: onRetry,
              child: Text(AppLocalizations.of(context)!.retry),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView({required this.message, required this.onRefresh});

  final String message;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => onRefresh(),
      child: ListView(
        children: [
          SizedBox(height: 120.h),
          AppEmptyState(icon: Icons.location_off_outlined, title: message),
        ],
      ),
    );
  }
}
