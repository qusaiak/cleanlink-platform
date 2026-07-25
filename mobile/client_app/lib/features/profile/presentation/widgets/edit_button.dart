import 'package:client_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/routes/app_router.dart';
import '../../../../config/theme/styles.dart';
import '../../../../core/session/user_session.dart';
import '../../../../injection_container.dart';

class EditButton extends StatelessWidget {
  const EditButton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () async {
        final updated = await GoRouter.of(
          context,
        ).push<bool>(AppRouter.kEditProfile);
        if (updated == true) {
          await sl<UserSession>().load();
        }
      },
      child: Icon(Icons.edit_rounded, size: 25.sp, color: theme.primary),
    );
  }
}
