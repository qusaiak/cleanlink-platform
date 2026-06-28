import '../entities/company_entity.dart';
import '../repositories/companies_repo.dart';

class GetCompanyDetailsUseCase {
  final CompaniesRepo repo;

  GetCompanyDetailsUseCase(this.repo);

  Future<CompanyEntity> call(int id) {
    return repo.getCompanyDetails(id);
  }
}
