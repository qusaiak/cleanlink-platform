import 'package:flutter/material.dart';
import '../widgets/service_details_body.dart';


class ServiceDetailsPage extends StatelessWidget {
  final int id;

  const ServiceDetailsPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: ServiceDetailsBody(id: id,));
  }
}
