import 'dart:async';

import 'package:flutter/material.dart';
import '../../../../core/utils/gen/assets.gen.dart';
import '../../data/models/task_model.dart';
import 'task_card.dart';

class TasksSection extends StatefulWidget {
  const TasksSection({super.key});

  @override
  State<TasksSection> createState() => _TasksSectionState();
}

class _TasksSectionState extends State<TasksSection> {
  final PageController _controller = PageController(viewportFraction: 0.85);
  int _current = 0;
  Timer? _timer;

  final List<TaskModel> tasks = [
    TaskModel(
      title: "50% Off Deep Cleaning",
      subtitle: "First booking discount",
      image: Assets.images.test.test.path,
    ),
    TaskModel(
      title: "School Cleaning Experts",
      subtitle: "Trusted professionals",
      image: Assets.images.test.test.path,
    ),
    TaskModel(
      title: "Fast Booking in 10 second",
      subtitle: "Book in seconds",
      image: Assets.images.test.test.path,
    ),
  ];

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted) return;

      _current = (_current + 1) % tasks.length;

      _controller.animateToPage(
        _current,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: PageView.builder(
        controller: _controller,
        itemCount: tasks.length,
        onPageChanged: (i) => setState(() => _current = i),
        itemBuilder: (_, i) {
          final task = tasks[i];

          return AnimatedScale(
            duration: const Duration(milliseconds: 300),
            scale: _current == i ? 1 : 0.92,
            child: TaskCard(task: task),
          );
        },
      ),
    );
  }
}
