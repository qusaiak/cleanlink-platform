import 'package:dio/dio.dart';
import '../../../../core/network/network_exceptions.dart';
import '../../../../core/pagination/paginated_result.dart';
import '../../domain/entities/company_entity.dart';
import '../../domain/repositories/companies_repo.dart';
import '../data_sources/companies_api_service.dart';

class CompaniesRepoImpl implements CompaniesRepo {
  final CompaniesApiService api;

  CompaniesRepoImpl(this.api);

  @override
  Future<PaginatedResult<CompanyEntity>> getCompanies({
    required int page,
    required int perPage,
  }) async {
    try {
      final response = await api.getCompanies(page: page, perPage: perPage);
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
