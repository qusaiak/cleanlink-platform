import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/functions/spinkit.dart';
import '../../../../core/utils/content_validation.dart';
import '../../../../core/widgets/app_error_state.dart';
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
            return AppErrorState(
              failure: state.failure,
              onRetry: () => context.read<CompaniesBloc>().add(
                GetCompanyDetailsEvent(widget.id),
              ),
            );
          }
          if (state is CompanyDetailsSuccess) {
            final company = state.company;
            final hasAbout = ContentValidation.hasText(company.description);
            final hasHours = company.workTimes.isNotEmpty;
            final services = ContentValidation.validItems(
              company.services,
              (service) =>
                  service.id > 0 && ContentValidation.hasText(service.name),
            );
            final workers = company.workers;
            final reviews = company.reviews;

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

                      if (hasAbout) ...[
                        SizedBox(height: 20.h),
                        AboutCompanySection(company: company),
                      ],
                      if (hasHours) ...[
                        SizedBox(height: 20.h),
                        WorkingHoursSection(company: company),
                      ],
                      if (services.isNotEmpty) ...[
                        SizedBox(height: 20.h),
                        CompanyServicesSection(services: services),
                      ],
                      if (workers.isNotEmpty) ...[
                        SizedBox(height: 20.h),
                        ExpertsSection(company: company),
                      ],
                      if (reviews.isNotEmpty) ...[
                        SizedBox(height: 20.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: ReviewsSection(reviews: reviews),
                        ),
                      ],
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
