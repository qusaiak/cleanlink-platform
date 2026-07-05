part of 'favorites_bloc.dart';

sealed class FavoritesState {}

class FavoritesInitial extends FavoritesState {}

class FavoritesLoading extends FavoritesState {}

class FavoritesLoaded extends FavoritesState {
  final FavoriteEntity data;

  FavoritesLoaded(this.data);

  FavoritesLoaded copyWith({
    FavoriteEntity? data,
  }) {
    return FavoritesLoaded(
      data ?? this.data,
    );
  }
}

class FavoriteToggleLoading extends FavoritesState {
  final FavoriteEntity current;

  FavoriteToggleLoading(this.current);
}

class FavoritesError extends FavoritesState {
  final String msg;

  FavoritesError(this.msg);
}