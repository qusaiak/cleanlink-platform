import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/usecases/get_categoris_usecase.dart';

part 'categories_event.dart';
part 'categories_state.dart';

class CategoriesBloc extends Bloc<CategoriesEvent, CategoriesState> {
  final GetCategoriesUseCase useCase;

  CategoriesBloc(this.useCase) : super(const CategoriesInitial()) {
    on<GetCategoriesEvent>(_onGetCategories);
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
}
