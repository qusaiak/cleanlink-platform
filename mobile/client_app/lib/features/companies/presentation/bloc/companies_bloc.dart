import 'dart:async';

import '../../../../config/constants/pagination_constants.dart';
import '../../../../core/pagination/paginated_result.dart';
import '../../../../core/pagination/pagination_utils.dart';
import '../../../../core/error/failure.dart';
import 'package:client_app/features/companies/domain/usecases/get_company_details_use_case.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    on<GetMoreCompaniesEvent>(_onGetMoreCompanies);
    on<GetCompanyDetailsEvent>(_onGetCompanyDetails);
    on<RefreshCompanyDetailsEvent>(_onRefreshCompanyDetails);
  }

  Future<void> _onGetCompanies(
    GetCompaniesEvent event,

    Emitter<CompaniesState> emit,
  ) async {
    if (state is CompaniesLoading ||
        (event.refresh &&
            state is CompaniesLoaded &&
            (state as CompaniesLoaded).isLoadingMore)) {
      _complete(event.completer);
      return;
    }

    emit(CompaniesLoading(isRefreshing: event.refresh));

    try {
      final result = await useCase(
        page: 1,
        perPage: PaginationConstants.companiesPageSize,
      );

      emit(CompaniesLoaded.fromResult(result));
    } catch (e) {
      emit(CompaniesError(e.toString()));
    } finally {
      _complete(event.completer);
    }
  }

  Future<void> _onGetMoreCompanies(
    GetMoreCompaniesEvent event,
    Emitter<CompaniesState> emit,
  ) async {
    final current = state;
    if (current is! CompaniesLoaded ||
        !current.canLoadMore ||
        (current.loadMoreError != null && !event.retry)) {
      return;
    }

    emit(current.copyWith(isLoadingMore: true, clearLoadMoreError: true));
    try {
      final result = await useCase(
        page: current.currentPage + 1,
        perPage: PaginationConstants.companiesPageSize,
      );
      emit(
        CompaniesLoaded.fromResult(
          result,
          companies: mergeWithoutDuplicates(
            current.companies,
            result.items,
            (company) => company.id,
          ),
        ),
      );
    } catch (e) {
      emit(current.copyWith(isLoadingMore: false, loadMoreError: e.toString()));
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
    } on Failure catch (failure) {
      emit(CompanyDetailsError(failure));
    } catch (_) {
      emit(const CompanyDetailsError(ServerFailure('', '')));
    }
  }

  Future<void> _onRefreshCompanyDetails(
    RefreshCompanyDetailsEvent event,
    Emitter<CompaniesState> emit,
  ) async {
    if (state is! CompanyDetailsSuccess) return;
    try {
      final result = await companyDetailsUseCase(event.id);
      emit(CompanyDetailsSuccess(result));
    } catch (_) {
      // Keep the successfully displayed details visible if refresh fails.
    }
  }

  static void _complete(Completer<void>? completer) {
    if (completer != null && !completer.isCompleted) completer.complete();
  }
}
