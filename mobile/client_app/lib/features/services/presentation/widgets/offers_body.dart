import 'package:client_app/features/home/presentation/widgets/offer_card.dart';
import 'package:client_app/features/services/presentation/bloc/services_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/routes/app_router.dart';
import '../../../../core/utils/functions/spinkit.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../l10n/app_localizations.dart';

class OffersBody extends StatefulWidget {
  const OffersBody({super.key});

  @override
  State<OffersBody> createState() => _OffersBodyState();
}

class _OffersBodyState extends State<OffersBody> {
  @override
  void initState() {
    super.initState();

    context.read<ServicesBloc>().add(GetOffersEvent());
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;
    return BlocBuilder<ServicesBloc, ServicesState>(
      buildWhen: (_, current) =>
          current is OffersLoading ||
          current is OffersLoaded ||
          current is OffersError,

      builder: (context, state) {
        if (state is OffersLoading) {
          return Center(child: spinKitApp(theme.primary));
        }

        if (state is OffersError) {
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
                      context.read<ServicesBloc>().add(GetOffersEvent());
                    },
                    child: Text(AppLocalizations.of(context)!.retry),
                  ),
                ],
              ),
            ),
          );
        }
        if (state is OffersLoaded) {
          final offers = state.offers;

          if (offers.isEmpty) {
            return Center(
              child: AppEmptyState(
                icon: Icons.local_offer_outlined,
                title: AppLocalizations.of(context)!.no_offers_found,
              ),
            );
          }
          return ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.w),
            itemCount: offers.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (_, index) {
              return SizedBox(
                height: 180.h,
                child: OfferCard(
                  offer: offers[index],
                  isActive: true,
                  onTap: () {
                    GoRouter.of(
                      context,
                    ).push(AppRouter.kServiceDetails, extra: offers[index].id);
                  },
                ),
              );
              //   ServiceTile(
              //   service: services[i],
              //   onTap: () {
              //     GoRouter.of(
              //       context,
              //     ).push(AppRouter.kServiceDetails, extra: services[i].id);
              //   },
              // );
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
