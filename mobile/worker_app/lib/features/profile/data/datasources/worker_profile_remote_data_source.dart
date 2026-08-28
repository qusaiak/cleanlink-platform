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
    method: 'POST',
    skillIds: skillIds,
  );

  @override
  Future<WorkerProfileModel> detachSkills(List<int> skillIds) => _changeSkills(
    label: 'DETACH',
    path: ApiUrlParameters.detachSkills,
    method: 'DELETE',
    skillIds: skillIds,
  );

  Future<WorkerProfileModel> _changeSkills({
    required String label,
    required String path,
    required String method,
    required List<int> skillIds,
  }) async {
    final body = SkillsPayload.body(skillIds);
    final options = Options(
      contentType: Headers.jsonContentType,
      listFormat: ListFormat.multiCompatible,
    );
    final response = await _send(
      '$label {"skill_ids": [<int>]}',
      () => method == 'DELETE'
          ? dio.delete(path, data: body, options: options)
          : dio.post(path, data: body, options: options),
    );
    return _parseWorker(label, response);
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
        '  errors   : ${errors ?? data}',
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
