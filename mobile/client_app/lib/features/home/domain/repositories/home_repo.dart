import '../entities/home_entity.dart';

abstract class HomeRepo {
  Future<HomeEntity> getHome();
}
