import 'package:client_app/features/companies/data/models/company_model.dart';
import 'package:client_app/features/services/data/models/service_model.dart';
import 'package:client_app/features/home/presentation/widgets/category_item.dart';
import 'package:client_app/features/home/presentation/widgets/company_card.dart';
import 'package:client_app/features/home/presentation/widgets/offer_card.dart';
import 'package:client_app/features/home/presentation/widgets/service_tile.dart';
import 'package:flutter/material.dart';
import '../list_item.dart';
import 'content_section_type.dart';

abstract final class ContentItemFactory {
  static Widget build({
    required ContentSectionType type,
    required String imagePath,
    required int index,
    double? itemWidth,
    VoidCallback? onTap,
  }) {
    switch (type) {
      // case ContentSectionType.companies:
      //   return CompanyCard(
      //     company: CompanyModel(
      //       name: 'Company ${index + 1}',
      //       image: imagePath,
      //       location: "Syria",
      //       rating: 2.5,
      //     ),
      //   );
      // case ContentSectionType.services:
      //   return ServiceTile(
      //     service: ServiceModel(
      //       title: 'Service ${index + 1}',
      //       image: imagePath,
      //       company: "Space",
      //       duration: "2 hours",
      //       price: "\$25",
      //     ),
      //   );
      // case ContentSectionType.categories:
      //   return CategoryItem(
      //     title: 'Category ${index + 1}',
      //     iconData: ProgramEntity(
      //       title: 'Program ${index + 1}',
      //       cover: imagePath,
      //       year: 2023,
      //       rating: 6.9,
      //       tags: ['Entertainment', 'Educational', 'Reality'],
      //     ),
      //   );
      // case ContentSectionType.regions:
      //   return ChannelItem(
      //     imagePath: imagePath,
      //     title: 'Channel ${index + 1}',
      //     isLive: true,
      //     itemWidth: itemWidth,
      //     onTap: onTap,
      //   );
      // case ContentSectionType.providers:
      //   return ClipItem(
      //     imagePath: imagePath,
      //     title: 'Clip ${index + 1}',
      //     duration: '1:45',
      //     onTap: onTap,
      //   );
      // case ContentSectionType.offers:
      //   return ClipListItem(
      //     imagePath: imagePath,
      //     title: 'Offer ${index + 1}',
      //     description: 'Special offer description goes here.',
      //     onTap: onTap,
      //   );
      case ContentSectionType.companies:
      // TODO: Handle this case.
        throw UnimplementedError();
      case ContentSectionType.services:
        // TODO: Handle this case.
        throw UnimplementedError();
      case ContentSectionType.categories:
      // TODO: Handle this case.
        throw UnimplementedError();
      case ContentSectionType.regions:
        // TODO: Handle this case.
        throw UnimplementedError();
      case ContentSectionType.providers:
        // TODO: Handle this case.
        throw UnimplementedError();
      case ContentSectionType.offers:
        // TODO: Handle this case.
        throw UnimplementedError();
    }
  }

  static Widget buildListItem(
      BuildContext context, {
        required ContentSectionType type,
        required dynamic item,
        required int index,
        VoidCallback? onTap,
      }) {
    switch (type) {
      case ContentSectionType.companies:
        return CompanyCard(
          company: item,
          onTap: onTap,
        );

      case ContentSectionType.services:
        return CompanyCard(
          company: item,
          onTap: onTap,
        );

      case ContentSectionType.categories:
        return CompanyCard(
          company: item,
          onTap: onTap,
        );
      case ContentSectionType.regions:
        return CompanyCard(
          company: item,
          onTap: onTap,
        );
      case ContentSectionType.providers:
        return CompanyCard(
          company: item,
          onTap: onTap,
        );
      case ContentSectionType.offers:
        return CompanyCard(
          company: item,
          onTap: onTap,
        );
    }
  }
}
