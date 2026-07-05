import '../entities/favorite_toggle_entity.dart';
import '../entities/favorite_entity.dart';

abstract class FavoritesRepo {
  Future<FavoriteToggleEntity> toggleFavorite({
    required String type,
    required int id,
  });

  Future<FavoriteEntity> getFavorites();
}
