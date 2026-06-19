
import 'package:flutter/material.dart';
import 'package:worker_app/features/home/presentation/widgets/service_page.dart';
import 'package:worker_app/features/home/presentation/widgets/services_section.dart';
import '../../../../core/widgets/row_title.dart';
import '../../../../l10n/app_localizations.dart';
import 'categories_section.dart';
import 'companies_section.dart';
import 'home_app_bar.dart';
import 'tasks_section.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: theme.background,
      body: SafeArea(
     child: SuperExplosiveUI(),
       // child: ListView(
    //      children: [
           // const SizedBox(height: 10),
           //  const HomeAppBar(),
           //  const SizedBox(height: 20),

            //const TasksSection(),
            // const SizedBox(height: 24),
            // RowTitle(
            //   iconData: Icons.category,
            //   title: AppLocalizations.of(context)!.categories,
            //   onTap: () {},
            // ),
            // const CategoriesSection(),
            // const SizedBox(height: 24),
            // RowTitle(
            //   iconData: Icons.business,
            //   title: AppLocalizations.of(context)!.popular_companies,
            //   onTap: () {},
            // ),
            // const CompaniesSection(),
            // const SizedBox(height: 24),
            // RowTitle(
            //   iconData: Icons.cleaning_services,
            //   title: AppLocalizations.of(context)!.popular_services,
            //   onTap: () {},
            // ),
            // const ServicesSection(),
         // ],
        ),
      );

  }
}
