import 'package:flutter/cupertino.dart';
import '../../../home/data/models/service_model.dart';
import '../../../home/presentation/widgets/service_tile.dart';

class ServicesBody extends StatelessWidget {
  const ServicesBody({super.key});

  @override
  Widget build(BuildContext context) {
    final services = ServicesData.all;

    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: services.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, i) {
        return ServiceTile(service: services[i]);
      },
    );
  }
}