import 'package:client_app/features/categories/domain/entities/category_entity.dart';
import '../../../../core/pagination/paginated_result.dart';

abstract class CategoriesRepo {
  Future<PaginatedResult<CategoryEntity>> getCategories({
    required int page,
    required int perPage,
  });

  Future<CategoryEntity> getCategory(int id);
}
