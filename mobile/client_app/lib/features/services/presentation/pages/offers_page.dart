import 'package:flutter/material.dart';
import '../../../../core/widgets/custom_appbar.dart';
import '../../../../l10n/app_localizations.dart';
import '../widgets/offers_body.dart';

class OffersPage extends StatelessWidget {
  const OffersPage({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: customAppBar(
        AppLocalizations.of(context)!.all_offers,
        null,
        [],
        () {},
        theme.onSurface,
      ),
      body: const OffersBody(),
    );
  }
}
