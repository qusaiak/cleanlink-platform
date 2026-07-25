import '../entities/home_entity.dart';

import '../repositories/home_repo.dart';

class GetHomeUseCase {
  final HomeRepo repo;

  const GetHomeUseCase(this.repo);

  Future<HomeEntity> call() {
    return repo.getHome();
  }
}
