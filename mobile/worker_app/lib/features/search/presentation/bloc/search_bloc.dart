import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failure.dart';
import '../../domain/entities/search_query.dart';
import '../../domain/entities/service_summary.dart';
import '../../domain/usecases/search_services_usecase.dart';

part 'search_event.dart';
part 'search_state.dart';

/// Drives the search results screen: runs a [SearchQuery] (general or
/// custom-by-field) and exposes the matching services.
class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchServicesUseCase searchServices;

  SearchBloc({required this.searchServices}) : super(const SearchState()) {
    on<SubmitSearch>(_onSubmit);
  }

  Future<void> _onSubmit(SubmitSearch event, Emitter<SearchState> emit) async {
    emit(state.copyWith(status: SearchStatus.loading, query: event.query));
    final result = await searchServices(params: event.query);
    result.fold(
      (failure) =>
          emit(state.copyWith(status: SearchStatus.error, error: failure)),
      (results) => emit(
        state.copyWith(status: SearchStatus.loaded, results: results),
      ),
    );
  }
}
