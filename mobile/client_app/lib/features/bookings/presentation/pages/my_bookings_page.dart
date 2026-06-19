import 'package:client_app/core/widgets/custom_appbar.dart';
import 'package:client_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../bloc/bookings_bloc.dart';
import '../widgets/booking_card.dart';
import '../widgets/booking_empty_state.dart';
import '../widgets/bookings_tab_bar.dart';
import '../../domain/entities/booking_entity.dart';
import '../../domain/entities/worker_entity.dart';

class MyBookingsPage extends StatelessWidget {
  const MyBookingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;
    final List<BookingEntity> mockBookings = [
      BookingEntity(
        id: 1001,

        serviceName: "Deep Cleaning",

        companyName: "CleanLink Services",

        worker: const WorkerEntity(id: 1, name: "Ahmed Ali", image: ""),

        date: DateTime.now(),

        time: "09:30 AM - 11:30 AM",

        status: "completed",

        price: 120,
      ),

      BookingEntity(
        id: 1002,

        serviceName: "Apartment Cleaning",

        companyName: "CleanLink Premium",

        worker: const WorkerEntity(id: 2, name: "Mohammad Hassan", image: ""),

        date: DateTime.now().add(const Duration(days: 1)),

        time: "01:00 PM - 03:00 PM",

        status: "ongoing",

        price: 90,
      ),

      BookingEntity(
        id: 1003,

        serviceName: "Kitchen Cleaning",

        companyName: "Sparkle Clean",

        worker: null,

        date: DateTime.now().add(const Duration(days: 3)),

        time: "08:00 AM - 10:00 AM",

        status: "upcoming",

        price: 60,
      ),

      BookingEntity(
        id: 1004,

        serviceName: "Villa Cleaning",

        companyName: "CleanLink Pro",

        worker: const WorkerEntity(id: 3, name: "Omar Khaled", image: ""),

        date: DateTime.now().subtract(const Duration(days: 2)),

        time: "02:00 PM - 04:00 PM",

        status: "completed",

        price: 250,
      ),

      BookingEntity(
        id: 1005,

        serviceName: "Office Cleaning",

        companyName: "CleanLink Business",

        worker: const WorkerEntity(id: 4, name: "Ali Mustafa", image: ""),

        date: DateTime.now(),

        time: "11:00 AM - 01:00 PM",

        status: "cancelled",

        price: 180,
      ),
    ];
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: customAppBar(
          AppLocalizations.of(context)!.my_bookings,
          null,
          [],
          () {},
          theme.onSurface,
        ),
        body: SafeArea(
          child: Column(
            children: [
              const BookingsTabBar(),

              SizedBox(height: 12.h),

              Expanded(
                child: BlocBuilder<BookingsBloc, BookingsState>(
                  // builder: (_, state) {
                  //   if (state.loading) {
                  //     return const CircularProgressIndicator();
                  //   }
                  //
                  //   if (mockBookings.isEmpty) {
                  //     return const BookingEmptyState();
                  //   }
                  //
                  //   return RefreshIndicator(
                  //     onRefresh: () async {
                  //       context.read<BookingsBloc>().add(
                  //         const RefreshBookings(),
                  //       );
                  //     },
                  //
                  //     child: ListView.separated(
                  //       padding: EdgeInsets.only(bottom: 120.h),
                  //
                  //       itemCount: mockBookings.length,
                  //
                  //       separatorBuilder: (_, __) => SizedBox(height: 14.h),
                  //
                  //       itemBuilder: (_, index) {
                  //         return BookingCard(booking: mockBookings[index]);
                  //       },
                  //     ),
                  //   );
                  // },
                  builder: (_, state) {
                    if (state.loading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final filteredBookings = switch (state.selectedTab) {
                      BookingTab.all => mockBookings,

                      BookingTab.ongoing =>
                        mockBookings
                            .where((e) => e.status.toLowerCase() == "ongoing")
                            .toList(),

                      BookingTab.upcoming =>
                        mockBookings
                            .where((e) => e.status.toLowerCase() == "upcoming")
                            .toList(),

                      BookingTab.completed =>
                        mockBookings
                            .where((e) => e.status.toLowerCase() == "completed")
                            .toList(),

                      BookingTab.cancelled =>
                        mockBookings
                            .where((e) => e.status.toLowerCase() == "cancelled")
                            .toList(),
                    };

                    if (filteredBookings.isEmpty) {
                      return const BookingEmptyState();
                    }

                    return RefreshIndicator(
                      onRefresh: () async {
                        context.read<BookingsBloc>().add(
                          const RefreshBookings(),
                        );
                      },

                      child: ListView.separated(
                        // padding: EdgeInsets.only(bottom: kBottomNavigationBarHeight),

                        itemCount: filteredBookings.length,

                        separatorBuilder: (_, __) => SizedBox(height: 14.h),

                        itemBuilder: (_, index) {
                          return BookingCard(booking: filteredBookings[index]);
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
