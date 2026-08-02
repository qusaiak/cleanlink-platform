import '../entities/company_entity.dart';
import '../repositories/companies_repo.dart';
import '../../../../core/pagination/paginated_result.dart';

class GetCompaniesUseCase {
  final CompaniesRepo repo;

  GetCompaniesUseCase(this.repo);

  Future<PaginatedResult<CompanyEntity>> call({
    required int page,
    required int perPage,
  }) {
    return repo.getCompanies(page: page, perPage: perPage);
  }
}
