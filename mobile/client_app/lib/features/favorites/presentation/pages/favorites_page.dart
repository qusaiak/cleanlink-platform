import 'package:client_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/favorites_bloc.dart';
import '../widgets/favorites_body.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage>
    with SingleTickerProviderStateMixin {
  late final TabController controller;

  @override
  void initState() {
    super.initState();

    controller = TabController(length: 2, vsync: this);

    context.read<FavoritesBloc>().add(GetFavoritesEvent());
  }

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.favorites),

        bottom: TabBar(
          controller: controller,

          dividerHeight: 0,

          indicatorSize: TabBarIndicatorSize.tab,

          tabs: [
            Tab(text: AppLocalizations.of(context)!.services_title),

            Tab(text: AppLocalizations.of(context)!.companies_title),
          ],
        ),
      ),

      body: FavoritesBody(controller: controller),
    );
  }
}
