import 'package:client_app/core/utils/functions/spinkit.dart';
import 'package:client_app/features/companies/presentation/bloc/companies_bloc.dart';
import 'package:client_app/features/home/presentation/widgets/company_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/routes/app_router.dart';
import '../../../../core/widgets/custom_list_section.dart';
import '../../../../l10n/app_localizations.dart';

class CompaniesBody extends StatefulWidget {
  const CompaniesBody({super.key});

  @override
  State<CompaniesBody> createState() => _CompaniesBodyState();
}

class _CompaniesBodyState extends State<CompaniesBody> {
  @override
  void initState() {
    super.initState();

    context.read<CompaniesBloc>().add(GetCompaniesEvent());
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;
    return BlocBuilder<CompaniesBloc, CompaniesState>(
      buildWhen: (_, current) =>
          current is CompaniesLoading ||
          current is CompaniesLoaded ||
          current is CompaniesError,
      builder: (context, state) {
        if (state is CompaniesLoading) {
          return Center(child: spinKitApp(theme.primary));
        }

        if (state is CompaniesError) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.error_outline, size: 42.sp),

                  SizedBox(height: 10.h),

                  Text(state.error, textAlign: TextAlign.center),

                  SizedBox(height: 16.h),

                  ElevatedButton(
                    onPressed: () {
                      context.read<CompaniesBloc>().add(GetCompaniesEvent());
                    },
                    child: Text(AppLocalizations.of(context)!.retry),
                  ),
                ],
              ),
            ),
          );
        }

        if (state is CompaniesLoaded) {
          final companies = state.companies;

          if (companies.isEmpty) {
            return const Center(child: Text('No companies found'));
          }

          return CustomListSection(
            isVertical: true,
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemExtent: 200.w,
            itemCount: companies.length,
            separator: SizedBox(height: 14.h),
            padding: EdgeInsets.symmetric(horizontal: 8.h, vertical: 4.h),
            itemBuilder: (_, index) {
              final company = companies[index];

              return SizedBox(
                height: 200.w,
                child: CompanyCard(
                  company: company,
                  onTap: () {
                    GoRouter.of(
                      context,
                    ).push(AppRouter.kCompanyDetails, extra: company.id);
                  },
                ),
              );
            },
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
