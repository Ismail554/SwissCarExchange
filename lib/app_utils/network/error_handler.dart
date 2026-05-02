import 'package:dio/dio.dart';
import 'dart:io';

/// Converts raw Dio / HTTP errors into user-friendly strings.
class ErrorHandler {
  ErrorHandler._();

  static String fromDio(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return 'Connection timeout. Please try again.';

      case DioExceptionType.badResponse:
        if (e.response != null) return fromResponse(e.response!);
        return 'Server returned an invalid response.';

      default:
        if (e.error is SocketException) {
          return 'No internet connection. Please check your network.';
        }
        return e.message ?? 'Something went wrong. Please try again.';
    }
  }

  static String fromResponse(Response response) {
    final status = response.statusCode ?? 0;
    final data = response.data;

    if (status >= 500) return 'Server error. Please try again later.';
    if (status == 404) return 'Something went wrong. Try again later.';

    if (status >= 400) {
      if (data is Map<String, dynamic>) return _parseErrorMap(data, status);
      if (data is String) return data;
      return 'Request failed with status $status.';
    }

    return 'Unexpected server response ($status).';
  }

  static String _parseErrorMap(Map<String, dynamic> data, int status) {
    // We already have 'import 'dart:developer';' at the top of other files?
    // Let's use print instead if dart:developer is not imported here, or just print it.
    print('API_ERROR_MAP (status $status): $data');

    // Special error code handling
    final errorCodes = data['error_code'];
    if (errorCodes is List && errorCodes.isNotEmpty) {
      if (errorCodes.first == 'account_unverified_otp_sent') {
        return 'UNVERIFIED_ACCOUNT_OTP_SENT';
      }
    }

    // Try validation fields first, then flat message fields
    final msg = _validationMessage(data) ??
        _nestedErrorMessage(data) ??
        _flatMessage(data) ??
        _nonFieldErrors(data) ??
        _fallbackValidationMessage(data);

    return msg ?? 'This email is already registered ($status).';
  }

  static String? _fallbackValidationMessage(Map<String, dynamic> data) {
    // If there are no standard message keys, maybe the data itself is the validation map
    // e.g. {"email": ["Email already exists"]}
    final keys = data.keys.where((k) => k != 'status' && k != 'error_code').toList();
    if (keys.isNotEmpty) {
      final firstKey = keys.first;
      final val = data[firstKey];
      if (val is List && val.isNotEmpty) return '$firstKey: ${val.first}';
      if (val is String) return '$firstKey: $val';
    }
    return null;
  }

  static String? _flatMessage(Map<String, dynamic> data) =>
      (data['error'] is String ? data['error'] : null) ??
      data['detail'] ??
      data['message'] ??
      data['msg'] ??
      data['error_message'];

  static String? _nestedErrorMessage(Map<String, dynamic> data) {
    final error = data['error'];
    if (error is Map<String, dynamic>) {
      return error['message'] ?? error['detail'] ?? error['error'];
    }
    return null;
  }

  static String? _validationMessage(Map<String, dynamic> data) {
    final errors = data['errors'];
    if (errors is Map<String, dynamic>) {
      final first = errors.values.firstOrNull;
      if (first is List && first.isNotEmpty) return first.first.toString();
      if (first is String) return first;
    }
    if (errors is List && errors.isNotEmpty) return errors.first.toString();
    return null;
  }

  static String? _nonFieldErrors(Map<String, dynamic> data) {
    final errors = data['non_field_errors'];
    if (errors is List && errors.isNotEmpty) return errors.first.toString();
    return null;
  }
}