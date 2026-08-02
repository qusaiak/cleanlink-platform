part of 'companies_bloc.dart';

sealed class CompaniesEvent extends Equatable {
  const CompaniesEvent();

  @override
  List<Object?> get props => const [];
}

class GetCompaniesEvent extends CompaniesEvent {
  const GetCompaniesEvent({this.refresh = false, this.completer});

  final bool refresh;
  final Completer<void>? completer;

  @override
  List<Object?> get props => [refresh];
}

class GetMoreCompaniesEvent extends CompaniesEvent {
  const GetMoreCompaniesEvent({this.retry = false});

  final bool retry;

  @override
  List<Object?> get props => [retry];
}

class GetCompanyDetailsEvent extends CompaniesEvent {
  final int id;

  const GetCompanyDetailsEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class RefreshCompanyDetailsEvent extends CompaniesEvent {
  final int id;

  const RefreshCompanyDetailsEvent(this.id);

  @override
  List<Object?> get props => [id];
}
