import 'package:client_app/features/services/presentation/bloc/services_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/routes/app_router.dart';
import '../../../../core/utils/functions/spinkit.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../categories/presentation/widgets/category_service_card.dart';

class ServicesBody extends StatefulWidget {
  const ServicesBody({super.key});

  @override
  State<ServicesBody> createState() => _ServicesBodyState();
}

class _ServicesBodyState extends State<ServicesBody> {
  @override
  void initState() {
    super.initState();

    context.read<ServicesBloc>().add(GetServicesEvent());
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;
    return BlocBuilder<ServicesBloc, ServicesState>(
      buildWhen: (_, current) =>
          current is ServicesLoading ||
          current is ServicesLoaded ||
          current is ServicesError,

      builder: (context, state) {
        if (state is ServicesLoading) {
          return Center(child: spinKitApp(theme.primary));
        }

        if (state is ServicesError) {
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
                      context.read<ServicesBloc>().add(GetServicesEvent());
                    },
                    child: Text(AppLocalizations.of(context)!.retry),
                  ),
                ],
              ),
            ),
          );
        }
        if (state is ServicesLoaded) {
          final services = state.services;

          if (services.isEmpty) {
            return Center(
              child: AppEmptyState(
                icon: Icons.cleaning_services_outlined,
                title: AppLocalizations.of(context)!.no_services_available,
              ),
            );
          }
          return ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.w),
            itemCount: services.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (_, index) {
              return CategoryServiceCard(
                service: services[index],
                onTap: () {
                  GoRouter.of(
                    context,
                  ).push(AppRouter.kServiceDetails, extra: services[index].id);
                },
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
