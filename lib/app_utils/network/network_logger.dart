import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Reference function for consistent logging
void appLog(String message, {String tag = 'APP'}) {
  log(message, name: tag);
}

/// Centralized request/response/error logging.
class NetworkLogger {
  NetworkLogger._();

  static void request(RequestOptions options) {
    final query = options.queryParameters.isNotEmpty
        ? '?${Uri(queryParameters: options.queryParameters).query}'
        : '';

    appLog('➡️ [${options.method}] ${options.uri}$query', tag: 'REQUEST');

    final headers = Map<String, dynamic>.from(options.headers);
    if (headers.containsKey('Authorization')) headers['Authorization'] = 'Bearer ***';
    appLog('📋 Headers: ${jsonEncode(headers)}', tag: 'REQUEST');

    _logBody(options);

    debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    debugPrint('➡️ REQUEST [${options.method}] ${options.uri}$query');
    debugPrint('Headers: ${jsonEncode(headers)}');
    
    if (options.data != null) {
      if (options.data is FormData) {
        final fd = options.data as FormData;
        debugPrint('Body (FormData): ${jsonEncode({
          'fields': {for (var e in fd.fields) e.key: e.value},
          'files': [for (var e in fd.files) {'field': e.key, 'filename': e.value.filename}],
        })}');
      } else {
        debugPrint('Body: ${jsonEncode(options.data)}');
      }
    } else if (options.queryParameters.isNotEmpty) {
      debugPrint('Query: ${jsonEncode(options.queryParameters)}');
    }
    debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  }

  static void response(Response response) {
    final body = jsonEncode(response.data);
    appLog('✅ [${response.statusCode}] ${response.requestOptions.uri}', tag: 'RESPONSE');
    appLog('📥 Body: $body', tag: 'RESPONSE');

    debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    debugPrint('✅ [${response.statusCode}] ${response.requestOptions.uri}');
    debugPrint('Body: $body');
    debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  }

  static void error(DioException e) {
    final status = e.response?.statusCode ?? 'NO STATUS';
    appLog('❌ [$status] ${e.requestOptions.uri}', tag: 'ERROR');
    appLog(e.message ?? 'Unknown', tag: 'ERROR');

    debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    debugPrint('❌ [$status] ${e.requestOptions.uri}');
    if (e.requestOptions.data != null) {
      debugPrint('Request: ${jsonEncode(e.requestOptions.data)}');
    }
    if (e.response != null) {
      debugPrint('Response: ${jsonEncode(e.response?.data)}');
    }
    debugPrint('Message: ${e.message} | Type: ${e.type}');
    debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  }

  static void _logBody(RequestOptions options) {
    if (options.data == null) {
      if (options.queryParameters.isNotEmpty) {
        appLog('📤 Query: ${jsonEncode(options.queryParameters)}', tag: 'REQUEST');
      }
      return;
    }

    if (options.data is FormData) {
      final fd = options.data as FormData;
      appLog(
        '📦 FormData: ${jsonEncode({
          'fields': {for (var e in fd.fields) e.key: e.value},
          'files': [for (var e in fd.files) {'field': e.key, 'filename': e.value.filename}],
        })}',
        tag: 'REQUEST',
      );
    } else {
      appLog('📤 Body: ${jsonEncode(options.data)}', tag: 'REQUEST');
    }
  }
}