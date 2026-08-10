import 'dart:convert';
import 'dart:developer';

/// THE single place the app turns an API error body into the string shown to
/// the worker. Every repository reaches it through
/// `ServerFailure.fromResponse`, so the logic is never duplicated in a widget.
///
/// [responseData] is whatever the server sent — with Dio that is
/// `e.response?.data`, already decoded to a `Map`/`List` when the response
/// carried a JSON content type, or left as a raw `String` when it did not
/// (an HTML error page, a gateway error, an empty body).
///
/// The message is returned **verbatim**: nothing is translated, rewritten,
/// capitalized, prefixed or suffixed — the API already answers in the right
/// language (the app sends `Accept-Language` on every request).
///
/// Priority, matching Laravel's standard error shapes:
///  a. `errors` — validation (422): every field's messages, in order, joined.
///  b. `message` — used exactly as returned.
///  c. `error`   — used exactly as returned.
///  d. a plain string body — used as-is (unless it is an HTML page).
///  e. nothing usable → [fallback].
///
/// [fallback] defaults to the empty string on purpose: this layer has no
/// `BuildContext` and must not invent an English sentence. An empty result
/// tells `localizedFailureMessage` to supply the app's localized generic
/// message instead, which keeps AR/EN correct.
String parseApiError(dynamic responseData, {String fallback = ''}) {
  final data = _decodeIfJsonString(responseData);

  if (data is Map) {
    // a. Validation bag: {"message": "...", "errors": {"email": ["..."]}}.
    //    Checked BEFORE `message`, because on a 422 Laravel's `message` is the
    //    generic "The given data was invalid." while `errors` holds the field
    //    reasons the worker actually needs.
    final validation = _joinMessages(data['errors']);
    if (validation.isNotEmpty) return validation;

    // b. message
    final fromMessage = _asMessage(data['message']);
    if (fromMessage.isNotEmpty) return fromMessage;

    // c. error
    final fromError = _asMessage(data['error']);
    if (fromError.isNotEmpty) return fromError;
  }

  // A bare list body (`["...", "..."]`) is still the server's wording.
  if (data is List) {
    final joined = _joinMessages(data);
    if (joined.isNotEmpty) return joined;
  }

  // d. A plain (non-JSON) string body — an HTML page is not a message.
  if (data is String) {
    if (data.trim().isNotEmpty && !_looksLikeHtml(data)) return data;
  }

  // e. Nothing usable. Log the raw body so the real cause is visible in the
  //    console instead of being swallowed.
  log('parseApiError: no usable message in response body → $responseData');
  return fallback;
}

/// Dio hands back a raw `String` whenever the response's content type was not
/// JSON — which is exactly what Laravel does when it returns an HTML error
/// page, and what a gateway returns on a 502.
///
/// A string that LOOKS like JSON is decoded so the rules above can read it. If
/// that decode fails the payload is malformed (truncated body, wrong
/// content-type on a broken response): `null` is returned so the caller falls
/// through to the safe fallback rather than printing `{"message": ` at the
/// worker — and the raw body is logged so the real cause stays debuggable.
/// A [FormatException] must never escape this function.
dynamic _decodeIfJsonString(dynamic responseData) {
  if (responseData is! String) return responseData;
  final trimmed = responseData.trim();
  if (trimmed.isEmpty) return responseData;
  if (!trimmed.startsWith('{') && !trimmed.startsWith('[')) return responseData;

  try {
    return jsonDecode(responseData);
  } on FormatException catch (e) {
    log('parseApiError: body is not valid JSON ($e) → $responseData');
    return null;
  }
}

/// A single value that may be a string, a number, or a nested bag of messages.
String _asMessage(dynamic value) {
  if (value == null) return '';
  if (value is String) return value;
  if (value is Map || value is List) return _joinMessages(value);
  return value.toString();
}

/// Flattens Laravel's `errors` shape — `{field: [msg, msg], other: msg}` — into
/// one readable string, preserving the order the server sent (`jsonDecode`
/// keeps insertion order). Each message is kept exactly as received; only the
/// newline between them is added.
String _joinMessages(dynamic value) {
  final collected = <String>[];

  void collect(dynamic node) {
    if (node == null) return;
    if (node is String) {
      if (node.isNotEmpty) collected.add(node);
      return;
    }
    if (node is Iterable) {
      for (final item in node) {
        collect(item);
      }
      return;
    }
    if (node is Map) {
      for (final item in node.values) {
        collect(item);
      }
      return;
    }
    final text = node.toString();
    if (text.isNotEmpty) collected.add(text);
  }

  collect(value);
  return collected.join('\n');
}

/// True for a body that is a web page rather than an API message (Laravel's
/// debug/error pages, a proxy's 502 page, …).
bool _looksLikeHtml(String body) {
  final start = body.trimLeft();
  if (start.startsWith('<')) return true;
  final lower = start.toLowerCase();
  return lower.contains('<!doctype html') || lower.contains('<html');
}
