import 'package:equatable/equatable.dart';

import '../../../companies/domain/entities/company_entity.dart';
import '../../../services/domain/entities/service_entity.dart';

class MyReviewEntity extends Equatable {
  final int id;
  final int clientId;
  final String? comment;
  final int rating;
  final int reviewableId;
  final String reviewableType;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final CompanyEntity? company;
  final ServiceEntity? service;

  const MyReviewEntity({
    required this.id,
    required this.clientId,
    required this.rating,
    required this.reviewableId,
    required this.reviewableType,
    required this.createdAt,
    required this.updatedAt,
    this.comment,
    this.company,
    this.service,
  });

  @override
  List<Object?> get props => [
    id,
    clientId,
    comment,
    rating,
    reviewableId,
    reviewableType,
    createdAt,
    updatedAt,
    company,
    service,
  ];
}

class MyReviewsEntity extends Equatable {
  final List<MyReviewEntity> companies;
  final List<MyReviewEntity> services;

  const MyReviewsEntity({this.companies = const [], this.services = const []});

  @override
  List<Object?> get props => [companies, services];
}
