import 'dart:async';

import 'package:client_app/core/utils/functions/spinkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../config/language/app_language_info.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/custom_appbar.dart';
import '../../../../core/widgets/custom_toast.dart';
import '../../../../core/widgets/pagination_footer.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/booking_entity.dart';
import '../bloc/bookings_bloc.dart';
import '../widgets/booking_card.dart';
import '../widgets/bookings_tab_bar.dart';

class MyBookingsPage extends StatefulWidget {
  const MyBookingsPage({super.key});
  @override
  State<MyBookingsPage> createState() => _MyBookingsPageState();
}

class _MyBookingsPageState extends State<MyBookingsPage> {
  String? _lastLanguageCode;
  late final ScrollController _scrollController;

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    if (_scrollController.position.extentAfter <= 250) {
      context.read<BookingsBloc>().add(const GetMoreOrdersEvent());
    }
  }

  Future<void> _refresh() {
    final completer = Completer<void>();
    context.read<BookingsBloc>().add(RefreshBookings(completer: completer));
    return completer.future;
  }

  bool _matchesTab(BookingTab tab, OrderEntity order) {
    switch (tab) {
      case BookingTab.all:
        return true;
      case BookingTab.pending:
        return order.statusType == OrderStatus.pending;
      case BookingTab.assigned:
        return order.statusType == OrderStatus.assignedToWorker;
      case BookingTab.inProcess:
        return order.statusType == OrderStatus.inProgress;
      case BookingTab.completed:
        return order.statusType == OrderStatus.completed;
      case BookingTab.canceled:
        return order.statusType == OrderStatus.canceled;
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    _lastLanguageCode = AppLanguageInfo.languageCode;
    context.read<BookingsBloc>().add(const GetOrdersEvent());
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final currentLanguageCode = AppLanguageInfo.languageCode;

    if (_lastLanguageCode != null && _lastLanguageCode != currentLanguageCode) {
      _lastLanguageCode = currentLanguageCode;

      context.read<BookingsBloc>().add(const GetOrdersEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: customAppBar(
        AppLocalizations.of(context)!.my_bookings,
        null,
        const [],
        () {},
        colors.onSurface,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const BookingsTabBar(),
            SizedBox(height: 12.h),
            Expanded(
              child: BlocConsumer<BookingsBloc, BookingsState>(
                listenWhen: (previous, current) =>
                    previous.loadMoreOrdersError !=
                        current.loadMoreOrdersError &&
                    current.loadMoreOrdersError != null,
                listener: (context, state) {
                  final l = AppLocalizations.of(context)!;
                  AppSnackBar.showError(
                    context: context,
                    title: l.error,
                    message: state.loadMoreOrdersError!,
                  );
                },
                builder: (context, state) {
                  final colors = Theme.of(context).colorScheme;

                  if (state.isLoadingOrders || !state.hasLoadedOrders) {
                    return Center(child: spinKitApp(colors.primary));
                  }

                  if (state.ordersErrorMessage != null &&
                      state.orders.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.all(24.w),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              state.ordersErrorMessage!,
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 16.h),
                            ElevatedButton(
                              onPressed: () {
                                context.read<BookingsBloc>().add(
                                  const GetOrdersEvent(),
                                );
                              },
                              child: Text(AppLocalizations.of(context)!.retry),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  final orders = state.orders
                      .where((order) => _matchesTab(state.selectedTab, order))
                      .toList();

                  return RefreshIndicator(
                    onRefresh: _refresh,
                    child: ListView.builder(
                      controller: _scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.only(bottom: 24.h),
                      itemCount: orders.isEmpty ? 2 : orders.length + 1,
                      itemBuilder: (_, index) {
                        if (orders.isEmpty && index == 0) {
                          return Padding(
                            padding: EdgeInsets.only(top: 100.h),
                            child: AppEmptyState(
                              icon: Icons.cleaning_services_outlined,
                              title: AppLocalizations.of(context)!.no_bookings,
                              body: AppLocalizations.of(
                                context,
                              )!.no_bookings_message,
                            ),
                          );
                        }

                        final footerIndex = orders.isEmpty ? 1 : orders.length;
                        if (index == footerIndex) {
                          return PaginationFooter(
                            isLoading: state.isLoadingMoreOrders,
                            errorMessage: state.loadMoreOrdersError == null
                                ? null
                                : AppLocalizations.of(
                                    context,
                                  )!.could_not_load_more_orders,
                            onRetry: () => context.read<BookingsBloc>().add(
                              const GetMoreOrdersEvent(),
                            ),
                          );
                        }

                        return Padding(
                          padding: EdgeInsets.only(bottom: 14.h),
                          child: BookingCard(booking: orders[index]),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
