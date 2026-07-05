import 'package:client_app/features/categories/presentation/widgets/category_service_card.dart';
import 'package:client_app/features/companies/data/models/company_model.dart';
import 'package:client_app/features/services/data/models/service_model.dart';
import 'package:client_app/features/home/presentation/widgets/category_item.dart';
import 'package:client_app/features/home/presentation/widgets/company_card.dart';
import 'package:client_app/features/home/presentation/widgets/offer_card.dart';
import 'package:client_app/features/home/presentation/widgets/service_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../features/regions/presentation/widgets/region_card.dart';
import '../list_item.dart';
import 'content_section_type.dart';

abstract final class ContentItemFactory {
  static Widget buildListItem(
    BuildContext context, {
    required ContentSectionType type,
    required dynamic item,
    required int index,
    VoidCallback? onTap,
  }) {
    switch (type) {
      case ContentSectionType.companies:
        return SizedBox(
          height: 200.w,
          child: CompanyCard(company: item, onTap: onTap),
        );

      case ContentSectionType.services:
        return CategoryServiceCard(service: item, onTap: onTap);

      case ContentSectionType.categories:
        return CategoryItem(category: item, number: 2, onTap: onTap);

      case ContentSectionType.regions:
        return RegionCard(region: item, onTap: onTap);

      case ContentSectionType.offers:
        return SizedBox(
          height: 180.h,
          child: OfferCard(offer: item, onTap: onTap, isActive: true),
        );
    }
  }
}
