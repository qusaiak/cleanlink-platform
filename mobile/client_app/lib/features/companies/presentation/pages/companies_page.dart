import 'package:flutter/material.dart';
import '../../../../core/widgets/custom_appbar.dart';
import '../../../../l10n/app_localizations.dart';
import '../widgets/companies_body.dart';

class CompaniesPage extends StatelessWidget {
  const CompaniesPage({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: customAppBar(
        AppLocalizations.of(context)!.all_companies,
        null,
        [],
        () {},
        theme.onSurface,
      ),
      body: const CompaniesBody(),
    );
  }
}
