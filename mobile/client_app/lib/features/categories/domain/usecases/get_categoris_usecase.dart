import '../../../../core/pagination/paginated_result.dart';
import '../entities/category_entity.dart';
import '../repositories/categories_repo.dart';

class GetCategoriesUseCase {
  final CategoriesRepo repo;

  GetCategoriesUseCase(this.repo);

  Future<PaginatedResult<CategoryEntity>> call({
    required int page,
    required int perPage,
  }) {
    return repo.getCategories(page: page, perPage: perPage);
  }
}
