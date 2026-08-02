import '../entities/complaint_entity.dart';
import '../repositories/complaints_repository.dart';

class GetComplaintsUseCase {
  const GetComplaintsUseCase(this.repository);
  final ComplaintsRepository repository;
  Future<ComplaintsCollectionEntity> call() => repository.getComplaints();
}

class GetComplaintDetailsUseCase {
  const GetComplaintDetailsUseCase(this.repository);
  final ComplaintsRepository repository;
  Future<ComplaintEntity> call(int id) => repository.getComplaintDetails(id);
}

class CreateComplaintUseCase {
  const CreateComplaintUseCase(this.repository);
  final ComplaintsRepository repository;
  Future<ComplaintEntity> call({
    required ComplaintType type,
    required int id,
    required String title,
    required String body,
  }) =>
      repository.createComplaint(type: type, id: id, title: title, body: body);
}

class GetComplaintUnreadCountUseCase {
  const GetComplaintUnreadCountUseCase(this.repository);
  final ComplaintsRepository repository;
  Future<int> call() => repository.getUnreadCount();
}

class MarkComplaintAsReadUseCase {
  const MarkComplaintAsReadUseCase(this.repository);
  final ComplaintsRepository repository;
  Future<ComplaintEntity> call(int id) => repository.markAsRead(id);
}
