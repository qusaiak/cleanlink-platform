import 'package:flutter/material.dart';

import '../../../tasks/presentation/pages/tasks_page.dart';

/// The app's single main screen — the worker's daily-tasks view ([TasksPage]).
///
/// There is no bottom navigation; Profile and Settings are reached from the
/// home drawer (see `AppDrawer`).
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const TasksPage();
  }
}
