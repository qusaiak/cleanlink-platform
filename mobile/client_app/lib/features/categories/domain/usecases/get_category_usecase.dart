import 'package:client_app/features/categories/domain/entities/category_entity.dart';
import '../repositories/categories_repo.dart';

class GetCategoryUseCase {
  final CategoriesRepo repo;

  GetCategoryUseCase(this.repo);

  Future<CategoryEntity> call(int id) {
    return repo.getCategory(id);
  }
}
