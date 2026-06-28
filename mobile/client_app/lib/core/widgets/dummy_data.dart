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
      nameAr: "البيوت",
      nameEn: "Home",
      descriptionAr: "تنظيف المنازل",
      descriptionEn: "Home cleaning services",
      image: Assets.images.test.test.path,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),

    CategoryEntity(
      id: 2,
      nameAr: "المكاتب",
      nameEn: "Office",
      descriptionAr: "تنظيف المكاتب",
      descriptionEn: "Office cleaning services",
      image: Assets.images.test.test.path,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),

    CategoryEntity(
      id: 3,
      nameAr: "السيارات",
      nameEn: "Car",
      descriptionAr: "تنظيف السيارات",
      descriptionEn: "Car cleaning",
      image: Assets.images.test.test.path,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),

    CategoryEntity(
      id: 4,
      nameAr: "السجاد",
      nameEn: "Carpet",
      descriptionAr: "تنظيف السجاد",
      descriptionEn: "Carpet cleaning",
      image: Assets.images.test.test.path,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),

    CategoryEntity(
      id: 5,
      nameAr: "المكيفات",
      nameEn: "AC",
      descriptionAr: "تنظيف المكيفات",
      descriptionEn: "AC cleaning",
      image: Assets.images.test.test.path,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),

    CategoryEntity(
      id: 6,
      nameAr: "المسابح",
      nameEn: "Pool",
      descriptionAr: "تنظيف المسابح",
      descriptionEn: "Pool cleaning",
      image: Assets.images.test.test.path,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
  ];
}

class CompaniesData {
  static final List<CompanyEntity> all = [
    CompanyEntity(
      id: 1,
      managerId: 10,
      regionId: 1,
      nameAr: "إيكو كلين",
      nameEn: "SparkleClean",
      descriptionAr: "أفضل خدمات التنظيف",
      descriptionEn: "Professional cleaning company",
      image: Assets.images.test.test.path,
      locationAr: "دمشق",
      locationEn: "Damascus",
      rating: "4.9",
      isOpen: 1,
      startHour: "08:00:00",
      closeHour: "22:00:00",
      manager: ManagerEntity(
        id: 3,
        fullname: "Sara Region Manager",
        email: "sara.rm@cleaning.com",
        role: "region_manager",
      ),
      region: RegionEntity(
        id: 2,
        nameAr: "حلب",
        nameEn: "Aleppo",
        managerId: 3,
        manager: ManagerEntity(
          id: 3,
          fullname: "Sara Region Manager",
          email: "sara.rm@cleaning.com",
          role: "region_manager",
        ),
      ),
      services: [],

      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),

    CompanyEntity(
      id: 2,
      managerId: 20,
      regionId: 2,
      nameAr: "شاين برو",
      nameEn: "ShinePro",
      descriptionAr: "تنظيف احترافي",
      descriptionEn: "Premium cleaning services",
      image: Assets.images.test.test.path,
      locationAr: "حلب",
      locationEn: "Aleppo",
      rating: "4.8",
      isOpen: 1,
      startHour: "09:00:00",
      closeHour: "23:00:00",
      manager: ManagerEntity(
        id: 3,
        fullname: "Sara Region Manager",
        email: "sara.rm@cleaning.com",
        role: "region_manager",
      ),
      region: RegionEntity(
        id: 2,
        nameAr: "حلب",
        nameEn: "Aleppo",
        managerId: 3,
        manager: ManagerEntity(
          id: 3,
          fullname: "Sara Region Manager",
          email: "sara.rm@cleaning.com",
          role: "region_manager",
        ),
      ),
      services: [],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),

    CompanyEntity(
      id: 3,
      managerId: 30,
      regionId: 3,
      nameAr: "كلين ماستر",
      nameEn: "CleanMaster",
      descriptionAr: "تنظيف شامل",
      descriptionEn: "Complete cleaning solutions",
      image: Assets.images.test.test.path,
      locationAr: "حمص",
      locationEn: "Homs",
      rating: "4.7",
      isOpen: 1,
      startHour: "10:00:00",
      closeHour: "20:00:00",
      manager: ManagerEntity(
        id: 3,
        fullname: "Sara Region Manager",
        email: "sara.rm@cleaning.com",
        role: "region_manager",
      ),
      region: RegionEntity(
        id: 2,
        nameAr: "حلب",
        nameEn: "Aleppo",
        managerId: 3,
        manager: ManagerEntity(
          id: 3,
          fullname: "Sara Region Manager",
          email: "sara.rm@cleaning.com",
          role: "region_manager",
        ),
      ),
      services: [],

      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
  ];
}

class ServicesData {
  static final List<ServiceEntity> all = [
    ServiceEntity(
      id: 1,
      companyId: 1,
      categoryId: 1,
      nameAr: "تنظيف منازل",
      nameEn: "House Cleaning",
      descriptionAr: "تنظيف شامل للمنازل",
      descriptionEn: "Complete home cleaning",
      rating: "4.9",
      minDuration: 60,
      maxDuration: 120,
      price: "25.00",
      image: Assets.images.test.test.path,
      discount: "0.00",
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),

    ServiceEntity(
      id: 2,
      companyId: 2,
      categoryId: 2,
      nameAr: "تنظيف عميق",
      nameEn: "Deep Cleaning",
      descriptionAr: "تنظيف وتعقيم كامل",
      descriptionEn: "Deep sanitization",
      rating: "4.8",
      minDuration: 120,
      maxDuration: 180,
      price: "60.00",
      image: Assets.images.test.test.path,
      discount: "10.00",
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),

    ServiceEntity(
      id: 3,
      companyId: 3,
      categoryId: 4,
      nameAr: "تنظيف سجاد",
      nameEn: "Carpet Cleaning",
      descriptionAr: "إزالة البقع",
      descriptionEn: "Professional carpet cleaning",
      rating: "4.7",
      minDuration: 45,
      maxDuration: 90,
      price: "35.00",
      image: Assets.images.test.test.path,
      discount: "5.00",
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),

    ServiceEntity(
      id: 4,
      companyId: 1,
      categoryId: 3,
      nameAr: "تنظيف سيارات",
      nameEn: "Car Wash",
      descriptionAr: "غسيل خارجي وداخلي",
      descriptionEn: "Interior & exterior cleaning",
      rating: "4.6",
      minDuration: 30,
      maxDuration: 60,
      price: "18.00",
      image: Assets.images.test.test.path,
      discount: "15.00",
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
  ];

  static List<ServiceEntity> offers = all
      .where((e) => double.parse(e.discount!) > 0)
      .toList();
}
