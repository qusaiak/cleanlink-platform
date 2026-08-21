import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../config/constants/api_url_parameters.dart';
import '../../../../config/constants/skills_payload.dart';
import '../../../../config/language/app_language_info.dart';
import '../../domain/entities/worker_profile.dart';
import '../models/worker_profile_model.dart';

abstract class WorkerProfileRemoteDataSource {
  Future<WorkerProfileModel> getProfile();

  Future<WorkerProfileModel> updateAvailability(
    WorkerAvailability availability,
  );

  Future<WorkerProfileModel> updateProfile({
    String? fullname,
    String? email,
    String? address,
    String? phone,
    int? experienceYears,
    WorkerAvailability? status,
  });

  Future<WorkerProfileModel> updateProfileImage(XFile image);

  Future<List<WorkerSkill>> getAllSkills();

  Future<WorkerProfileModel> attachSkills(List<int> skillIds);

  Future<WorkerProfileModel> detachSkills(List<int> skillIds);
}

class WorkerProfileRemoteDataSourceImpl
    implements WorkerProfileRemoteDataSource {
  final Dio dio;

  WorkerProfileRemoteDataSourceImpl(this.dio);

  @override
  Future<WorkerProfileModel> getProfile() async {
    final response = await dio.get(ApiUrlParameters.workerProfilesMe);
    return WorkerProfileModel.fromMeJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<WorkerProfileModel> updateAvailability(
    WorkerAvailability availability,
  ) {
    return _putProfile({
      'status': WorkerProfileModel.availabilityCode(availability),
    });
  }

  @override
  Future<WorkerProfileModel> updateProfile({
    String? fullname,
    String? email,
    String? address,
    String? phone,
    int? experienceYears,
    WorkerAvailability? status,
  }) {
    final fields = <String, dynamic>{
      if (fullname != null) 'fullname': fullname,
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
      if (address != null) 'address': address,
      if (experienceYears != null) 'experience_years': experienceYears,
      if (status != null) 'status': WorkerProfileModel.availabilityCode(status),
    };
    return _putProfile(fields);
  }

  static bool _isSuccessStatus(int? status) =>
      status != null && status >= 200 && status < 300;

  @override
  Future<WorkerProfileModel> updateProfileImage(XFile image) async {
    final formData = FormData.fromMap({
      'image': MultipartFile.fromBytes(
        await image.readAsBytes(),
        filename: image.name,
      ),
    });
    final response = await dio.post(
      ApiUrlParameters.workerProfilesUpdateImage,
      data: formData,
      options: Options(validateStatus: _isSuccessStatus),
    );

    log(
      'updateProfileImage → status=${response.statusCode} '
      'body=${response.data}',
    );

    try {
      return WorkerProfileModel.fromMeJson(
        Map<String, dynamic>.from(response.data as Map),
      );
    } catch (e) {
      log(
        'updateProfileImage: response unparseable ($e) — re-fetching '
        'profile',
      );
      return getProfile();
    }
  }

  Future<WorkerProfileModel> _putProfile(Map<String, dynamic> body) async {
    final response = await dio.put(ApiUrlParameters.workerProfiles, data: body);
    return WorkerProfileModel.fromMeJson(response.data as Map<String, dynamic>);
  }

  static _SkillsAttempt? _knownGoodAttempt;

  @override
  Future<List<WorkerSkill>> getAllSkills() async {
    final languageCode = AppLanguageInfo.languageCode;

    final response = await _send(
      'GET ${ApiUrlParameters.skills}',
      () => dio.get(ApiUrlParameters.skills),
    );

    return WorkerProfileModel.skillsListFromResponse(
      response.data,
      languageCode: languageCode,
    );
  }

  @override
  Future<WorkerProfileModel> attachSkills(List<int> skillIds) => _changeSkills(
    label: 'ATTACH',
    path: ApiUrlParameters.updateSkills,
    isDelete: false,
    skillIds: skillIds,
  );

  @override
  Future<WorkerProfileModel> detachSkills(List<int> skillIds) => _changeSkills(
    label: 'DETACH',
    path: ApiUrlParameters.detachSkills,
    isDelete: true,
    skillIds: skillIds,
  );

  Future<WorkerProfileModel> _changeSkills({
    required String label,
    required String path,
    required bool isDelete,
    required List<int> skillIds,
  }) async {
    final attempts = _attemptsFor(isDelete);
    DioException? lastValidationFailure;

    for (final attempt in attempts) {
      final body = attempt.payload.body(skillIds);
      final description = '$label ${attempt.describe()}';

      try {
        final response = await _send(
          description,
          () => _perform(
            attempt: attempt,
            path: path,
            isDelete: isDelete,
            body: body,
          ),
        );

        _knownGoodAttempt = attempt;
        log(
          '✅ $label WORKED — body shape ${attempt.payload.label} sent as '
          '${attempt.transport.name.toUpperCase()}.\n'
          '   Pin it by making this the `preferred` shape in SkillsPayload.',
          name: 'Skills',
        );

        return await _parseWorker(description, response);
      } on DioException catch (e) {
        if (e.response?.statusCode != 422) rethrow;
        lastValidationFailure = e;

        if (_knownGoodAttempt == attempt) _knownGoodAttempt = null;
      }
    }

    log(
      '❌ $label FAILED — every candidate body shape was rejected with 422.\n'
      '   Tried: ${attempts.map((a) => a.describe()).join(', ')}\n'
      '   Read the `errors` bag logged above: it names the field the backend '
      'wants. Move that shape to the front of SkillsPayload.candidates.',
      name: 'Skills',
    );

    throw lastValidationFailure!;
  }

  List<_SkillsAttempt> _attemptsFor(bool isDelete) {
    final attempts = <_SkillsAttempt>[
      for (final payload in SkillsPayload.candidates)
        _SkillsAttempt(payload, _SkillsTransport.body),
      if (isDelete)
        for (final payload in SkillsPayload.candidates)
          _SkillsAttempt(payload, _SkillsTransport.query),
    ];

    final known = _knownGoodAttempt;
    if (known == null) return attempts;

    final normalized = isDelete
        ? known
        : _SkillsAttempt(known.payload, _SkillsTransport.body);

    return [normalized, ...attempts.where((a) => a != normalized)];
  }

  Future<Response<dynamic>> _perform({
    required _SkillsAttempt attempt,
    required String path,
    required bool isDelete,
    required Map<String, dynamic> body,
  }) {
    final options = Options(
      contentType: Headers.jsonContentType,

      listFormat: ListFormat.multiCompatible,
    );

    if (!isDelete) return dio.post(path, data: body, options: options);

    return dio.delete(
      path,
      data: body,
      queryParameters: attempt.transport == _SkillsTransport.query
          ? body
          : null,
      options: options,
    );
  }

  Future<WorkerProfileModel> _parseWorker(
    String label,
    Response<dynamic> response,
  ) async {
    try {
      return WorkerProfileModel.fromMeJson(
        Map<String, dynamic>.from(response.data as Map),
      );
    } catch (e) {
      log(
        '$label: the request SUCCEEDED (${response.statusCode}) but its body '
        'could not be parsed ($e) — re-reading the profile instead of '
        'reporting a failure.\n  raw body: ${response.data}',
        name: 'Skills',
      );
      return getProfile();
    }
  }

  Future<Response<dynamic>> _send(
    String label,
    Future<Response<dynamic>> Function() request,
  ) async {
    try {
      final response = await request();
      _logCall(label, response.requestOptions, response: response);
      _ensureBodyStatusIsSuccess(label, response);
      return response;
    } on DioException catch (e) {
      _logCall(label, e.requestOptions, response: e.response, error: e);
      rethrow;
    }
  }

  void _logCall(
    String label,
    RequestOptions options, {
    Response<dynamic>? response,
    DioException? error,
  }) {
    log(
      '$label\n'
      '  method   : ${options.method}\n'
      '  url      : ${options.uri}\n'
      '  headers  : ${_redactHeaders(options.headers)}\n'
      '  query    : ${options.queryParameters}\n'
      '  body(raw): ${options.data}\n'
      '  body(json): ${_encode(options.data)}\n'
      '  status   : ${response?.statusCode ?? '— no response (${error?.type})'}\n'
      '  response : ${response?.data}',
      name: 'Skills',
    );

    if (response?.statusCode == 422) {
      final data = response?.data;
      final errors = data is Map ? data['errors'] : null;
      log(
        '$label → 422 VALIDATION FAILED.\n'
        '  sent     : ${_encode(options.data)}\n'
        '  errors   : ${errors ?? data}\n'
        '  → the key(s) named above are what the backend expects; make that '
        'shape the `preferred` one in SkillsPayload.',
        name: 'Skills',
      );
    }
  }

  String _encode(dynamic data) {
    if (data == null) return 'null';
    try {
      return jsonEncode(data);
    } catch (_) {
      return '<not JSON-encodable: ${data.runtimeType}>';
    }
  }

  Map<String, dynamic> _redactHeaders(Map<String, dynamic> headers) {
    final copy = Map<String, dynamic>.from(headers);
    var hasAuth = false;
    for (final key in copy.keys) {
      if (key.toLowerCase() == 'authorization') {
        hasAuth = true;
        final value = copy[key]?.toString() ?? '';

        final tail = value.length > 4 ? value.substring(value.length - 4) : '';
        copy[key] = 'Bearer ***$tail';
      }
    }
    if (!hasAuth) copy['Authorization'] = '<<< MISSING — request is anonymous';
    return copy;
  }

  void _ensureBodyStatusIsSuccess(String label, Response<dynamic> response) {
    final data = response.data;
    if (data is! Map) return;

    final raw = data['status'];
    final bodyStatus = raw is num ? raw.toInt() : int.tryParse('$raw');
    if (bodyStatus == null) return;
    if (bodyStatus >= 200 && bodyStatus < 300) return;

    log(
      '$label → HTTP ${response.statusCode} but the body reports '
      'status=$bodyStatus — treated as a FAILURE.',
      name: 'Skills',
    );

    throw DioException(
      requestOptions: response.requestOptions,
      response: response,
      type: DioExceptionType.badResponse,
      error: 'Body status $bodyStatus on a ${response.statusCode} response',
    );
  }
}

enum _SkillsTransport { body, query }

class _SkillsAttempt {
  final SkillsPayload payload;
  final _SkillsTransport transport;

  const _SkillsAttempt(this.payload, this.transport);

  String describe() => '${payload.label} via ${transport.name}';

  @override
  bool operator ==(Object other) =>
      other is _SkillsAttempt &&
      other.payload.field == payload.field &&
      other.payload.asArray == payload.asArray &&
      other.transport == transport;

  @override
  int get hashCode => Object.hash(payload.field, payload.asArray, transport);
}
