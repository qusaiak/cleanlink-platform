import 'package:flutter/material.dart';

import '../../../../config/theme/colors.dart';
import '../../domain/entities/worker_entity.dart';

class AssignedWorkerTile extends StatelessWidget {
  final WorkerEntity? worker;

  const AssignedWorkerTile({super.key, required this.worker});

  @override
  Widget build(BuildContext context) {
    if (worker == null) {
      return Container(
        padding: const EdgeInsets.all(16),

        child: const Text("No worker assigned yet"),
      );
    }

    return ListTile(
      tileColor: AppColor.primaryColor.withOpacity(.05),

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),

      leading: CircleAvatar(child: Text(worker!.name[0])),

      title: Text(worker!.name),

      subtitle: const Text("Assigned Cleaner"),
    );
  }
}
