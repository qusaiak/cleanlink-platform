import '../entities/favorite_toggle_entity.dart';
import '../repositories/favorites_repo.dart';

class ToggleFavoriteUseCase {
  final FavoritesRepo repo;

  ToggleFavoriteUseCase(this.repo);

  Future<FavoriteToggleEntity> call({required String type, required int id}) {
    return repo.toggleFavorite(type: type, id: id);
  }
}
