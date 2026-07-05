import '../entities/favorite_entity.dart';
import '../repositories/favorites_repo.dart';

class GetFavoritesUseCase {

  final FavoritesRepo repo;

  GetFavoritesUseCase(
      this.repo);

  Future<FavoriteEntity>
  call() {

    return repo
        .getFavorites();
  }
}