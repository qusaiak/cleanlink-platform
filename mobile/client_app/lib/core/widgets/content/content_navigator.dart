import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/routes/app_router.dart';
import 'content_section.dart';
import 'content_section_type.dart';

abstract final class ContentNavigator {
  static void openItemDetails(
    BuildContext context, {

    required ContentSectionType type,

    required int id,
  }) {
    context.push(_detailsBasePath(type), extra: id);
  }

  static void openSection(BuildContext context, ContentSection section) {
    context.push("/${section.type.name}");
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

      case ContentSectionType.offers:
        return AppRouter.kOfferDetails;
    }
  }
}
