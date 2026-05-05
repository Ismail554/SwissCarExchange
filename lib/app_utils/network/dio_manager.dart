import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:rionydo/app_helper/secure_storage_helper.dart';
import 'package:rionydo/app_utils/network/token_manager.dart';
import 'either.dart';
import 'enums.dart';
import 'error_handler.dart';
import 'network_logger.dart';

// Isolate-safe JSON deep clone
dynamic _processJson(dynamic data) => jsonDecode(jsonEncode(data));

class DioManager {
  DioManager._();

  static final Dio _dio = Dio(
    BaseOptions(
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
    ),
  );

  // ─── Initialization ────────────────────────────────────────────────────────

  static void init() {
    _dio.interceptors
      ..clear()
      ..add(_buildInterceptor());
  }

  static InterceptorsWrapper _buildInterceptor() {
    return InterceptorsWrapper(
      onRequest: _onRequest,
      onResponse: _onResponse,
      onError: _onError,
    );
  }

  // ─── Interceptor Handlers ──────────────────────────────────────────────────

  static Future<void> _onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    await _attachAuthHeader(options);
    await _attachDeviceId(options);
    NetworkLogger.request(options);
    handler.next(options);
  }

  static Future<void> _onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) async {
    NetworkLogger.response(response);
    handler.next(response);
  }

  static Future<void> _onError(
    DioException e,
    ErrorInterceptorHandler handler,
  ) async {
    NetworkLogger.error(e);

    final isUnauthorized = e.response?.statusCode == 401;
    final isFirstAttempt = e.requestOptions.extra['retry'] != true;

    if (isUnauthorized && isFirstAttempt) {
      final retried = await _retryWithRefreshedToken(e.requestOptions);
      if (retried != null) return handler.resolve(retried);
    }

    handler.next(e);
  }

  // ─── Helpers ───────────────────────────────────────────────────────────────

  static Future<void> _attachAuthHeader(RequestOptions options) async {
    if (options.extra['skipAuth'] == true) return;

    final token = await TokenManager.getValidToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token'; // Changed back to Bearer since JWT didn't work. We will log the exact header.
      print('AUTH HEADER ATTACHED: Bearer ${token.substring(0, 15)}...');
    } else {
      print('AUTH HEADER ATTACHED: NONE');
      appLog('⚠️ No token, proceeding unauthenticated', tag: 'AUTH');
    }
  }

  static Future<void> _attachDeviceId(RequestOptions options) async {
    try {
      final uuid = await SecureStorageHelper.getUuid();
      options.headers['X-Device-ID'] = uuid;
    } catch (e) {
      appLog('⚠️ UUID header failed: $e', tag: 'HEADER');
    }
  }

  static Future<Response?> _retryWithRefreshedToken(
    RequestOptions original,
  ) async {
    final newToken = await TokenManager.getValidToken(forceRefresh: true);
    if (newToken == null) return null;

    try {
      final opts = original
        ..headers['Authorization'] = 'Bearer $newToken'
        ..extra['retry'] = true;
      final response = await _dio.fetch(opts);
      appLog('🔁 Retry succeeded', tag: 'RETRY');
      return response;
    } catch (e) {
      appLog('❌ Retry failed: $e', tag: 'RETRY');
      return null;
    }
  }

  // ─── Public API ────────────────────────────────────────────────────────────

  static E apiRequest({
    required String url,
    required Methods method,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
    bool skipAuth = false,
    int successCode = 200,
    List<int>? altCodes,
  }) async {
    try {
      final options = Options(extra: {'skipAuth': skipAuth});

      final response = await _send(
        url: url,
        method: method,
        body: body,
        queryParameters: queryParameters,
        options: options,
      );

      final validCodes = {successCode, ...?altCodes};

      if (validCodes.contains(response.statusCode)) {
        return right(await compute(_processJson, response.data));
      }

      return left(ErrorHandler.fromResponse(response));
    } on DioException catch (e) {
      if (e.response != null) {
        appLog('RAW API ERROR RESPONSE: ${e.response?.data}', tag: 'API_RAW');
      }
      return left(ErrorHandler.fromDio(e));
    } catch (e) {
      appLog('⚠️ Unexpected: $e', tag: 'API');
      return left('Unexpected error occurred. Please try again.');
    }
  }

  static E multipartRequest({
    required String url,
    required Map<String, dynamic> fields,
    String? filePath,
    String fileFieldName = 'file',
    bool skipAuth = false,
    int successCode = 200,
    Methods method = Methods.post,
  }) async {
    try {
      final formData = await _buildFormData(fields, filePath, fileFieldName);
      final options = Options(extra: {'skipAuth': skipAuth});

      final response = await _send(
        url: url,
        method: method,
        body: formData,
        options: options,
      );

      if (response.statusCode == successCode || response.statusCode == 200) {
        final parsed = await compute(_processJson, response.data);
        appLog('✅ Upload success [$url]', tag: 'UPLOAD');
        return right(parsed);
      }

      return left(ErrorHandler.fromResponse(response));
    } on DioException catch (e) {
      return left(ErrorHandler.fromDio(e));
    } catch (e) {
      return left('Unexpected error. Please try again.');
    }
  }

  // ─── Internal ─────────────────────────────────────────────────────────────

  static Future<Response> _send({
    required String url,
    required Methods method,
    dynamic body,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return switch (method) {
      Methods.get => _dio.get(
        url,
        queryParameters: queryParameters,
        data: body,
        options: options,
      ),
      Methods.post => _dio.post(url, data: body, options: options),
      Methods.put => _dio.put(url, data: body, options: options),
      Methods.patch => _dio.patch(url, data: body, options: options),
      Methods.delete => _dio.delete(url, data: body, options: options),
    };
  }

  static Future<FormData> _buildFormData(
    Map<String, dynamic> fields,
    String? filePath,
    String fileFieldName,
  ) async {
    final formData = FormData();

    fields.forEach(
      (key, value) => formData.fields.add(MapEntry(key, value.toString())),
    );

    if (filePath != null &&
        filePath.isNotEmpty &&
        File(filePath).existsSync()) {
      formData.files.add(
        MapEntry(
          fileFieldName,
          await MultipartFile.fromFile(
            filePath,
            filename: filePath.split('/').last,
          ),
        ),
      );
      appLog('📸 Attached file: $filePath', tag: 'UPLOAD');
    }

    return formData;
  }
  // ─── Authentication ───────────────────────────────────────────────────────

  static Future<void> logout() async {
    await TokenManager.logout();
    appLog('🚪 User logged out, session cleared', tag: 'AUTH');
  }
}
