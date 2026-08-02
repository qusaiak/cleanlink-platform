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
import '../../../categories/presentation/widgets/category_service_card.dart';
import '../bloc/services_bloc.dart';

class ServicesBody extends StatefulWidget {
  const ServicesBody({super.key});

  @override
  State<ServicesBody> createState() => _ServicesBodyState();
}

class _ServicesBodyState extends State<ServicesBody> {
  static const double _loadMoreThreshold = 250;

  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    context.read<ServicesBloc>().add(const GetServicesEvent());
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - _loadMoreThreshold) {
      context.read<ServicesBloc>().add(const GetMoreServicesEvent());
    }
  }

  Future<void> _onRefresh() {
    final completer = Completer<void>();
    context.read<ServicesBloc>().add(
      GetServicesEvent(refresh: true, completer: completer),
    );
    return completer.future;
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
    final theme = Theme.of(context).colorScheme;
    final l = AppLocalizations.of(context)!;

    return BlocConsumer<ServicesBloc, ServicesState>(
      buildWhen: (_, current) =>
          current is ServicesLoading ||
          current is ServicesLoaded ||
          current is ServicesError,
      listenWhen: (previous, current) {
        if (current is! ServicesLoaded || current.loadMoreError == null) {
          return false;
        }
        return previous is! ServicesLoaded ||
            previous.loadMoreError != current.loadMoreError;
      },
      listener: (context, state) {
        AppSnackBar.showError(
          context: context,
          title: l.error,
          message: (state as ServicesLoaded).loadMoreError!,
        );
      },
      builder: (context, state) {
        if (state is ServicesLoading) {
          return Center(child: spinKitApp(theme.primary));
        }
        if (state is ServicesError) {
          return _ErrorView(
            message: state.message,
            onRetry: () =>
                context.read<ServicesBloc>().add(const GetServicesEvent()),
          );
        }
        if (state is! ServicesLoaded) return const SizedBox.shrink();

        return RefreshIndicator(
          onRefresh: _onRefresh,
          child: CustomScrollView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            slivers: [
              if (state.services.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: AppEmptyState(
                      icon: Icons.cleaning_services_outlined,
                      title: l.no_services_available,
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.w,
                    vertical: 12.w,
                  ),
                  sliver: SliverList.builder(
                    itemCount: state.services.length,
                    itemBuilder: (context, index) => Padding(
                      padding: EdgeInsets.only(bottom: 12.h),
                      child: CategoryServiceCard(
                        service: state.services[index],
                        onTap: () => GoRouter.of(context).push(
                          AppRouter.kServiceDetails,
                          extra: state.services[index].id,
                        ),
                      ),
                    ),
                  ),
                ),
              if (state.services.isNotEmpty)
                SliverToBoxAdapter(
                  child: PaginationFooter(
                    isLoading: state.isLoadingMore,
                    errorMessage: state.loadMoreError == null
                        ? null
                        : l.could_not_load_more_services,
                    onRetry: () => context.read<ServicesBloc>().add(
                      const GetMoreServicesEvent(retry: true),
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
