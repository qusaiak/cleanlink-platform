// import 'package:json_annotation/json_annotation.dart';
//
// import '../../../companies/domain/entities/manager_entity.dart';
// import '../../domain/entities/manager_entity.dart';
//
// part 'manager_model.g.dart';
//
// @JsonSerializable(fieldRename: FieldRename.snake)
// class ManagerModel {
//   final int? id;
//   final String? fullname;
//   final String? email;
//   final String? role;
//
//   const ManagerModel({
//     this.id,
//     this.fullname,
//     this.email,
//     this.role,
//   });
//
//   factory ManagerModel.fromJson(Map<String, dynamic> json) =>
//       _$ManagerModelFromJson(json);
//
//   Map<String, dynamic> toJson() => _$ManagerModelToJson(this);
//
//   ManagerEntity toEntity() => ManagerEntity(
//         id: id ?? 0,
//         fullname: fullname ?? "",
//         email: email ?? "",
//         role: role ?? "",
//       );
// }
