import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection_container.dart';
import '../bloc/regions_bloc.dart';
import '../widgets/region_body.dart';

class RegionPage extends StatelessWidget {
  const RegionPage({super.key, required this.regionId});

  final int regionId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RegionsBloc>(
      create: (_) => sl<RegionsBloc>(),
      child: Scaffold(body: RegionBody(id: regionId)),
    );
  }
}
