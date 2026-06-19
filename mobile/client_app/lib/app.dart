import 'package:client_app/config/routes/app_router.dart';
import 'package:client_app/config/theme/app_themes.dart';
import 'package:client_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:client_app/features/base/presentation/bloc/base_bloc.dart';
import 'package:client_app/features/bookings/presentation/bloc/bookings_bloc.dart';
import 'package:client_app/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:client_app/injection_container.dart';
import 'package:client_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'config/theme/app_theme_info.dart';
import 'l10n/l10n.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (BuildContext context) => sl()),
        BlocProvider<BaseBloc>(create: (BuildContext context) => sl()),
        BlocProvider<ProfileBloc>(create: (BuildContext context) => sl()),
        BlocProvider<BookingsBloc>(create: (BuildContext context) => sl()),
      ],
      child: ScreenUtilInit(
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (_, child) {
          return BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              return MaterialApp.router(
                debugShowCheckedModeBanner: false,
                title: 'CleanLink',
                theme: lightTheme(),
                darkTheme: darkTheme(),
                themeMode: AppThemeInfo.isLight
                    ? ThemeMode.light
                    : ThemeMode.dark,
                locale: Locale(state.languageCode),
                supportedLocales: L10n.all,
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                routerConfig: AppRouter.router,
              );
            },
          );
        },
      ),
    );
  }
}
