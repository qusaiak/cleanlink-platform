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
import '../../../home/presentation/widgets/company_card.dart';
import '../bloc/companies_bloc.dart';

class CompaniesBody extends StatefulWidget {
  const CompaniesBody({super.key});

  @override
  State<CompaniesBody> createState() => _CompaniesBodyState();
}

class _CompaniesBodyState extends State<CompaniesBody> {
  static const double _loadMoreThreshold = 250;

  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    context.read<CompaniesBloc>().add(const GetCompaniesEvent());
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - _loadMoreThreshold) {
      context.read<CompaniesBloc>().add(const GetMoreCompaniesEvent());
    }
  }

  Future<void> _onRefresh() {
    final completer = Completer<void>();
    context.read<CompaniesBloc>().add(
      GetCompaniesEvent(refresh: true, completer: completer),
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

    return BlocConsumer<CompaniesBloc, CompaniesState>(
      buildWhen: (_, current) =>
          current is CompaniesLoading ||
          current is CompaniesLoaded ||
          current is CompaniesError,
      listenWhen: (previous, current) {
        if (current is! CompaniesLoaded || current.loadMoreError == null) {
          return false;
        }
        return previous is! CompaniesLoaded ||
            previous.loadMoreError != current.loadMoreError;
      },
      listener: (context, state) {
        AppSnackBar.showError(
          context: context,
          title: l.error,
          message: (state as CompaniesLoaded).loadMoreError!,
        );
      },
      builder: (context, state) {
        if (state is CompaniesLoading) {
          return Center(child: spinKitApp(theme.primary));
        }
        if (state is CompaniesError) {
          return _ErrorView(
            message: state.error,
            onRetry: () =>
                context.read<CompaniesBloc>().add(const GetCompaniesEvent()),
          );
        }
        if (state is! CompaniesLoaded) return const SizedBox.shrink();

        return RefreshIndicator(
          onRefresh: _onRefresh,
          child: CustomScrollView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            slivers: [
              if (state.companies.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: AppEmptyState(
                      icon: Icons.business_outlined,
                      title: l.no_companies_found,
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  sliver: SliverList.builder(
                    itemCount: state.companies.length,
                    itemBuilder: (context, index) => Padding(
                      padding: EdgeInsets.only(bottom: 14.h),
                      child: SizedBox(
                        height: 200.w,
                        child: CompanyCard(
                          company: state.companies[index],
                          onTap: () => GoRouter.of(context).push(
                            AppRouter.kCompanyDetails,
                            extra: state.companies[index].id,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              if (state.companies.isNotEmpty)
                SliverToBoxAdapter(
                  child: PaginationFooter(
                    isLoading: state.isLoadingMore,
                    errorMessage: state.loadMoreError == null
                        ? null
                        : l.could_not_load_more_companies,
                    onRetry: () => context.read<CompaniesBloc>().add(
                      const GetMoreCompaniesEvent(retry: true),
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
