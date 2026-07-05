part of 'categories_bloc.dart';

abstract class CategoriesState {
  const CategoriesState();
}

class CategoriesInitial extends CategoriesState {
  const CategoriesInitial();
}

/// ===== Categories list =====
class CategoriesLoading extends CategoriesState {
  const CategoriesLoading();
}

class CategoriesLoaded extends CategoriesState {
  final List<CategoryEntity> categories;

  const CategoriesLoaded(this.categories);
}

class CategoriesError extends CategoriesState {
  final String message;

  const CategoriesError(this.message);
}

/// ===== Single category (details) =====
class CategoryLoading extends CategoriesState {
  const CategoryLoading();
}

class CategoryLoaded extends CategoriesState {
  final CategoryEntity category;

  const CategoryLoaded(this.category);
}

class CategoryError extends CategoriesState {
  final String message;

  const CategoryError(this.message);
}
