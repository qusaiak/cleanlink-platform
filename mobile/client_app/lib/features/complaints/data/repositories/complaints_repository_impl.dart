import 'package:dio/dio.dart';

import '../../../../core/network/network_exceptions.dart';
import '../../domain/entities/complaint_entity.dart';
import '../../domain/repositories/complaints_repository.dart';
import '../data_sources/complaints_api_service.dart';

class ComplaintsRepositoryImpl implements ComplaintsRepository {
  ComplaintsRepositoryImpl(this.api);
  final ComplaintsApiService api;

  @override
  Future<ComplaintsCollectionEntity> getComplaints() async {
    try {
      return (await api.getComplaints()).data.collection;
    } on DioException catch (error) {
      throw NetworkExceptions.fromDio(error);
    }
  }

  @override
  Future<ComplaintEntity> getComplaintDetails(int id) async {
    try {
      return (await api.getComplaintDetails(id)).data.complaint;
    } on DioException catch (error) {
      throw NetworkExceptions.fromDio(error);
    }
  }

  @override
  Future<ComplaintEntity> createComplaint({
    required ComplaintType type,
    required int id,
    required String title,
    required String body,
  }) async {
    try {
      return (await api.createComplaint({
        'type': type.name,
        'id': id,
        'title': title.trim(),
        'body': body.trim(),
      })).data.complaint;
    } on DioException catch (error) {
      throw NetworkExceptions.fromDio(error);
    }
  }

  @override
  Future<int> getUnreadCount() async {
    try {
      return (await api.getUnreadCount()).data.count;
    } on DioException catch (error) {
      throw NetworkExceptions.fromDio(error);
    }
  }

  @override
  Future<ComplaintEntity> markAsRead(int id) async {
    try {
      return (await api.markAsRead(id)).data.complaint;
    } on DioException catch (error) {
      throw NetworkExceptions.fromDio(error);
    }
  }
}
