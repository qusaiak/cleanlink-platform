import 'package:flutter/material.dart';
import '../entities/search_entity.dart';

abstract class SearchRepo {
  Future<SearchEntity> search({
    required String query,
    int? regionId,
    String? priceRange,
    double? rate,
  });
}
