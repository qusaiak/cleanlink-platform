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
    on<GetCategoryEvent>(_onGetCategory);
  }

  Future<void> _onGetCategories(
    GetCategoriesEvent event,
    Emitter<CategoriesState> emit,
  ) async {
    try {
      emit(const CategoriesLoading());
      final result = await useCase();
      emit(CategoriesLoaded(result));
    } catch (e) {
      emit(CategoriesError(e.toString()));
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
}
