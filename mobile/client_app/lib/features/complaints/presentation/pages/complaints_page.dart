import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/routes/app_router.dart';
import '../../../../core/utils/functions/spinkit.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/complaint_entity.dart';
import '../bloc/complaints_bloc.dart';
import '../widgets/complaint_card.dart';

class ComplaintsPage extends StatefulWidget {
  const ComplaintsPage({super.key});
  @override
  State<ComplaintsPage> createState() => _ComplaintsPageState();
}

class _ComplaintsPageState extends State<ComplaintsPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;

  @override
  void initState() {
    super.initState();

    _tabs = TabController(length: 2, vsync: this);

    context.read<ComplaintsBloc>().add(
      const LoadComplaintsEvent(refresh: true, forceLoading: true),
    );
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l.complaints),
        bottom: TabBar(
          controller: _tabs,
          dividerHeight: 0,
          indicatorSize: TabBarIndicatorSize.tab,
          tabs: [
            Tab(text: l.service_complaints),
            Tab(text: l.company_complaints),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabs,
        children: [
          _ComplaintList(type: ComplaintType.service),
          _ComplaintList(type: ComplaintType.company),
        ],
      ),
    );
  }
}

class _ComplaintList extends StatelessWidget {
  const _ComplaintList({required this.type});
  final ComplaintType type;

  Future<void> _refresh(BuildContext context) {
    final completer = Completer<void>();

    context.read<ComplaintsBloc>().add(
      LoadComplaintsEvent(refresh: true, completer: completer),
    );

    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final theme = Theme.of(context).colorScheme;
    return BlocBuilder<ComplaintsBloc, ComplaintsState>(
      builder: (context, state) {
        final list = state.listFor(type);
        if (list.isInitialLoading) {
          return Center(child: spinKitApp(theme.primary));
        }
        if (list.error != null && list.items.isEmpty) {
          return Center(
            child: AppEmptyState(
              icon: Icons.error_outline,
              title: l.could_not_load_complaints,
              body: list.error,
              action: ElevatedButton(
                onPressed: () => context.read<ComplaintsBloc>().add(
                  const LoadComplaintsEvent(),
                ),
                child: Text(l.retry),
              ),
            ),
          );
        }
        if (list.items.isEmpty) {
          return RefreshIndicator(
            onRefresh: () => _refresh(context),
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(height: MediaQuery.sizeOf(context).height * 0.2),
                AppEmptyState(
                  icon: Icons.report_problem_outlined,
                  title: l.no_complaints_found,
                ),
              ],
            ),
          );
        }
        return RefreshIndicator(
          onRefresh: () => _refresh(context),
          child: ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
            itemCount: list.items.length,
            separatorBuilder: (_, _) => SizedBox(height: 8.h),
            itemBuilder: (context, index) {
              final complaint = list.items[index];
              return ComplaintCard(
                complaint: complaint,
                onTap: () =>
                    context.push(AppRouter.complaintDetailsPath(complaint.id)),
              );
            },
          ),
        );
      },
    );
  }
}
