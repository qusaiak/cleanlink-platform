import 'package:client_app/core/utils/functions/spinkit.dart';
import 'package:client_app/core/widgets/custom_image_view.dart';
import 'package:client_app/features/services/presentation/bloc/services_bloc.dart';
import 'package:client_app/features/services/presentation/widgets/service_booking_bar.dart';
import 'package:client_app/features/services/presentation/widgets/service_summary_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../bookings/presentation/pages/booking_details_page.dart';
import '../../../reviews/domain/entities/reviewable_type.dart';
import '../../../reviews/presentation/widgets/review_dialog.dart';

class ServiceDetailsBody extends StatefulWidget {
  final int id;

  const ServiceDetailsBody({super.key, required this.id});

  @override
  State<ServiceDetailsBody> createState() => _ServiceDetailsBodyState();
}

class _ServiceDetailsBodyState extends State<ServiceDetailsBody> {
  @override
  void initState() {
    super.initState();
    context.read<ServicesBloc>().add(GetServiceDetailsEvent(widget.id));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return BlocBuilder<ServicesBloc, ServicesState>(
      builder: (context, state) {
        if (state is ServiceDetailsLoading) {
          return Center(child: spinKitApp(theme.primary));
        }

        if (state is ServiceDetailsError) {
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
                      context.read<ServicesBloc>().add(
                        GetServiceDetailsEvent(widget.id),
                      );
                    },
                    child: Text(AppLocalizations.of(context)!.retry),
                  ),
                ],
              ),
            ),
          );
        }

        if (state is ServiceDetailsLoaded) {
          final service = state.service;

          final package = state.selectedPackage;

          return Scaffold(
            bottomNavigationBar: package == null
                ? null
                : ServiceBookingBar(
                    packageName: package.name,
                    price: package.price,
                    priceAfterDiscount: package.priceAfterDiscount,
                    onBook: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BookingDetailsPage(package: package),
                        ),
                      );
                    },
                  ),
            body: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          SizedBox(
                            height: 300.h,
                            width: double.infinity,
                            child: CustomImageView(
                              imagePath: service.image,
                              fit: BoxFit.cover,
                            ),
                          ),

                          Positioned(
                            top: 40.h,
                            left: 16.w,
                            child: BackButton(color: theme.onSurface),
                          ),
                        ],
                      ),

                      Transform.translate(
                        offset: Offset(0, -70.h),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.w),
                          child: ServiceSummaryCard(
                            service: service,
                            onAddReview: () => showReviewDialog(
                              context: context,
                              type: ReviewableType.service,
                              id: service.id,
                              onSuccess: () => context.read<ServicesBloc>().add(
                                RefreshServiceDetailsEvent(service.id),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
