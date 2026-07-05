import '../../domain/entities/favorite_entity.dart';
import '../../domain/entities/favorite_toggle_entity.dart';
import '../../domain/repositories/favorites_repo.dart';
import '../data_sources/favorites_api_service.dart';

class FavoritesRepoImpl implements FavoritesRepo {
  final FavoritesApiService api;

  FavoritesRepoImpl(this.api);

  @override
  Future<FavoriteEntity> getFavorites() async {
    final response = await api.getFavorites();

    return response.data.data!.toEntity();
  }

  @override
  Future<FavoriteToggleEntity> toggleFavorite({
    required String type,
    required int id,
  }) async {
    final response = await api.toggleFavorite({"type": type, "id": id});

    return response.data.toEntity();
  }
}
