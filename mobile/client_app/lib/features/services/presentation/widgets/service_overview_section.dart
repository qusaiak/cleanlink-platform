import 'package:client_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../config/theme/styles.dart';
import '../../../../core/widgets/row_title.dart';

class ServiceOverviewSection extends StatelessWidget {
  final String overview;
  const ServiceOverviewSection({super.key, required this.overview});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RowTitle(
          iconData: Icons.description_outlined,
          title: AppLocalizations.of(context)!.overview,
          padding: EdgeInsets.all(0),
        ),
        SizedBox(height: 12.h),
        Text(overview, maxLines: 50, style: Styles.textStyle12),
      ],
    );
  }
}
