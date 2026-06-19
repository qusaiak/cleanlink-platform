import 'package:flutter/material.dart';
import '../widgets/about_company_section.dart';
import '../widgets/company_header_section.dart';
import '../widgets/company_services_section.dart';
import '../widgets/company_stats_section.dart';
import '../widgets/experts_section.dart';
import '../widgets/reviews_section.dart';
import '../widgets/working_hours_section.dart';

class CompanyDetailsBody extends StatelessWidget {
  const CompanyDetailsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const CompanyHeaderSection(),

          SliverToBoxAdapter(
            child: Column(
              children: const [
                CompanyStatsSection(),
                SizedBox(height: 20),
                AboutCompanySection(),
                SizedBox(height: 20),
                WorkingHoursSection(),
                SizedBox(height: 20),
                CompanyServicesSection(),
                SizedBox(height: 20),
                ExpertsSection(),
                SizedBox(height: 20),
                ReviewsSection(),
                SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
