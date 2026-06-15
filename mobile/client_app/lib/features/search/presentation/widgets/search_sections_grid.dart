import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/routes/app_router.dart';
import '../../../../core/utils/gen/assets.gen.dart';
import '../../../../l10n/app_localizations.dart';
import 'search_section_card.dart';

class _SectionItem {
  final String Function(AppLocalizations l10n) titleBuilder;
  final String imagePlaceholder;
  final String route;

  const _SectionItem({
    required this.titleBuilder,
    required this.imagePlaceholder,
    required this.route,
  });
}

class SearchSectionsGrid extends StatelessWidget {
  const SearchSectionsGrid({super.key});

  static final List<_SectionItem> _sections = [
    _SectionItem(
      titleBuilder: (l10n) => l10n.all_companies,
      imagePlaceholder: Assets.images.search.companies.path,
      route: AppRouter.kHome,
      // route: AppRouter.kMoviesPage,
    ),
    _SectionItem(
      titleBuilder: (l10n) => l10n.all_services,
      imagePlaceholder: Assets.images.search.services.path,
      route: AppRouter.kHome,
    ),
    _SectionItem(
      titleBuilder: (l10n) => l10n.all_categories,
      imagePlaceholder: Assets.images.search.categories.path,
      route: AppRouter.kHome,
    ),
    _SectionItem(
      titleBuilder: (l10n) => l10n.all_regions,
      imagePlaceholder: Assets.images.search.regions.path,
      route: AppRouter.kHome,
    ),
    _SectionItem(
      titleBuilder: (l10n) => l10n.all_providers,
      imagePlaceholder: Assets.images.search.providers.path,
      route: AppRouter.kHome,
    ),
    _SectionItem(
      titleBuilder: (l10n) => l10n.all_offers,
      imagePlaceholder: Assets.images.search.offers.path,
      route: AppRouter.kHome,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 11.w),
      child: Column(
        children: [
          _buildSectionCard(
            section: _sections[0],
            l10n: l10n,
            aspectRatio: 16 / 9,
            context: context,
          ),
          SizedBox(height: 12.h),
          _buildTwoSquaresRow(
            left: _sections[1],
            right: _sections[2],
            l10n: l10n,
            context: context,
          ),
          SizedBox(height: 12.h),
          _buildSectionCard(
            section: _sections[3],
            l10n: l10n,
            aspectRatio: 16 / 9,
            context: context,
          ),
          SizedBox(height: 12.h),
          _buildTwoSquaresRow(
            left: _sections[4],
            right: _sections[5],
            l10n: l10n,
            context: context,
          ),
        ],
      ),
    );
  }

  Widget _buildTwoSquaresRow({
    required _SectionItem left,
    required _SectionItem right,
    required AppLocalizations l10n,
    required BuildContext context,
  }) {
    return Row(
      children: [
        Expanded(
          child: _buildSectionCard(
            section: left,
            l10n: l10n,
            aspectRatio: 1,
            context: context,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _buildSectionCard(
            section: right,
            l10n: l10n,
            aspectRatio: 1,
            context: context,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionCard({
    required _SectionItem section,
    required AppLocalizations l10n,
    required double aspectRatio,
    required BuildContext context,
  }) {
    return AspectRatio(
      aspectRatio: aspectRatio,
      child: SearchSectionCard(
        title: section.titleBuilder(l10n),
        imagePath: section.imagePlaceholder,
        onTap: () {
          context.push(section.route);
        },
      ),
    );
  }
}
