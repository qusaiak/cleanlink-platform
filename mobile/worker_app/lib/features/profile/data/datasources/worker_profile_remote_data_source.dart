import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../config/constants/api_url_parameters.dart';
import '../../../../config/constants/skills_payload.dart';
import '../../../../config/language/app_language_info.dart';
import '../../domain/entities/worker_profile.dart';
import '../models/worker_profile_model.dart';

/// Remote data source contract for the worker profile. Implementations return
/// a model or throw a [DioException]; the repository maps to `Either<Failure,T>`.
abstract class WorkerProfileRemoteDataSource {
  Future<WorkerProfileModel> getProfile();

  Future<WorkerProfileModel> updateAvailability(
    WorkerAvailability availability,
  );

  /// Updates the editable profile fields; only the non-null ones are sent.
  Future<WorkerProfileModel> updateProfile({
    String? fullname,
    String? email,
    String? address,
    String? phone,
    int? experienceYears,
    WorkerAvailability? status,
  });

  /// Updates ONLY the profile photo via the dedicated
  /// `POST /api/worker-profiles/update-image` endpoint, sending the picked
  /// [image] as a multipart file (the backend validates `image` as
  /// `required|image`). Returns the full worker profile the server echoes
  /// (with `profile` and `worker_profile` loaded), which becomes the new
  /// source of truth for the avatar.
  Future<WorkerProfileModel> updateProfileImage(XFile image);

  /// The skills DICTIONARY (`GET /api/skills`) — every assignable skill, with
  /// the names already localized by the server from the `Accept-Language`
  /// header the shared Dio interceptor attaches.
  Future<List<WorkerSkill>> getAllSkills();

  /// ATTACHES [skillIds] to the worker (`POST /api/worker/update-skills`) and
  /// returns the FULL updated user the response carries — the new source of
  /// truth for skills, profile fields and avatar alike.
  Future<WorkerProfileModel> attachSkills(List<int> skillIds);

  /// DETACHES [skillIds] from the worker (`DELETE /api/worker/detach-skills`).
  /// Same request body and same response shape as [attachSkills].
  Future<WorkerProfileModel> detachSkills(List<int> skillIds);
}

