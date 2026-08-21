import 'dart:convert';
import 'dart:developer';

String parseApiError(dynamic responseData, {String fallback = ''}) {
  final data = _decodeIfJsonString(responseData);

  if (data is Map) {
    final validation = _joinMessages(data['errors']);
    if (validation.isNotEmpty) return validation;

    final fromMessage = _asMessage(data['message']);
    if (fromMessage.isNotEmpty) return fromMessage;

    final fromError = _asMessage(data['error']);
    if (fromError.isNotEmpty) return fromError;
  }

  if (data is List) {
    final joined = _joinMessages(data);
    if (joined.isNotEmpty) return joined;
  }

  if (data is String) {
    if (data.trim().isNotEmpty && !_looksLikeHtml(data)) return data;
  }

  log('parseApiError: no usable message in response body → $responseData');
  return fallback;
}

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

String _asMessage(dynamic value) {
  if (value == null) return '';
  if (value is String) return value;
  if (value is Map || value is List) return _joinMessages(value);
  return value.toString();
}

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

bool _looksLikeHtml(String body) {
  final start = body.trimLeft();
  if (start.startsWith('<')) return true;
  final lower = start.toLowerCase();
  return lower.contains('<!doctype html') || lower.contains('<html');
}
