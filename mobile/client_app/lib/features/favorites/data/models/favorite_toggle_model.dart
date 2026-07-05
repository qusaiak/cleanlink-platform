import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/favorite_toggle_entity.dart';

part 'favorite_toggle_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class FavoriteToggleModel {
  final bool? isFavorited;

  const FavoriteToggleModel({this.isFavorited});

  factory FavoriteToggleModel.fromJson(Map<String, dynamic> json) {
    return FavoriteToggleModel(isFavorited: json["data"]["is_favorited"]);
  }

  FavoriteToggleEntity toEntity() {
    return FavoriteToggleEntity(isFavorited: isFavorited ?? false);
  }
}
