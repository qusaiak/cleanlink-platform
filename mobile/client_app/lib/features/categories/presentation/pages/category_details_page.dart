// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import '../../../home/domain/entities/category_entity.dart';
// import '../../../home/presentation/widgets/service_tile.dart';
// import '../bloc/categories_bloc.dart';
//
// class CategoryDetailsPage extends StatefulWidget {
//   const CategoryDetailsPage({
//     super.key,
//     required this.category,
//   });
//
//   final CategoryEntity category;
//
//   @override
//   State<CategoryDetailsPage> createState() =>
//       _CategoryDetailsPageState();
// }
//
// class _CategoryDetailsPageState
//     extends State<CategoryDetailsPage> {
//   @override
//   void initState() {
//     super.initState();
//
//     context.read<CategoriesBloc>().add(
//       GetCategoryServicesEvent(
//         widget.category.id,
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context).colorScheme;
//
//     return Scaffold(
//       body: CustomScrollView(
//         slivers: [
//           /// HEADER
//           SliverAppBar(
//             expandedHeight: 280.h,
//             pinned: true,
//
//             flexibleSpace: FlexibleSpaceBar(
//               title: Text(
//                 widget.category.nameEn,
//                 maxLines: 1,
//               ),
//
//               background: Stack(
//                 fit: StackFit.expand,
//                 children: [
//                   Image.network(
//                     widget.category.image,
//                     fit: BoxFit.cover,
//                   ),
//
//                   Container(
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                         begin: Alignment.bottomCenter,
//                         end: Alignment.topCenter,
//                         colors: [
//                           Colors.black87,
//                           Colors.transparent,
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//
//           /// CONTENT
//           SliverToBoxAdapter(
//             child: Padding(
//               padding: EdgeInsets.all(20.w),
//
//               child: Column(
//                 crossAxisAlignment:
//                 CrossAxisAlignment.start,
//
//                 children: [
//                   Text(
//                     widget.category.nameEn,
//                     style: TextStyle(
//                       fontSize: 24.sp,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//
//                   SizedBox(height: 12.h),
//
//                   Text(
//                     widget.category.descriptionEn,
//                     style: TextStyle(
//                       fontSize: 14.sp,
//                       color: theme.onSurfaceVariant,
//                       height: 1.5,
//                     ),
//                   ),
//
//                   SizedBox(height: 30.h),
//
//                   Row(
//                     children: [
//                       Icon(
//                         Icons.cleaning_services,
//                         color: theme.primary,
//                       ),
//
//                       SizedBox(width: 8.w),
//
//                       Text(
//                         "Available Services",
//                         style: TextStyle(
//                           fontSize: 18.sp,
//                           fontWeight:
//                           FontWeight.w700,
//                         ),
//                       ),
//                     ],
//                   ),
//
//                   SizedBox(height: 20.h),
//                 ],
//               ),
//             ),
//           ),
//
//           /// SERVICES
//           BlocBuilder<
//               CategoriesBloc,
//               CategoriesState>(
//             builder: (context, state) {
//               if (state is ServicesLoading) {
//                 return SliverFillRemaining(
//                   child: Center(
//                     child:
//                     CircularProgressIndicator(),
//                   ),
//                 );
//               }
//
//               if (state is ServicesLoaded) {
//                 if (state.services.isEmpty) {
//                   return SliverFillRemaining(
//                     child: Center(
//                       child: Text(
//                         "No services available",
//                       ),
//                     ),
//                   );
//                 }
//
//                 return SliverPadding(
//                   padding: EdgeInsets.symmetric(
//                     horizontal: 20.w,
//                   ),
//
//                   sliver: SliverList(
//                     delegate:
//                     SliverChildBuilderDelegate(
//                           (_, index) {
//                         final service =
//                         state.services[index];
//
//                         return Padding(
//                           padding:
//                           EdgeInsets.only(
//                             bottom: 16.h,
//                           ),
//
//                           child: ServiceTile(
//                             service: service,
//
//                             onTap: () {},
//                           ),
//                         );
//                       },
//                       childCount:
//                       state.services.length,
//                     ),
//                   ),
//                 );
//               }
//
//               return const SliverToBoxAdapter(
//                 child: SizedBox(),
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }