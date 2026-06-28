import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/routes/app_router.dart';
import '../../../../core/widgets/content/content_horizontal_list.dart';
import '../../../../core/widgets/content/content_mock_data.dart';
import '../../../../core/widgets/content/content_section.dart';
import '../../../../core/widgets/content/content_section_type.dart';
import '../../../../core/widgets/content/content_view.dart';
import '../../../../core/widgets/custom_list_section.dart';
import '../../../../core/widgets/dummy_data.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../companies/data/models/company_model.dart';
import '../../../../core/utils/gen/assets.gen.dart';
import '../../../companies/domain/entities/company_entity.dart';
import 'company_card.dart';

class CompaniesSection extends StatelessWidget {
  final List<CompanyEntity> companies;
  const CompaniesSection({super.key, required this.companies});

  @override
  Widget build(BuildContext context) {
    // final companies = CompaniesData.all.take(3).toList();
    return CustomListSection(
      title: AppLocalizations.of(context)!.popular_companies,
      onTitleTap: () {
        GoRouter.of(context).push(AppRouter.kCompanies);
      },
      itemExtent: 200.w,
      itemCount: companies.length,
      iconData: Icons.business,
      itemBuilder: (context, index) => CompanyCard(
        company: companies[index],
        onTap: () {
          GoRouter.of(context).push(AppRouter.kCompanyDetails, extra: companies[index].id);
        },
      ),
    );
  }
}
