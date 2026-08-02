part of 'complaints_bloc.dart';

sealed class ComplaintsEvent extends Equatable {
  const ComplaintsEvent();
  @override
  List<Object?> get props => const [];
}

class LoadComplaintsEvent extends ComplaintsEvent {
  const LoadComplaintsEvent({
    this.refresh = false,
    this.forceLoading = false,
    this.completer,
  });

  final bool refresh;
  final bool forceLoading;
  final Completer<void>? completer;

  @override
  List<Object?> get props => [refresh, forceLoading, completer];
}

final class LoadComplaintDetailsEvent extends ComplaintsEvent {
  const LoadComplaintDetailsEvent(this.id);
  final int id;
  @override
  List<Object?> get props => [id];
}

final class CreateComplaintEvent extends ComplaintsEvent {
  const CreateComplaintEvent({
    required this.type,
    required this.targetId,
    required this.targetName,
    required this.title,
    required this.body,
  });
  final ComplaintType type;
  final int targetId;
  final String targetName;
  final String title;
  final String body;
  @override
  List<Object?> get props => [type, targetId, targetName, title, body];
}

final class LoadComplaintUnreadCountEvent extends ComplaintsEvent {
  const LoadComplaintUnreadCountEvent();
}

final class ClearComplaintMessagesEvent extends ComplaintsEvent {
  const ClearComplaintMessagesEvent();
}
