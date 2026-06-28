import 'package:client_app/features/categories/domain/entities/category_entity.dart';

abstract class CategoriesRepo {
  Future<List<CategoryEntity>> getCategories();
}
