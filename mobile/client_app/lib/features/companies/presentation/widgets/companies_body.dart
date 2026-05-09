import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../home/data/models/company_model.dart';
import '../../../home/presentation/widgets/company_card.dart';

class CompaniesBody extends StatelessWidget {
  const CompaniesBody({super.key});

  @override
  Widget build(BuildContext context) {
    final companies = CompaniesData.all;

    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: companies.length,
      separatorBuilder: (_, __) => const SizedBox(height: 14),
      itemBuilder: (_, i) {
        final company = companies[i];
        return SizedBox(height: 200.w, child: CompanyCard(company: company));
      },
    );
  }
}
