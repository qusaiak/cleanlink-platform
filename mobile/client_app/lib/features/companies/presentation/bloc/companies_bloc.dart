import 'package:bloc/bloc.dart';
import 'package:client_app/features/companies/domain/usecases/get_company_details_use_case.dart';

import '../../domain/entities/company_entity.dart';
import '../../domain/usecases/get_companies_usecase.dart';

part 'companies_event.dart';
part 'companies_state.dart';

class CompaniesBloc extends Bloc<CompaniesEvent, CompaniesState> {
  final GetCompaniesUseCase useCase;
  final GetCompanyDetailsUseCase companyDetailsUseCase;

  CompaniesBloc(this.useCase, this.companyDetailsUseCase)
    : super(CompaniesInitial()) {
    on<GetCompaniesEvent>(_onGetCompanies);
    on<GetCompanyDetailsEvent>(_onGetCompanyDetails);
  }

  Future<void> _onGetCompanies(
    GetCompaniesEvent event,

    Emitter<CompaniesState> emit,
  ) async {
    emit(CompaniesLoading());

    try {
      final companies = await useCase();

      emit(CompaniesLoaded(companies));
    } catch (e) {
      emit(CompaniesError(e.toString()));
    }
  }

  Future<void> _onGetCompanyDetails(
    GetCompanyDetailsEvent event,
    Emitter emit,
  ) async {
    emit(CompanyDetailsLoading());

    try {
      final result = await companyDetailsUseCase(event.id);

      emit(CompanyDetailsSuccess(result));
    } catch (e) {
      emit(CompanyDetailsError(e.toString()));
    }
  }
}
