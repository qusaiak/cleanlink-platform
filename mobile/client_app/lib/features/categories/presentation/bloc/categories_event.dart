part of 'categories_bloc.dart';

abstract class CategoriesEvent {
  const CategoriesEvent();
}

class GetCategoriesEvent extends CategoriesEvent {}

class GetCategoryEvent extends CategoriesEvent {
  final int id;

  const GetCategoryEvent(this.id);
}
