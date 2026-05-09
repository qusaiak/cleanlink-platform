import 'package:flutter/material.dart';

class CategoryModel {
  final IconData icon;
  final String title;

  const CategoryModel({
    required this.icon,
    required this.title,
  });
}

class CategoriesData {
  static final List<CategoryModel> all = [
    CategoryModel(icon: Icons.home, title: "Home"),
    CategoryModel(icon: Icons.business, title: "Office"),
    CategoryModel(icon: Icons.auto_awesome, title: "Deep"),
    CategoryModel(icon: Icons.chair, title: "Sofa"),
    CategoryModel(icon: Icons.cleaning_services, title: "Carpet"),
    CategoryModel(icon: Icons.local_shipping, title: "Move"),

    /// Extra categories (only visible in full page)
    CategoryModel(icon: Icons.kitchen, title: "Kitchen"),
    CategoryModel(icon: Icons.bathtub, title: "Bathroom"),
    CategoryModel(icon: Icons.window, title: "Windows"),
    CategoryModel(icon: Icons.yard, title: "Garden"),
    CategoryModel(icon: Icons.pool, title: "Pool"),
    CategoryModel(icon: Icons.ac_unit, title: "AC Cleaning"),
  ];
}