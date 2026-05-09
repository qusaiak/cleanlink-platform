import 'package:flutter/material.dart';
import '../../../../core/widgets/custom_appbar.dart';
import '../../../../l10n/app_localizations.dart';
import '../widgets/categories_body.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context)!.colorScheme;
    return Scaffold(
      appBar: customAppBar(
        AppLocalizations.of(context)!.all_categories,
        null,
        [],
        () {},
        theme.onSurface,
      ),
      body: CategoriesBody(),
    );
  }
}
