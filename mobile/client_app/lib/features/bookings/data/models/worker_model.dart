import '../../domain/entities/worker_entity.dart';

class WorkerModel extends WorkerEntity {
  const WorkerModel({
    required super.id,
    required super.name,
    required super.image,
  });

  factory WorkerModel.fromJson(Map<String, dynamic> json) {
    return WorkerModel(
      id: json["id"] ?? 0,

      name: json["name"] ?? "",

      image: json["image"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {"id": id, "name": name, "image": image};
  }
}
