import 'package:bloc/bloc.dart';
import '../../domain/entities/favorite_entity.dart';
import '../../domain/usecases/get_favorites_usecase.dart';
import '../../domain/usecases/toggle_favorite_usecase.dart';

part 'favorites_event.dart';
part 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final GetFavoritesUseCase getFav;

  final ToggleFavoriteUseCase toggle;

  FavoritesBloc(
      this.getFav,
      this.toggle,
      ) : super(FavoritesInitial()) {
    on<GetFavoritesEvent>(_getFavorites);

    on<ToggleFavoriteEvent>(_toggleFavorite);
  }

  Future<void> _getFavorites(
      GetFavoritesEvent event,
      Emitter<FavoritesState> emit,
      ) async {
    emit(FavoritesLoading());

    try {
      final result = await getFav();

      emit(FavoritesLoaded(result));
    } catch (e) {
      emit(FavoritesError(e.toString()));
    }
  }

  Future<void> _toggleFavorite(
      ToggleFavoriteEvent event,
      Emitter<FavoritesState> emit,
      ) async {
    try {
      await toggle(
        type: event.type,
        id: event.id,
      );

      // reload from backend
      final refreshed = await getFav();

      emit(FavoritesLoaded(refreshed));
    } catch (e) {
      emit(FavoritesError(e.toString()));
    }
  }
}