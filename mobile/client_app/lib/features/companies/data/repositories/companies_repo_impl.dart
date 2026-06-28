import 'package:dio/dio.dart';
import '../../../../core/network/network_exceptions.dart';
import '../../domain/entities/company_entity.dart';
import '../../domain/repositories/companies_repo.dart';
import '../data_sources/companies_api_service.dart';

class CompaniesRepoImpl implements CompaniesRepo {
  final CompaniesApiService api;

  CompaniesRepoImpl(this.api);

  @override
  Future<List<CompanyEntity>> getCompanies() async {
    try {
      final response = await api.getCompanies();
      print("RAW RESPONSE");
      print(response.data.data);
      return response.data.toEntity();
    } on DioException catch (e) {
      throw NetworkExceptions.fromDio(e);
    }
  }

  @override
  Future<CompanyEntity> getCompanyDetails(int id) async {
    try {
      final response = await api.getCompanyDetails(id);

      return response.data.data.toEntity();
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
