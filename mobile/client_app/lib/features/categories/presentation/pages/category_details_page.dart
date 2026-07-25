import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection_container.dart';
import '../bloc/categories_bloc.dart';
import '../widgets/category_details_body.dart';

class CategoryDetailsPage extends StatelessWidget {
  const CategoryDetailsPage({super.key, required this.categoryId});

  final int categoryId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CategoriesBloc>(
      create: (_) => sl<CategoriesBloc>(),
      child: Scaffold(body: CategoryDetailsBody(id: categoryId)),
    );
  }
}
