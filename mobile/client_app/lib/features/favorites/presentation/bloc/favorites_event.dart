part of 'favorites_bloc.dart';

sealed class FavoritesEvent {}

class GetFavoritesEvent extends FavoritesEvent {}

class ToggleFavoriteEvent extends FavoritesEvent {
  final String type;

  final int id;

  ToggleFavoriteEvent({required this.type, required this.id});
}
