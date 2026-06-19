import 'package:client_app/core/widgets/row_title.dart';
import 'package:client_app/features/home/presentation/widgets/companies_section.dart';
import 'package:client_app/features/home/presentation/widgets/home_app_bar.dart';
import 'package:client_app/features/home/presentation/widgets/services_section.dart';
import 'package:client_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/routes/app_router.dart';
import 'categories_section.dart';
import 'offers_section.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: theme.background,
      body: SafeArea(
        child: ListView(
          children: [
            const SizedBox(height: 10),
            const HomeAppBar(),
            const SizedBox(height: 20),
            const OffersSection(),
            const SizedBox(height: 24),
            RowTitle(
              iconData: Icons.category,
              title: AppLocalizations.of(context)!.categories,
              onTap: () {
                GoRouter.of(context).push(AppRouter.kCategories);
              },
            ),
            const CategoriesSection(),
            const SizedBox(height: 24),
            RowTitle(
              iconData: Icons.business,
              title: AppLocalizations.of(context)!.popular_companies,
              onTap: () {
                GoRouter.of(context).push(AppRouter.kCompanies);
              },
            ),
            const CompaniesSection(),
            const SizedBox(height: 24),
            RowTitle(
              iconData: Icons.cleaning_services,
              title: AppLocalizations.of(context)!.popular_services,
              onTap: () {
                GoRouter.of(context).push(AppRouter.kServices);
              },
            ),
            const ServicesSection(),
          ],
        ),
      ),
    );
  }
}
