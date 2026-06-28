import 'package:client_app/features/companies/domain/entities/company_entity.dart';

abstract class CompaniesRepo {
  Future<List<CompanyEntity>> getCompanies();

  Future<CompanyEntity> getCompanyDetails(int id);
}
