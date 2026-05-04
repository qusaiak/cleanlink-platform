import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/widgets/custom_appbar.dart';
import '../../../../l10n/app_localizations.dart';
import '../widgets/profile_body.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: customAppBar(
          AppLocalizations.of(context)!.my_profile,
          null,
          [
            GestureDetector(
              onTap: () {
                // TODO: logout
              },
              child: Padding(
                padding: EdgeInsets.all(5.w),
                child: Row(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.logout,
                      style: TextStyle(fontSize: 13.sp, color: theme.onSurface),
                    ),
                    SizedBox(width: 5.w),
                    Icon(Icons.logout_outlined, size: 16),
                  ],
                ),
              ),
            ),
          ],
          () {},
          theme.onSurface,
        ),
        body: ProfileBody(),
      ),
    );
  }
}