/// Real Dio-backed implementation (production path). Wire this in place of the
/// fake source in `injection_container.dart` once the API base URL is set.
class WorkerProfileRemoteDataSourceImpl
    implements WorkerProfileRemoteDataSource {
  final Dio dio;

  WorkerProfileRemoteDataSourceImpl(this.dio);

  @override
  Future<WorkerProfileModel> getProfile() async {
    // GET /api/worker-profiles/me — authenticated by the bearer token the
    // shared Dio interceptor attaches (saved from the login flow); nothing
    // else is sent.
    final response = await dio.get(ApiUrlParameters.workerProfilesMe);
    return WorkerProfileModel.fromMeJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<WorkerProfileModel> updateAvailability(
    WorkerAvailability availability,
  ) {
    // A status change is just a one-field profile update, so it goes through
    // the same PUT /api/worker-profiles endpoint (`busy` is rejected upstream
    // by UpdateAvailabilityUseCase before this is ever reached).
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
    // Every field optional; send ONLY what changed, never nulls/empties for
    // untouched fields. JSON PUT — the photo goes through [updateProfileImage].
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

  /// Any 2xx is a success — 200, but also 201 (created) and 204 (no body).
  static bool _isSuccessStatus(int? status) =>
      status != null && status >= 200 && status < 300;

  @override
  Future<WorkerProfileModel> updateProfileImage(XFile image) async {
    // POST /api/worker-profiles/update-image — the DEDICATED image endpoint.
    // The backend validates `image` as `required|image|mimes:jpeg,png,jpg,svg`,
    // stores it on the `profile_images` disk, updates `profiles.image`, and
    // returns the full worker with `profile` + `worker_profile` loaded — the
    // same nested shape as `/me`, so `fromMeJson` parses it.
    //
    // The XFile is attached from its bytes (`fromBytes`, not `fromFile`) so it
    // also works on web. Bearer token added by the shared Dio interceptor.
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

    // The server echoes the full worker; parse it. If the body is ever empty
    // or unparseable, re-fetch the profile so the new URL still comes from the
    // source of truth rather than reporting a failure on a successful upload.
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

  /// Sends [body] to `PUT /api/worker-profiles` and parses the nested worker
  /// object it returns (same shape as `/me`). Bearer token added by the shared
  /// Dio interceptor.
  Future<WorkerProfileModel> _putProfile(Map<String, dynamic> body) async {
    final response = await dio.put(ApiUrlParameters.workerProfiles, data: body);
    return WorkerProfileModel.fromMeJson(response.data as Map<String, dynamic>);
  }

  // ==========================================================================
  // SKILLS
  //
  // The bearer token and `Accept-Language` come from the shared Dio
  // interceptor and are never set here. Everything else about these three
  // calls — the body shape, the transport, the logging, the success test and
  // the parsing — lives below.
  // ==========================================================================

  /// The request shape that last WORKED, remembered for the rest of the run so
  /// only the very first attach/detach can pay for a negotiation round trip.
  static _SkillsAttempt? _knownGoodAttempt;

  @override
  Future<List<WorkerSkill>> getAllSkills() async {
    // The language the dictionary is fetched in — captured BEFORE the request
    // so the parsed names are filed under the language they were actually
    // requested in, even if the worker switches language mid-flight.
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

  /// Runs an attach or a detach, negotiating the request shape if it has to.
  ///
  /// The backend's expected field name was never confirmed, and a wrong one is
  /// indistinguishable from a broken feature: Laravel replies **422**, writes
  /// nothing, and the screen just does not change. So each shape in
  /// [SkillsPayload.candidates] is tried in turn, and — for DELETE only — each
  /// is tried a second time with the ids in the QUERY STRING, because a JSON
  /// body on a DELETE is dropped by some server stacks before PHP ever sees it.
  ///
  /// Retrying is safe precisely because it is limited to 422: a validation
  /// refusal means the server did not touch the database, so no attempt can
  /// double-apply. Any other status (401, 403, 404, 500, a timeout) aborts
  /// immediately and propagates with the API's own message intact.
  ///
  /// The winning combination is logged in capitals and cached in
  /// [_knownGoodAttempt].
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

        // This shape is the contract — every later call goes straight to it.
        _knownGoodAttempt = attempt;
        log(
          '✅ $label WORKED — body shape ${attempt.payload.label} sent as '
          '${attempt.transport.name.toUpperCase()}.\n'
          '   Pin it by making this the `preferred` shape in SkillsPayload.',
          name: 'Skills',
        );

        return await _parseWorker(description, response);
      } on DioException catch (e) {
        // Only a validation refusal is retryable — see the doc comment.
        if (e.response?.statusCode != 422) rethrow;
        lastValidationFailure = e;
        // The cached shape just stopped working; stop trusting it.
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

    // Propagate the LAST 422 so the worker still sees the API's own wording.
    throw lastValidationFailure!;
  }

  /// The attempts to make, cheapest first: the remembered shape (if any), then
  /// every candidate as a JSON body, then — DELETE only — every candidate again
  /// with the ids in the query string.
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

    // The learned FIELD NAME is shared between attach and detach; the query
    // transport is a DELETE-only workaround, so it is normalized away here
    // rather than mislabelling a POST as "via query".
    final normalized = isDelete
        ? known
        : _SkillsAttempt(known.payload, _SkillsTransport.body);

    // Put the known-good one first; keep the rest as a safety net in case the
    // backend contract changes under a running app.
    return [normalized, ...attempts.where((a) => a != normalized)];
  }

  /// Issues one attempt. `data:` is ALWAYS passed — including on DELETE, which
  /// is the only way Dio puts a body on that verb — and the query variant adds
  /// the same ids as `field[]=4`, the bracketed form PHP parses into an array.
  Future<Response<dynamic>> _perform({
    required _SkillsAttempt attempt,
    required String path,
    required bool isDelete,
    required Map<String, dynamic> body,
  }) {
    final options = Options(
      contentType: Headers.jsonContentType,
      // `multiCompatible` renders a list as `skill_ids[]=4&skill_ids[]=7`.
      // Plain `multi` (`skill_ids=4`) is NOT parsed as an array by PHP.
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

  /// Turns a SUCCESSFUL response into a model, keeping the network step and the
  /// parsing step strictly apart.
  ///
  /// By the time this runs the server has already applied the change. A problem
  /// reading the echo is therefore NOT a failed request, and must never be
  /// reported as one — that is exactly what would make a working attach look
  /// broken and get rolled back on screen. `fromMeJson` is written to tolerate
  /// missing/null/oddly-typed fields, so this should not trigger; if it somehow
  /// does, the profile is re-read so state still converges on the truth.
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

  /// Runs a skills call, logging it end to end and validating what came back.
  ///
  /// Every one of the three endpoints goes through here so they behave
  /// identically:
  ///  - the full URL, the method, the headers (bearer token REDACTED), the
  ///    query string, the exact JSON body, the status code and the RAW response
  ///    body are logged for each attempt;
  ///  - success requires BOTH a 2xx HTTP status (enforced by Dio's
  ///    `validateStatus`, which throws otherwise) AND a 2xx body `status` — the
  ///    body's own field is never trusted on its own, and never on its own
  ///    ignored;
  ///  - a 422 has its full `errors` bag logged, because that bag is what names
  ///    the field the backend expects.
  ///
  /// Failures leave as [DioException]s, which is what the repository already
  /// maps onto the app's `Failure` types — so the API's own message survives.
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

  /// One log block per call: what was sent, and what came back verbatim.
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

    // Laravel's 422 bag is THE answer to "what is the field actually called?".
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

  /// The body exactly as it goes on the wire — this is what proves the ids are
  /// real JSON numbers in a real JSON array (`{"skill_ids":[4]}`) rather than
  /// strings or a stringified array (`{"skill_ids":"[4]"}`).
  String _encode(dynamic data) {
    if (data == null) return 'null';
    try {
      return jsonEncode(data);
    } catch (_) {
      return '<not JSON-encodable: ${data.runtimeType}>';
    }
  }

  /// The request headers with the bearer token masked — the URL and the rest of
  /// the headers are worth logging, the credential is not. Also makes it
  /// obvious at a glance WHETHER an Authorization header was attached at all,
  /// which is what separates a real 401 from a missing token.
  Map<String, dynamic> _redactHeaders(Map<String, dynamic> headers) {
    final copy = Map<String, dynamic>.from(headers);
    var hasAuth = false;
    for (final key in copy.keys) {
      if (key.toLowerCase() == 'authorization') {
        hasAuth = true;
        final value = copy[key]?.toString() ?? '';
        // Keep the last 4 characters: enough to tell two tokens apart in a log,
        // useless to anyone who finds it.
        final tail = value.length > 4 ? value.substring(value.length - 4) : '';
        copy[key] = 'Bearer ***$tail';
      }
    }
    if (!hasAuth) copy['Authorization'] = '<<< MISSING — request is anonymous';
    return copy;
  }

  /// Rejects a 2xx HTTP response whose BODY reports a non-2xx `status`.
  ///
  /// Some Laravel handlers answer `200 OK` with `{"status": 422, ...}` in the
  /// envelope. Parsing that as a success would hand the UI an empty worker and
  /// silently discard the server's message, so it is converted into the same
  /// [DioException] a real error status produces — which routes it through
  /// `ServerFailure.fromDioError` → `parseApiError` like every other failure.
  ///
  /// A body with no `status` field, or a non-numeric one, is left alone: the
  /// HTTP status already said 2xx and inventing a failure here would break
  /// endpoints that simply do not use the envelope.
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

/// How the skill ids travel to the server.
enum _SkillsTransport {
  /// In the JSON request body (`data:` — the only way Dio bodies a DELETE).
  body,

  /// In the query string as `field[]=4`, for stacks that drop a DELETE body.
  query,
}

/// One (body shape × transport) combination the data source can try.
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
