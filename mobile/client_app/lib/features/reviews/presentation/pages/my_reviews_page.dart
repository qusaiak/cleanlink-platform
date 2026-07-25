import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/routes/app_router.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/custom_toast.dart';
import '../../../../injection_container.dart';
import '../../../../l10n/app_localizations.dart';
import '../bloc/my_reviews_bloc.dart';
import '../widgets/my_review_card.dart';
import '../../domain/entities/my_review_entity.dart';

class MyReviewsPage extends StatelessWidget {
  const MyReviewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<MyReviewsBloc>()..add(GetMyReviewsEvent()),
      child: const _MyReviewsView(),
    );
  }
}

class _MyReviewsView extends StatelessWidget {
  const _MyReviewsView();

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l.my_reviews),
          bottom: TabBar(
            dividerHeight: 0,
            indicatorSize: TabBarIndicatorSize.tab,
            tabs: [
              Tab(text: l.services_title),
              Tab(text: l.companies_title),
            ],
          ),
        ),
        body: BlocConsumer<MyReviewsBloc, MyReviewsState>(
          listenWhen: (previous, current) =>
              previous.errorMessage != current.errorMessage &&
              current.errorMessage != null &&
              current.hasContent,
          listener: (context, state) => AppSnackBar.showError(
            context: context,
            title: l.error,
            message: _localizedError(state.errorMessage!, l),
          ),
          builder: (context, state) {
            if (state.isLoading && !state.hasContent) {
              return const Center(child: CircularProgressIndicator.adaptive());
            }
            if (state.errorMessage != null && !state.hasContent) {
              return Center(
                child: AppEmptyState(
                  icon: Icons.cloud_off_outlined,
                  title: l.could_not_load_your_reviews,
                  body: _localizedError(state.errorMessage!, l),
                  action: FilledButton(
                    onPressed: () =>
                        context.read<MyReviewsBloc>().add(GetMyReviewsEvent()),
                    child: Text(l.retry),
                  ),
                ),
              );
            }
            return TabBarView(
              children: [
                _ReviewList(reviews: state.serviceReviews, isService: true),
                _ReviewList(reviews: state.companyReviews, isService: false),
              ],
            );
          },
        ),
      ),
    );
  }

  String _localizedError(String message, AppLocalizations l) {
    return message == 'could_not_load_your_reviews'
        ? l.could_not_load_your_reviews
        : message;
  }
}

class _ReviewList extends StatelessWidget {
  final List<MyReviewEntity> reviews;
  final bool isService;

  const _ReviewList({required this.reviews, required this.isService});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return RefreshIndicator(
      onRefresh: () async {
        final bloc = context.read<MyReviewsBloc>()
          ..add(RefreshMyReviewsEvent());
        await bloc.stream.firstWhere((state) => !state.isRefreshing);
      },
      child: reviews.isEmpty
          ? ListView(
              children: [
                SizedBox(height: 120.h),
                AppEmptyState(
                  icon: isService
                      ? Icons.cleaning_services_outlined
                      : Icons.business_outlined,
                  title: isService
                      ? l.no_service_reviews_yet
                      : l.no_company_reviews_yet,
                  body: isService
                      ? l.service_reviews_will_appear_here
                      : l.company_reviews_will_appear_here,
                ),
              ],
            )
          : ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
              itemCount: reviews.length,
              separatorBuilder: (_, _) => SizedBox(height: 8.h),
              itemBuilder: (context, index) {
                final review = reviews[index];
                final id = isService ? review.service?.id : review.company?.id;
                return MyReviewCard(
                  key: ValueKey(review.id),
                  review: review,
                  onTap: id == null
                      ? null
                      : () => context.push(
                          isService
                              ? AppRouter.kServiceDetails
                              : AppRouter.kCompanyDetails,
                          extra: id,
                        ),
                );
              },
            ),
    );
  }
}
