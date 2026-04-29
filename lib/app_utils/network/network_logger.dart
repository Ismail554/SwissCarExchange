import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Centralized request/response/error logging.
class NetworkLogger {
  NetworkLogger._();

  static void request(RequestOptions options) {
    final query = options.queryParameters.isNotEmpty
        ? '?${Uri(queryParameters: options.queryParameters).query}'
        : '';

    log('➡️ [${options.method}] ${options.uri}$query', name: 'REQUEST');

    final headers = Map<String, dynamic>.from(options.headers);
    if (headers.containsKey('Authorization')) headers['Authorization'] = 'Bearer ***';
    log('📋 Headers: ${jsonEncode(headers)}', name: 'REQUEST');

    _logBody(options);
  }

  static void response(Response response) {
    final body = jsonEncode(response.data);
    log('✅ [${response.statusCode}] ${response.requestOptions.uri}', name: 'RESPONSE');
    log('📥 Body: $body', name: 'RESPONSE');

    debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    debugPrint('✅ [${response.statusCode}] ${response.requestOptions.uri}');
    debugPrint('Body: $body');
    debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  }

  static void error(DioException e) {
    final status = e.response?.statusCode ?? 'NO STATUS';
    log('❌ [$status] ${e.requestOptions.uri}', name: 'ERROR');
    log(e.message ?? 'Unknown', name: 'ERROR');

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
        log('📤 Query: ${jsonEncode(options.queryParameters)}', name: 'REQUEST');
      }
      return;
    }

    if (options.data is FormData) {
      final fd = options.data as FormData;
      log(
        '📦 FormData: ${jsonEncode({
          'fields': {for (var e in fd.fields) e.key: e.value},
          'files': [for (var e in fd.files) {'field': e.key, 'filename': e.value.filename}],
        })}',
        name: 'REQUEST',
      );
    } else {
      log('📤 Body: ${jsonEncode(options.data)}', name: 'REQUEST');
    }
  }
}