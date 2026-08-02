import 'dart:async';

import '../../../../config/constants/pagination_constants.dart';
import '../../../../core/pagination/paginated_result.dart';
import '../../../../core/pagination/pagination_utils.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/usecases/get_categoris_usecase.dart';
import '../../domain/usecases/get_category_usecase.dart';

part 'categories_event.dart';
part 'categories_state.dart';

class CategoriesBloc extends Bloc<CategoriesEvent, CategoriesState> {
  final GetCategoriesUseCase useCase;
  final GetCategoryUseCase getCategoryUseCase;

  CategoriesBloc(this.useCase, this.getCategoryUseCase)
    : super(const CategoriesInitial()) {
    on<GetCategoriesEvent>(_onGetCategories);
    on<GetMoreCategoriesEvent>(_onGetMoreCategories);
    on<GetCategoryEvent>(_onGetCategory);
  }

  Future<void> _onGetCategories(
    GetCategoriesEvent event,
    Emitter<CategoriesState> emit,
  ) async {
    if (state is CategoriesLoading ||
        (event.refresh &&
            state is CategoriesLoaded &&
            (state as CategoriesLoaded).isLoadingMore)) {
      _complete(event.completer);
      return;
    }

    try {
      emit(const CategoriesLoading());

      final result = await useCase(
        page: 1,
        perPage: PaginationConstants.categoriesPageSize,
      );
      emit(CategoriesLoaded.fromResult(result));
    } catch (e) {
      emit(CategoriesError(e.toString()));
    } finally {
      _complete(event.completer);
    }
  }

  Future<void> _onGetMoreCategories(
    GetMoreCategoriesEvent event,
    Emitter<CategoriesState> emit,
  ) async {
    final currentState = state;
    if (currentState is! CategoriesLoaded ||
        !currentState.canLoadMore ||
        (currentState.loadMoreError != null && !event.retry)) {
      return;
    }

    emit(currentState.copyWith(isLoadingMore: true, clearLoadMoreError: true));

    try {
      final result = await useCase(
        page: currentState.currentPage + 1,
        perPage: PaginationConstants.categoriesPageSize,
      );
      emit(
        CategoriesLoaded.fromResult(
          result,
          categories: _mergeCategories(currentState.categories, result.items),
        ),
      );
    } catch (e) {
      emit(
        currentState.copyWith(
          isLoadingMore: false,
          loadMoreError: e.toString(),
        ),
      );
    }
  }

  Future<void> _onGetCategory(
    GetCategoryEvent event,
    Emitter<CategoriesState> emit,
  ) async {
    try {
      emit(const CategoryLoading());
      final result = await getCategoryUseCase(event.id);
      emit(CategoryLoaded(result));
    } catch (e) {
      emit(CategoryError(e.toString()));
    }
  }

  static List<CategoryEntity> _mergeCategories(
    List<CategoryEntity> current,
    List<CategoryEntity> incoming,
  ) {
    return mergeWithoutDuplicates(current, incoming, (category) => category.id);
  }

  static void _complete(Completer<void>? completer) {
    if (completer != null && !completer.isCompleted) completer.complete();
  }
}
