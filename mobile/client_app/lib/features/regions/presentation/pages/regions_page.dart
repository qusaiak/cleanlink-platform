import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/custom_appbar.dart';
import '../../../../injection_container.dart';
import '../../../../l10n/app_localizations.dart';
import '../bloc/regions_bloc.dart';
import '../widgets/regions_body.dart';

class RegionsPage extends StatelessWidget {
  const RegionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return BlocProvider<RegionsBloc>(
      create: (_) => sl<RegionsBloc>(),
      child: Scaffold(
        appBar: customAppBar(
          AppLocalizations.of(context)!.all_regions,
          null,
          [],
          () {},
          theme.onSurface,
        ),
        body: const RegionsBody(),
      ),
    );
  }
}
