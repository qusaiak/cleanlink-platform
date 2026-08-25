import 'package:client_app/features/companies/domain/entities/manager_entity.dart';
import 'package:client_app/features/companies/domain/entities/region_entity.dart';

import '../../features/categories/domain/entities/category_entity.dart';
import '../../features/companies/domain/entities/company_entity.dart';
import '../../features/services/domain/entities/service_entity.dart';
import '../utils/gen/assets.gen.dart';

class CategoriesData {
  static final List<CategoryEntity> all = [
    CategoryEntity(
      id: 1,
      name: "Home",
      description: "Home cleaning services",
      image: Assets.images.test.test.path,
    ),
    CategoryEntity(
      id: 2,
      name: "Office",
      description: "Office cleaning services",
      image: Assets.images.test.test.path,
    ),
    CategoryEntity(
      id: 3,
      name: "Car",
      description: "Car cleaning",
      image: Assets.images.test.test.path,
    ),
    CategoryEntity(
      id: 4,
      name: "Carpet",
      description: "Carpet cleaning",
      image: Assets.images.test.test.path,
    ),
    CategoryEntity(
      id: 5,
      name: "AC",
      description: "AC cleaning",
      image: Assets.images.test.test.path,
    ),
    CategoryEntity(
      id: 6,
      name: "Pool",
      description: "Pool cleaning",
      image: Assets.images.test.test.path,
    ),
  ];
}

class CompaniesData {
  static final List<CompanyEntity> all = [
    CompanyEntity(
      id: 3,
      managerId: 30,
      regionId: 3,
      name: "CleanMaster",
      description: "Complete cleaning solutions",
      image: Assets.images.test.test.path,
      location: "Homs",
      rating: 4,
      isFavorite: false,

      manager: ManagerEntity(
        id: 3,
        fullname: "Sara Region Manager",
        email: "sara.rm@cleaning.com",
        role: "region_manager",
      ),
      region: RegionEntity(
        id: 2,
        name: "Aleppo",
        image: Assets.images.test.test.path,
        managerId: 3,
        manager: ManagerEntity(
          id: 3,
          fullname: "Sara Region Manager",
          email: "sara.rm@cleaning.com",
          role: "region_manager",
        ),
      ),
      services: [],
      workers: [],
      reviews: [],

      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    CompanyEntity(
      id: 3,
      managerId: 30,
      regionId: 3,
      name: "CleanMaster",
      description: "Complete cleaning solutions",
      image: Assets.images.test.test.path,
      location: "Homs",
      rating: 4,
      isFavorite: false,

      manager: ManagerEntity(
        id: 3,
        fullname: "Sara Region Manager",
        email: "sara.rm@cleaning.com",
        role: "region_manager",
      ),
      region: RegionEntity(
        id: 2,
        name: "Aleppo",
        image: Assets.images.test.test.path,
        managerId: 3,
        manager: ManagerEntity(
          id: 3,
          fullname: "Sara Region Manager",
          email: "sara.rm@cleaning.com",
          role: "region_manager",
        ),
      ),
      services: [],
      workers: [],
      reviews: [],

      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    CompanyEntity(
      id: 3,
      managerId: 30,
      regionId: 3,
      name: "CleanMaster",
      description: "Complete cleaning solutions",
      image: Assets.images.test.test.path,
      location: "Homs",
      rating: 4,
      isFavorite: false,
      manager: ManagerEntity(
        id: 3,
        fullname: "Sara Region Manager",
        email: "sara.rm@cleaning.com",
        role: "region_manager",
      ),
      region: RegionEntity(
        id: 2,
        name: "Aleppo",
        image: Assets.images.test.test.path,
        managerId: 3,
        manager: ManagerEntity(
          id: 3,
          fullname: "Sara Region Manager",
          email: "sara.rm@cleaning.com",
          role: "region_manager",
        ),
      ),
      services: [],
      workers: [],
      reviews: [],

      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
  ];
}

class ServicesData {
  static final List<ServiceEntity> all = [
    ServiceEntity(
      id: 4,
      companyId: 1,
      categoryId: 3,
      name: "Car Wash",
      description: "Interior & exterior cleaning",
      rating: 4.6,
      minDuration: 30,
      maxDuration: 60,
      minPrice: 18,
      maxPrice: 30,
      image: Assets.images.test.test.path,
      discount: 15,
      isFavorite: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),

    ServiceEntity(
      id: 4,
      companyId: 1,
      categoryId: 3,
      name: "Car Wash",
      description: "Interior & exterior cleaning",
      rating: 4.6,
      minDuration: 30,
      maxDuration: 60,
      minPrice: 18,
      maxPrice: 30,
      image: Assets.images.test.test.path,
      discount: 15,
      isFavorite: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),

    ServiceEntity(
      id: 4,
      companyId: 1,
      categoryId: 3,
      name: "Car Wash",
      description: "Interior & exterior cleaning",
      rating: 4.6,
      minDuration: 30,
      maxDuration: 60,
      minPrice: 18,
      maxPrice: 30,
      image: Assets.images.test.test.path,
      discount: 15,
      isFavorite: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    ServiceEntity(
      id: 4,
      companyId: 1,
      categoryId: 3,
      name: "Car Wash",
      description: "Interior & exterior cleaning",
      rating: 4.6,
      minDuration: 30,
      maxDuration: 60,
      minPrice: 18,
      maxPrice: 30,
      image: Assets.images.test.test.path,
      discount: 15,
      isFavorite: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
  ];

  static List<ServiceEntity> offers = all.where((e) => e.discount > 0).toList();
}
