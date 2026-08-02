import '../entities/complaint_entity.dart';

abstract class ComplaintsRepository {
  Future<ComplaintsCollectionEntity> getComplaints();
  Future<ComplaintEntity> getComplaintDetails(int id);
  Future<ComplaintEntity> createComplaint({
    required ComplaintType type,
    required int id,
    required String title,
    required String body,
  });
  Future<int> getUnreadCount();
  Future<ComplaintEntity> markAsRead(int id);
}
