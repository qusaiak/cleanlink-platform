import 'dart:async';

import 'package:client_app/features/home/presentation/widgets/offer_card.dart';
import 'package:client_app/features/services/presentation/bloc/services_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/routes/app_router.dart';
import '../../../../core/utils/functions/spinkit.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/pagination_footer.dart';
import '../../../../core/widgets/custom_toast.dart';
import '../../../../l10n/app_localizations.dart';

class OffersBody extends StatefulWidget {
  const OffersBody({super.key});

  @override
  State<OffersBody> createState() => _OffersBodyState();
}

class _OffersBodyState extends State<OffersBody> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    context.read<ServicesBloc>().add(const GetOffersEvent());
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    if (_scrollController.position.extentAfter < 300) {
      context.read<ServicesBloc>().add(const GetMoreOffersEvent());
    }
  }

  Future<void> _refresh() {
    final completer = Completer<void>();
    context.read<ServicesBloc>().add(
      GetOffersEvent(refresh: true, completer: completer),
    );
    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;
    return BlocConsumer<ServicesBloc, ServicesState>(
      listener: (context, state) {
        if (state is OffersLoaded && state.loadMoreError != null) {
          AppSnackBar.showError(
            context: context,
            title: AppLocalizations.of(context)!.error,
            message: AppLocalizations.of(context)!.could_not_load_more_offers,
          );
        }
      },
      buildWhen: (_, current) =>
          current is OffersLoading ||
          current is OffersLoaded ||
          current is OffersError,

      builder: (context, state) {
        if (state is OffersLoading) {
          return Center(child: spinKitApp(theme.primary));
        }

        if (state is OffersError) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.error_outline, size: 42.sp),

                  SizedBox(height: 10.h),

                  Text(state.message, textAlign: TextAlign.center),

                  SizedBox(height: 16.h),

                  ElevatedButton(
                    onPressed: () {
                      context.read<ServicesBloc>().add(const GetOffersEvent());
                    },
                    child: Text(AppLocalizations.of(context)!.retry),
                  ),
                ],
              ),
            ),
          );
        }
        if (state is OffersLoaded) {
          final offers = state.offers;

          if (offers.isEmpty) {
            return Center(
              child: AppEmptyState(
                icon: Icons.local_offer_outlined,
                title: AppLocalizations.of(context)!.no_offers_found,
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.separated(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.w),
              itemCount: offers.length + 1,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (_, index) {
                if (index == offers.length) {
                  return PaginationFooter(
                    isLoading: state.isLoadingMore,
                    errorMessage: state.loadMoreError == null
                        ? null
                        : AppLocalizations.of(
                            context,
                          )!.could_not_load_more_offers,
                    onRetry: () => context.read<ServicesBloc>().add(
                      const GetMoreOffersEvent(retry: true),
                    ),
                  );
                }
                return SizedBox(
                  height: 180.h,
                  child: OfferCard(
                    offer: offers[index],
                    isActive: true,
                    onTap: () {
                      GoRouter.of(context).push(
                        AppRouter.kServiceDetails,
                        extra: offers[index].id,
                      );
                    },
                  ),
                );
                //   ServiceTile(
                //   service: services[i],
                //   onTap: () {
                //     GoRouter.of(
                //       context,
                //     ).push(AppRouter.kServiceDetails, extra: services[i].id);
                //   },
                // );
              },
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
