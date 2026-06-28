import 'package:client_app/features/categories/domain/entities/category_entity.dart';
import '../repositories/categories_repo.dart';

class GetCategoriesUseCase {
  final CategoriesRepo repo;

  GetCategoriesUseCase(this.repo);

  Future<List<CategoryEntity>> call() {
    return repo.getCategories();
  }
}
