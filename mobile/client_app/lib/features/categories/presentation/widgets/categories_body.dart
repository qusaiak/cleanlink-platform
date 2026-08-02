import 'dart:async';

import 'package:client_app/features/categories/presentation/bloc/categories_bloc.dart';
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
import '../../../home/presentation/widgets/category_item.dart';

class CategoriesBody extends StatefulWidget {
  const CategoriesBody({super.key});

  @override
  State<CategoriesBody> createState() => _CategoriesBodyState();
}

class _CategoriesBodyState extends State<CategoriesBody> {
  static const double _loadMoreThreshold = 250;

  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    context.read<CategoriesBloc>().add(const GetCategoriesEvent());
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - _loadMoreThreshold) {
      context.read<CategoriesBloc>().add(const GetMoreCategoriesEvent());
    }
  }

  Future<void> _onRefresh() {
    final completer = Completer<void>();
    context.read<CategoriesBloc>().add(
      GetCategoriesEvent(refresh: true, completer: completer),
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
    var theme = Theme.of(context).colorScheme;
    final localizations = AppLocalizations.of(context)!;
    return BlocConsumer<CategoriesBloc, CategoriesState>(
      listenWhen: (previous, current) {
        if (current is! CategoriesLoaded) return false;
        final previousLoaded = previous is CategoriesLoaded ? previous : null;
        return current.loadMoreError != null &&
            current.loadMoreError != previousLoaded?.loadMoreError;
      },
      listener: (context, state) {
        final loaded = state as CategoriesLoaded;
        AppSnackBar.showError(
          context: context,
          title: localizations.error,
          message: loaded.loadMoreError!,
        );
      },
      builder: (context, state) {
        if (state is CategoriesLoading) {
          return Center(child: spinKitApp(theme.primary));
        }
        if (state is CategoriesError) {
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
                      context.read<CategoriesBloc>().add(
                        const GetCategoriesEvent(),
                      );
                    },
                    child: Text(AppLocalizations.of(context)!.retry),
                  ),
                ],
              ),
            ),
          );
        }
        if (state is CategoriesLoaded) {
          final categories = state.categories;

          return RefreshIndicator(
            onRefresh: _onRefresh,
            child: CustomScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                if (categories.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: AppEmptyState(
                        icon: Icons.category_outlined,
                        title: localizations.no_categories_found,
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    sliver: SliverGrid(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final item = categories[index];
                        return CategoryItem(
                          category: item,
                          number: 2,
                          onTap: () {
                            GoRouter.of(
                              context,
                            ).push(AppRouter.kCategoryDetails, extra: item.id);
                          },
                        );
                      }, childCount: categories.length),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 14.h,
                        crossAxisSpacing: 14.w,
                        childAspectRatio: 1,
                      ),
                    ),
                  ),
                if (categories.isNotEmpty)
                  SliverToBoxAdapter(
                    child: PaginationFooter(
                      isLoading: state.isLoadingMore,
                      errorMessage: state.loadMoreError == null
                          ? null
                          : localizations.could_not_load_more_categories,
                      onRetry: () => context.read<CategoriesBloc>().add(
                        const GetMoreCategoriesEvent(retry: true),
                      ),
                    ),
                  ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
