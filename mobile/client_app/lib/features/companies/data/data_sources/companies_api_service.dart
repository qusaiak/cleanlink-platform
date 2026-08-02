import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../../../config/constants/api_endpoints.dart';
import '../models/company_details_response_model.dart';
import '../models/company_response_model.dart';

part 'companies_api_service.g.dart';

@RestApi()
abstract class CompaniesApiService {
  factory CompaniesApiService(Dio dio, {String baseUrl}) = _CompaniesApiService;

  @GET(ApiEndpoints.companiesEndpoint)
  Future<HttpResponse<CompanyResponseModel>> getCompanies({
    @Query('page') required int page,
    @Query('per_page') required int perPage,
  });

  @GET("${ApiEndpoints.companiesEndpoint}/{id}")
  Future<HttpResponse<CompanyDetailsResponseModel>> getCompanyDetails(
    @Path("id") int id,
  );
}
