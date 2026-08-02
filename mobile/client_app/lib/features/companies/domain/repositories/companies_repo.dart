import 'package:client_app/features/companies/domain/entities/company_entity.dart';
import '../../../../core/pagination/paginated_result.dart';

abstract class CompaniesRepo {
  Future<PaginatedResult<CompanyEntity>> getCompanies({
    required int page,
    required int perPage,
  });

  Future<CompanyEntity> getCompanyDetails(int id);
}
