import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/routes/app_router.dart';
import '../../../../core/utils/functions/spinkit.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/custom_toast.dart';
import '../../../../core/widgets/pagination_footer.dart';
import '../../../../l10n/app_localizations.dart';
import '../bloc/regions_bloc.dart';
import 'region_card.dart';

class RegionsBody extends StatefulWidget {
  const RegionsBody({super.key});

  @override
  State<RegionsBody> createState() => _RegionsBodyState();
}

class _RegionsBodyState extends State<RegionsBody> {
  static const double _loadMoreThreshold = 250;

  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    context.read<RegionsBloc>().add(const GetRegionsEvent());
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - _loadMoreThreshold) {
      context.read<RegionsBloc>().add(const GetMoreRegionsEvent());
    }
  }

  Future<void> _onRefresh() {
    final completer = Completer<void>();
    context.read<RegionsBloc>().add(
      GetRegionsEvent(refresh: true, completer: completer),
    );
    return completer.future;
  }

  void _retryInitial() {
    context.read<RegionsBloc>().add(const GetRegionsEvent());
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final theme = Theme.of(context).colorScheme;

    return BlocConsumer<RegionsBloc, RegionsState>(
      buildWhen: (_, current) =>
          current is RegionsLoading ||
          current is RegionsLoaded ||
          current is RegionsError,
      listenWhen: (previous, current) {
        if (current is! RegionsLoaded || current.loadMoreError == null) {
          return false;
        }
        return previous is! RegionsLoaded ||
            previous.loadMoreError != current.loadMoreError;
      },
      listener: (context, state) {
        AppSnackBar.showError(
          context: context,
          title: l.error,
          message: (state as RegionsLoaded).loadMoreError!,
        );
      },
      builder: (context, state) {
        if (state is RegionsLoading) {
          return Center(child: spinKitApp(theme.primary));
        }
        if (state is RegionsError) {
          return _ErrorView(message: state.message, onRetry: _retryInitial);
        }
        if (state is! RegionsLoaded) return const SizedBox.shrink();

        return RefreshIndicator(
          onRefresh: _onRefresh,
          child: CustomScrollView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            slivers: [
              if (state.regions.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: AppEmptyState(
                      icon: Icons.location_off_outlined,
                      title: l.no_regions_found,
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.w,
                    vertical: 16.h,
                  ),
                  sliver: SliverList.builder(
                    itemCount: state.regions.length,
                    itemBuilder: (context, index) => Padding(
                      padding: EdgeInsets.only(bottom: 12.h),
                      child: RegionCard(
                        region: state.regions[index],
                        onTap: () => GoRouter.of(context).push(
                          AppRouter.kRegionDetails,
                          extra: state.regions[index].id,
                        ),
                      ),
                    ),
                  ),
                ),
              if (state.regions.isNotEmpty)
                SliverToBoxAdapter(
                  child: PaginationFooter(
                    isLoading: state.isLoadingMore,
                    errorMessage: state.loadMoreError == null
                        ? null
                        : l.could_not_load_more_regions,
                    onRetry: () => context.read<RegionsBloc>().add(
                      const GetMoreRegionsEvent(retry: true),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

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
