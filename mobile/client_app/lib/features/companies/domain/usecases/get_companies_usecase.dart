import '../entities/company_entity.dart';
import '../repositories/companies_repo.dart';

class GetCompaniesUseCase {
  final CompaniesRepo repo;

  GetCompaniesUseCase(this.repo);

  Future<List<CompanyEntity>> call() {
    return repo.getCompanies();
  }
}
