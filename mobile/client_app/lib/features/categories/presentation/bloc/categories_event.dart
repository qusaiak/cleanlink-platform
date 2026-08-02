part of 'categories_bloc.dart';

abstract class CategoriesEvent extends Equatable {
  const CategoriesEvent();

  @override
  List<Object?> get props => const [];
}

class GetCategoriesEvent extends CategoriesEvent {
  const GetCategoriesEvent({this.refresh = false, this.completer});

  final bool refresh;
  final Completer<void>? completer;

  @override
  List<Object?> get props => [refresh];
}

class GetMoreCategoriesEvent extends CategoriesEvent {
  const GetMoreCategoriesEvent({this.retry = false});

  final bool retry;

  @override
  List<Object?> get props => [retry];
}

class GetCategoryEvent extends CategoriesEvent {
  final int id;

  const GetCategoryEvent(this.id);

  @override
  List<Object?> get props => [id];
}
