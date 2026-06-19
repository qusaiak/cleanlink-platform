import 'package:flutter/material.dart';

import '../../../../core/widgets/custom_appbar.dart';
import '../../../../l10n/app_localizations.dart';
import '../widgets/contact_us_body.dart';

class ContactUsPage extends StatelessWidget {
  const ContactUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context)!.colorScheme;
    return Scaffold(
      appBar: customAppBar(
        AppLocalizations.of(context)!.contact_us,
        null,
        [],
            () {},
        theme.onSurface,
      ),
      body: const ContactUsBody(),
    );
  }
}

