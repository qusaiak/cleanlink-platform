import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../data/models/company_model.dart';
import '../../../../core/utils/gen/assets.gen.dart';
import 'company_card.dart';

class CompaniesSection extends StatelessWidget {
  const CompaniesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final companies = [
      CompanyModel(
        name: "SparkleClean",
        location: "New York",
        rating: 4.9,
        image: Assets.images.test.test.path,
      ),
      CompanyModel(
        name: "ShinePro",
        location: "London",
        rating: 4.8,
        image: Assets.images.test.test.path,
      ),
      CompanyModel(
        name: "SparkleClean",
        location: "New York",
        rating: 4.9,
        image: Assets.images.test.test.path,
      ),
    ];

    return SizedBox(
      height: 210.h,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: companies.length,
        separatorBuilder: (_, __) => SizedBox(width: 15.w),
        itemBuilder: (_, i) => CompanyCard(company: companies[i]),
      ),
    );
  }
}

