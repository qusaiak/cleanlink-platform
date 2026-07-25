import 'package:client_app/config/routes/app_router.dart';
import 'package:client_app/core/utils/functions/spinkit.dart';
import 'package:client_app/core/widgets/app_empty_state.dart';
import 'package:client_app/features/categories/presentation/widgets/category_service_card.dart';
import 'package:client_app/features/home/presentation/widgets/company_card.dart';
import 'package:client_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../bloc/favorites_bloc.dart';

class FavoritesBody extends StatelessWidget {
  final TabController controller;

  const FavoritesBody({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return BlocBuilder<FavoritesBloc, FavoritesState>(
      builder: (context, state) {
        if (state is FavoritesLoading) {
          return Center(child: spinKitApp(theme.primary));
        }

        if (state is FavoritesError) {
          return Center(child: Text(state.msg));
        }

        if (state is FavoritesLoaded) {
          final services = state.data.services
              .where((e) => e.isFavorite)
              .toList();

          final companies = state.data.companies
              .where((e) => e.isFavorite)
              .toList();

          return TabBarView(
            controller: controller,

            children: [
              services.isEmpty
                  ? AppEmptyState(
                      icon: Icons.favorite_border,
                      title: AppLocalizations.of(context)!.no_favorite_services,
                    )
                  : ListView.separated(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 16.h,
                      ),

                      itemCount: services.length,

                      separatorBuilder: (_, _) => SizedBox(height: 12.h),

                      itemBuilder: (context, index) {
                        final service = services[index];

                        return CategoryServiceCard(
                          service: service,

                          onTap: () {
                            context.push(
                              AppRouter.kServiceDetails,

                              extra: service.id,
                            );
                          },
                        );
                      },
                    ),

              companies.isEmpty
                  ? AppEmptyState(
                      icon: Icons.business_outlined,
                      title: AppLocalizations.of(
                        context,
                      )!.no_favorite_companies,
                    )
                  : ListView.separated(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 16.h,
                      ),

                      itemCount: companies.length,

                      separatorBuilder: (_, _) => SizedBox(height: 12.h),

                      itemBuilder: (context, index) {
                        final company = companies[index];

                        return SizedBox(
                          height: 200.w,

                          child: CompanyCard(
                            company: company,

                            onTap: () {
                              context.push(
                                AppRouter.kCompanyDetails,

                                extra: company.id,
                              );
                            },
                          ),
                        );
                      },
                    ),
            ],
          );
        }

        return const SizedBox();
      },
    );
  }
}
