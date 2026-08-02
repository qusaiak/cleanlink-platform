import 'package:client_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/functions/spinkit.dart';
import '../../../reviews/domain/entities/reviewable_type.dart';
import '../../../reviews/presentation/widgets/review_dialog.dart';
import '../../../complaints/domain/entities/complaint_entity.dart';
import '../../../complaints/presentation/widgets/complaint_form_sheet.dart';
import '../bloc/companies_bloc.dart';
import '../widgets/about_company_section.dart';
import '../widgets/company_header_section.dart';
import '../widgets/company_services_section.dart';
import '../widgets/company_stats_section.dart';
import '../widgets/experts_section.dart';
import '../widgets/reviews_section.dart';
import '../widgets/working_hours_section.dart';

class CompanyDetailsBody extends StatefulWidget {
  final int id;

  const CompanyDetailsBody({super.key, required this.id});

  @override
  State<CompanyDetailsBody> createState() => _CompanyDetailsBodyState();
}

class _CompanyDetailsBodyState extends State<CompanyDetailsBody> {
  @override
  void initState() {
    super.initState();
    context.read<CompaniesBloc>().add(GetCompanyDetailsEvent(widget.id));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return Scaffold(
      body: BlocBuilder<CompaniesBloc, CompaniesState>(
        builder: (context, state) {
          if (state is CompanyDetailsLoading) {
            return Center(child: spinKitApp(theme.primary));
          }

          if (state is CompanyDetailsError) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(20.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.error_outline, size: 42.sp),

                    SizedBox(height: 10.h),

                    Text(state.message, textAlign: TextAlign.center),

                    SizedBox(height: 16.h),

                    ElevatedButton(
                      onPressed: () {
                        context.read<CompaniesBloc>().add(
                          GetCompanyDetailsEvent(widget.id),
                        );
                      },
                      child: Text(AppLocalizations.of(context)!.retry),
                    ),
                  ],
                ),
              ),
            );
          }
          if (state is CompanyDetailsSuccess) {
            final company = state.company;

            return CustomScrollView(
              slivers: [
                CompanyHeaderSection(company: company),

                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      CompanyStatsSection(
                        company: company,
                        onAddReview: () => showFeedbackActions(
                          context: context,
                          complaintType: ComplaintType.company,
                          targetId: company.id,
                          targetName: company.name,
                          onReview: () => showReviewDialog(
                            context: context,
                            type: ReviewableType.company,
                            id: company.id,
                            onSuccess: () => context.read<CompaniesBloc>().add(
                              RefreshCompanyDetailsEvent(company.id),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 20.h),

                      AboutCompanySection(company: company),

                      SizedBox(height: 20.h),

                      WorkingHoursSection(company: company),

                      SizedBox(height: 20.h),

                      CompanyServicesSection(services: company.services),

                      SizedBox(height: 20.h),

                      ExpertsSection(company: company),

                      SizedBox(height: 20.h),

                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: ReviewsSection(reviews: company.reviews),
                      ),
                      SizedBox(height: 30),
                    ],
                  ),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
