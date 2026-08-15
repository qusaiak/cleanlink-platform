
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../config/routes/app_router.dart';
import '../../config/theme/styles.dart';
import '../../l10n/app_localizations.dart';

class CustomConnectionTimeout extends StatelessWidget {
  const CustomConnectionTimeout({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;
    return Scaffold(
      body: Center(
        child: ListView(
          shrinkWrap: true,
          children: [
            Icon(Icons.timer_off_outlined, size: 80, color: theme.primary),
            SizedBox(height: 20),
            Center(
              child: Text(
                AppLocalizations.of(context)!.error_connection_timeout,
                style: Styles.textStyle14.copyWith(
                  color: theme.onSurfaceVariant,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () {
                GoRouter.of(context).go(AppRouter.kHome);
              },
              child: Text(
                AppLocalizations.of(context)!.retry,
                style: Styles.textStyle12.copyWith(
                  color: theme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
