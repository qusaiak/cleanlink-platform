import 'package:client_app/core/widgets/row_title.dart';
import 'package:client_app/features/home/presentation/widgets/companies_section.dart';
import 'package:client_app/features/home/presentation/widgets/home_app_bar.dart';
import 'package:client_app/features/home/presentation/widgets/services_section.dart';
import 'package:client_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/routes/app_router.dart';
import '../../../../core/utils/functions/spinkit.dart';
import '../bloc/home_bloc.dart';
import 'categories_section.dart';
import 'offers_section.dart';

class HomeBody extends StatefulWidget {
  const HomeBody({super.key});

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {

  @override
  void initState() {
    super.initState();

    context.read<HomeBloc>().add(const GetHomeEvent());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: theme.background,
      body: SafeArea(
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is HomeLoading) {
              return Center(child: spinKitApp(theme.primary));
            }
            if (state is HomeError) {
              print("state.error");
              print(state.error);
              return Center(child: Text(state.error ?? 'Error'));
            }
            if (state is HomeLoaded) {
              final home = state.home!;
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<HomeBloc>().add(const RefreshHomeEvent());
                },
                child: ListView(
                  children: [
                    const SizedBox(height: 10),
                    const HomeAppBar(),
                    const SizedBox(height: 20),
                    OffersSection(offers: home.offers),
                    const SizedBox(height: 24),
                    RowTitle(
                      iconData: Icons.category,
                      title: AppLocalizations.of(context)!.popular_categories,
                      onTap: () {
                        GoRouter.of(context).push(AppRouter.kCategories);
                      },
                    ),
                    CategoriesSection(categories: home.categories),
                    const SizedBox(height: 24),
                    CompaniesSection(companies: home.companies),
                    const SizedBox(height: 24),
                    ServicesSection(services: home.services),
                  ],
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
    //   Scaffold(
    //   backgroundColor: theme.background,
    //   body: SafeArea(
    //     child: ListView(
    //       children: [
    //         const SizedBox(height: 10),
    //         const HomeAppBar(),
    //         const SizedBox(height: 20),
    //         const OffersSection(),
    //         const SizedBox(height: 24),
    //         RowTitle(
    //           iconData: Icons.category,
    //           title: AppLocalizations.of(context)!.popular_categories,
    //           onTap: () {
    //             GoRouter.of(context).push(AppRouter.kCategories);
    //           },
    //         ),
    //         const CategoriesSection(),
    //         const SizedBox(height: 24),
    //         const CompaniesSection(),
    //         const SizedBox(height: 24),
    //         const ServicesSection(),
    //       ],
    //     ),
    //   ),
    // );
  }
}
