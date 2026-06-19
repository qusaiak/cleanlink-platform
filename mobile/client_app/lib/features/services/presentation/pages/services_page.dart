import 'package:flutter/material.dart';
import '../../../../core/widgets/custom_appbar.dart';
import '../../../../l10n/app_localizations.dart';
import '../widgets/services_body.dart';

class ServicesPage extends StatelessWidget {
  const ServicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: customAppBar(
        AppLocalizations.of(context)!.popular_services,
        null,
        [],
        () {},
        theme.onSurface,
      ),
      body: const ServicesBody(),
    );
  }
}
