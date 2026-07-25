part of 'companies_bloc.dart';

sealed class CompaniesEvent {}

class GetCompaniesEvent extends CompaniesEvent {}

class GetCompanyDetailsEvent extends CompaniesEvent {
  final int id;

  GetCompanyDetailsEvent(this.id);
}

class RefreshCompanyDetailsEvent extends CompaniesEvent {
  final int id;

  RefreshCompanyDetailsEvent(this.id);
}
