import 'package:client_app/features/companies/presentation/widgets/company_details_body.dart';
import 'package:flutter/material.dart';

class CompanyDetailsPage extends StatelessWidget {
  final int id;

  const CompanyDetailsPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: CompanyDetailsBody(id: id));
  }
}
