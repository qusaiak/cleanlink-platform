import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../config/theme/styles.dart';
import '../../../../l10n/app_localizations.dart';
import '../bloc/bookings_bloc.dart';

class BookingsTabBar extends StatelessWidget {
  const BookingsTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final theme = Theme.of(context).colorScheme;

    final tabs = <BookingTab, String>{
      BookingTab.all: l10n.all,
      BookingTab.pending: l10n.pending,
      BookingTab.assigned: l10n.assigned,
      BookingTab.inProcess: l10n.in_process,
      BookingTab.completed: l10n.completed,
      BookingTab.canceled: l10n.canceled,
    };

    return BlocBuilder<BookingsBloc, BookingsState>(
      buildWhen: (prev, curr) => prev.selectedTab != curr.selectedTab,
      builder: (context, state) {
        return SizedBox(
          height: 35.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: tabs.length,
            separatorBuilder: (_, _) => SizedBox(width: 8.w),
            itemBuilder: (context, index) {
              final entry = tabs.entries.elementAt(index);
              final isSelected = state.selectedTab == entry.key;
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  context.read<BookingsBloc>().add(ChangeTab(entry.key));
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? theme.primary : theme.surface,
                    // border: BoxBorder.all(
                    //   width: 1,
                    //   color: isSelected ? theme.primary: theme.onSurfaceVariant
                    // ),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    entry.value,
                    style: Styles.textStyle12.copyWith(
                      fontSize: 13,
                      color: isSelected
                          ? theme.onPrimary
                          : theme.onSurfaceVariant,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
