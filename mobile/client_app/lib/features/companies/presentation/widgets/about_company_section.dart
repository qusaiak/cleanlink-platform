import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/constants/constants.dart';
import '../../../../config/theme/styles.dart';
import '../../../../core/widgets/row_title.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/company_entity.dart';

class AboutCompanySection extends StatefulWidget {
  final CompanyEntity company;

  const AboutCompanySection({super.key, required this.company});

  @override
  State<AboutCompanySection> createState() => _AboutCompanySectionState();
}

class _AboutCompanySectionState extends State<AboutCompanySection> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context)!.colorScheme;
    return Column(
      children: [
        RowTitle(
          iconData: Icons.info_outline,
          title: AppLocalizations.of(context)!.about_us,
        ),

        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.company.description,
                maxLines: 2,
                style: Styles.textStyle12.copyWith(
                  color: theme.onSurfaceVariant,
                ),
              ),
              // state.artist!.biography!.isNotEmpty &&
              //         state.artist!.biography!.length > 100
              //     ?
              GestureDetector(
                child: Text(
                  AppLocalizations.of(context)!.show_more,
                  style: Styles.textStyle11.copyWith(
                    color: theme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: theme.surface,
                    useSafeArea: true,
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20.r),
                      ),
                    ),
                    builder: (context) {
                      return Padding(
                        padding: EdgeInsets.all(16.w),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Container(
                                  width: 40.w,
                                  height: 3.w,
                                  margin: EdgeInsets.only(bottom: 16.h),
                                  decoration: BoxDecoration(
                                    color: theme.onSurface,
                                    borderRadius: BorderRadius.circular(4.r),
                                  ),
                                ),
                              ),
                              Text(
                                AppLocalizations.of(context)!.about_us,
                                style: Styles.textStyle14.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: theme.onSurface,
                                ),
                              ),
                              SizedBox(height: 16.h),
                              Text(
                                widget.company.description,
                                maxLines: 10000,
                                style: Styles.textStyle12.copyWith(
                                  color: theme.onSurfaceVariant,
                                ),
                              ),
                              SizedBox(
                                height:
                                    Constants.bottomNavigationBarHeight +
                                    Constants.kMiniPlayerHeight.w +
                                    16.w,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
              // : const SizedBox()
            ],
          ),
        ),
      ],
    );
  }
}
