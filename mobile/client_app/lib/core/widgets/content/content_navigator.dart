import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/routes/app_router.dart';
import 'content_section.dart';
import 'content_section_type.dart';

abstract final class ContentNavigator {
  static void openItemDetails(
    BuildContext context, {
    required ContentSectionType type,
    required int index,
  }) {
    final id = index + 1;
    final base = _detailsBasePath(type);
    context.push('$base/$id');
  }

  static void openSection(BuildContext context, ContentSection section) {
    context.push('${AppRouter.kAppContentPage}/${section.type.name}/${section.id}');
  }

  static String _detailsBasePath(ContentSectionType type) {
    switch (type) {
      case ContentSectionType.companies:
        return AppRouter.kCompanyDetails;
      case ContentSectionType.services:
        return AppRouter.kServiceDetails;
      case ContentSectionType.categories:
        return AppRouter.kCategoryDetails;
      case ContentSectionType.regions:
        return AppRouter.kRegionDetails;
      case ContentSectionType.providers:
        return AppRouter.kProviderDetails;
      case ContentSectionType.offers:
        return AppRouter.kOfferDetails;
    }
  }
}
