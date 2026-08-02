import '../../domain/entities/complaint_entity.dart';

class ComplaintModel {
  const ComplaintModel(this.entity);

  final ComplaintEntity entity;

  factory ComplaintModel.fromJson(Map<String, dynamic> json) {
    final rawType = json['complaintable_type']?.toString().toLowerCase() ?? '';
    final type = rawType.endsWith('service')
        ? ComplaintType.service
        : rawType.endsWith('company')
        ? ComplaintType.company
        : ComplaintType.unknown;
    final target = _map(json['complaintable']);
    final responses = json['responses'] is List
        ? (json['responses'] as List)
              .whereType<Map>()
              .map((item) => _reply(Map<String, dynamic>.from(item)))
              .toList(growable: false)
        : const <ComplaintReplyEntity>[];

    return ComplaintModel(
      ComplaintEntity(
        id: _int(json['id']),
        type: type,
        targetId: _int(json['complaintable_id']),
        targetName:
            target['name']?.toString() ??
            target['name_en']?.toString() ??
            target['name_ar']?.toString() ??
            '',
        targetNameEn: target['name_en']?.toString(),
        targetNameAr: target['name_ar']?.toString(),
        targetImage: target['image']?.toString(),
        title: json['title']?.toString() ?? '',
        body: json['body']?.toString() ?? '',
        isReadByRecipient: _bool(json['is_read']),
        hasUnreadResponse: _bool(json['has_unread_response']),
        hasResponses:
            responses.isNotEmpty || _int(json['external_responses_count']) > 0,
        responses: responses,
        createdAt: DateTime.tryParse(json['created_at']?.toString() ?? ''),
        updatedAt: DateTime.tryParse(json['updated_at']?.toString() ?? ''),
      ),
    );
  }

  static ComplaintReplyEntity _reply(Map<String, dynamic> json) {
    final responder = _map(json['responder']);
    final profile = _map(responder['profile']);
    return ComplaintReplyEntity(
      id: _int(json['id']),
      message: json['response']?.toString() ?? '',
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? ''),
      replierName:
          profile['fullname']?.toString() ??
          responder['fullname']?.toString() ??
          responder['name']?.toString(),
      replierRole: responder['role']?.toString(),
    );
  }
}

class ComplaintsResponseModel {
  const ComplaintsResponseModel(this.collection);
  final ComplaintsCollectionEntity collection;

  factory ComplaintsResponseModel.fromJson(Map<String, dynamic> json) {
    final data = _map(json['data']);
    final companies = _complaints(data['companies_complains']);
    final services = _complaints(data['services_complains']);
    final fallback = _complaints(data['complaints']);
    final stats = _map(data['stats']);
    return ComplaintsResponseModel(
      ComplaintsCollectionEntity(
        companies: companies.isNotEmpty
            ? companies
            : fallback
                  .where((item) => item.type == ComplaintType.company)
                  .toList(growable: false),
        services: services.isNotEmpty
            ? services
            : fallback
                  .where((item) => item.type == ComplaintType.service)
                  .toList(growable: false),
        total: _int(stats['total']),
        unread: _int(stats['unread']),
      ),
    );
  }
}

class ComplaintDetailsResponseModel {
  const ComplaintDetailsResponseModel(this.complaint);
  final ComplaintEntity complaint;

  factory ComplaintDetailsResponseModel.fromJson(Map<String, dynamic> json) {
    final data = _map(json['data']);
    return ComplaintDetailsResponseModel(
      ComplaintModel.fromJson(_map(data['complaint'])).entity,
    );
  }
}

class ComplaintResponseModel {
  const ComplaintResponseModel(this.complaint);
  final ComplaintEntity complaint;

  factory ComplaintResponseModel.fromJson(Map<String, dynamic> json) =>
      ComplaintResponseModel(
        ComplaintModel.fromJson(_map(json['data'])).entity,
      );
}

class ComplaintUnreadCountResponseModel {
  const ComplaintUnreadCountResponseModel(this.count);
  final int count;

  factory ComplaintUnreadCountResponseModel.fromJson(
    Map<String, dynamic> json,
  ) => ComplaintUnreadCountResponseModel(
    _int(_map(json['data'])['unread_count']),
  );
}

Map<String, dynamic> _map(Object? value) =>
    value is Map ? Map<String, dynamic>.from(value) : <String, dynamic>{};

int _int(Object? value) => int.tryParse(value?.toString() ?? '') ?? 0;

bool _bool(Object? value) {
  if (value is bool) return value;
  if (value is num) return value != 0;
  return value?.toString().toLowerCase() == 'true' || value?.toString() == '1';
}

List<ComplaintEntity> _complaints(Object? value) => value is List
    ? value
          .whereType<Map>()
          .map(
            (item) =>
                ComplaintModel.fromJson(Map<String, dynamic>.from(item)).entity,
          )
          .toList(growable: false)
    : const [];
