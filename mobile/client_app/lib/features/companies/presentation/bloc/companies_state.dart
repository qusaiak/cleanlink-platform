part of 'companies_bloc.dart';

sealed class CompaniesState {}

class CompaniesInitial extends CompaniesState {}

class CompaniesLoading extends CompaniesState {}

class CompaniesLoaded extends CompaniesState {
  final List<CompanyEntity> companies;

  CompaniesLoaded(this.companies);
}

class CompaniesError extends CompaniesState {
  final String error;

  CompaniesError(this.error);
}

class CompanyDetailsInitial extends CompaniesState {}

class CompanyDetailsLoading extends CompaniesState {}

class CompanyDetailsSuccess extends CompaniesState {
  final CompanyEntity company;

  CompanyDetailsSuccess(this.company);
}

class CompanyDetailsError extends CompaniesState {
  final String message;

  CompanyDetailsError(this.message);
}
