import 'package:equatable/equatable.dart';

enum ComplaintType { service, company, unknown }

class ComplaintsCollectionEntity extends Equatable {
  const ComplaintsCollectionEntity({
    this.services = const [],
    this.companies = const [],
    this.total = 0,
    this.unread = 0,
  });

  final List<ComplaintEntity> services;
  final List<ComplaintEntity> companies;
  final int total;
  final int unread;

  @override
  List<Object?> get props => [services, companies, total, unread];
}

class ComplaintReplyEntity extends Equatable {
  const ComplaintReplyEntity({
    required this.id,
    required this.message,
    required this.createdAt,
    this.replierName,
    this.replierRole,
  });

  final int id;
  final String message;
  final DateTime? createdAt;
  final String? replierName;
  final String? replierRole;

  @override
  List<Object?> get props => [id, message, createdAt, replierName, replierRole];
}

class ComplaintEntity extends Equatable {
  const ComplaintEntity({
    required this.id,
    required this.type,
    required this.targetId,
    required this.targetName,
    required this.title,
    required this.body,
    required this.isReadByRecipient,
    required this.hasUnreadResponse,
    required this.hasResponses,
    required this.responses,
    required this.createdAt,
    this.updatedAt,
    this.targetNameEn,
    this.targetNameAr,
    this.targetImage,
  });

  final int id;
  final ComplaintType type;
  final int targetId;
  final String targetName;
  final String? targetNameEn;
  final String? targetNameAr;
  final String? targetImage;
  final String title;
  final String body;
  final bool isReadByRecipient;
  final bool hasUnreadResponse;
  final bool hasResponses;
  final List<ComplaintReplyEntity> responses;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  String get status => hasResponses
      ? 'replied'
      : isReadByRecipient
      ? 'reviewed'
      : 'pending';

  String localizedTargetName(String languageCode) {
    if (languageCode == 'ar' && (targetNameAr?.isNotEmpty ?? false)) {
      return targetNameAr!;
    }
    if (targetNameEn?.isNotEmpty ?? false) return targetNameEn!;
    if (targetNameAr?.isNotEmpty ?? false) return targetNameAr!;
    return targetName;
  }

  ComplaintEntity copyWith({bool? hasUnreadResponse, String? targetName}) =>
      ComplaintEntity(
        id: id,
        type: type,
        targetId: targetId,
        targetName: targetName ?? this.targetName,
        title: title,
        body: body,
        isReadByRecipient: isReadByRecipient,
        hasUnreadResponse: hasUnreadResponse ?? this.hasUnreadResponse,
        hasResponses: hasResponses,
        responses: responses,
        createdAt: createdAt,
        updatedAt: updatedAt,
        targetNameEn: targetNameEn,
        targetNameAr: targetNameAr,
        targetImage: targetImage,
      );

  @override
  List<Object?> get props => [
    id,
    type,
    targetId,
    targetName,
    targetNameEn,
    targetNameAr,
    targetImage,
    title,
    body,
    isReadByRecipient,
    hasUnreadResponse,
    hasResponses,
    responses,
    createdAt,
    updatedAt,
  ];
}
