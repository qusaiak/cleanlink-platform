import 'package:flutter/material.dart';

import '../../../../core/widgets/custom_appbar.dart';
import '../../../../l10n/app_localizations.dart';
import '../widgets/help_center_body.dart';

class HelpCenterPage extends StatelessWidget {
  const HelpCenterPage({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context)!.colorScheme;
    return Scaffold(
      appBar: customAppBar(
        AppLocalizations.of(context)!.help_center_title,
        null,
        [],
        () {},
        theme.onSurface,
      ),
      body: const HelpCenterBody(),
    );
  }
}
