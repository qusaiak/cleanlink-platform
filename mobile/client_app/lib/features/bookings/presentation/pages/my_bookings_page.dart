import 'package:client_app/core/utils/functions/spinkit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../config/language/app_language_info.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/custom_appbar.dart';
import '../../../../l10n/app_localizations.dart';
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
  bool _matchesTab(BookingTab tab, String status) {
    switch (tab) {
      case BookingTab.all:
        return true;
      case BookingTab.pending:
        return status == 'pending' || status == 'upcoming';
      case BookingTab.assigned:
        return status == 'ongoing' ||
            status == 'accepted' ||
            status == 'approved';
      case BookingTab.completed:
        return status == 'completed';
      case BookingTab.cancelled:
        return status == 'canceled' || status == 'cancelled';
    }
  }

  @override
  void initState() {
    super.initState();
    _lastLanguageCode = AppLanguageInfo.languageCode;
    context.read<BookingsBloc>().add(const GetOrdersEvent());
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
              child: BlocBuilder<BookingsBloc, BookingsState>(
                builder: (context, state) {
                  final colors = Theme.of(context).colorScheme;

                  if (state.isLoadingOrders || !state.hasLoadedOrders) {
                    return Center(child: spinKitApp(colors.primary));
                  }

                  if (state.errorMessage != null && state.orders.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.all(24.w),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              state.errorMessage!,
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
                      .where(
                        (order) => _matchesTab(
                          state.selectedTab,
                          order.status.toLowerCase(),
                        ),
                      )
                      .toList();

                  if (orders.isEmpty) {
                    return RefreshIndicator(
                      onRefresh: () async {
                        final bloc = context.read<BookingsBloc>();

                        bloc.add(const GetOrdersEvent());

                        await bloc.stream.firstWhere(
                          (state) =>
                              !state.isLoadingOrders && state.hasLoadedOrders,
                        );
                      },
                      child: ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: [
                          SizedBox(height: 100.h),
                          AppEmptyState(
                            icon: Icons.cleaning_services_outlined,
                            title: AppLocalizations.of(context)!.no_bookings,
                            body: AppLocalizations.of(
                              context,
                            )!.no_bookings_message,
                          ),
                        ],
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () async {
                      final bloc = context.read<BookingsBloc>();

                      bloc.add(const GetOrdersEvent());

                      await bloc.stream.firstWhere(
                        (state) =>
                            !state.isLoadingOrders && state.hasLoadedOrders,
                      );
                    },
                    child: ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.only(bottom: 24.h),
                      itemCount: orders.length,
                      separatorBuilder: (_, _) => SizedBox(height: 14.h),
                      itemBuilder: (_, index) {
                        return BookingCard(booking: orders[index]);
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
