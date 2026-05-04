import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:rionydo/app_utils/constants/api_service.dart';
import 'package:rionydo/app_utils/network/dio_manager.dart';
import 'package:rionydo/app_utils/network/enums.dart';

/// Resolves the MIME content-type from a file extension.
String mimeTypeFor(String filePath) {
  final ext = filePath.split('.').last.toLowerCase();
  switch (ext) {
    case 'pdf':
      return 'application/pdf';
    case 'jpg':
    case 'jpeg':
      return 'image/jpeg';
    case 'png':
    default:
      return 'image/png';
  }
}

class S3UploadHelper {
  S3UploadHelper._();

  // ─── Step 1: Get Pre-Signed URL ─────────────────────────────────────────────
  /// Returns `{presigned_url, public_url}` or null on failure.
  static Future<Map<String, String>?> getPresignedUrl({
    required String contentType,
    required String fileName,
    String? presignedEndpoint,
    bool skipAuth = false,
  }) async {
    debugPrint('S3: ▶️ Requesting presigned URL for "$fileName" ($contentType)');
    final response = await DioManager.apiRequest(
      url: presignedEndpoint ?? ApiService.presignedUrl,
      method: Methods.get,
      queryParameters: {'content_type': contentType, 'file_name': fileName},
      skipAuth: skipAuth,
    );

    return response.fold(
      (error) {
        debugPrint('S3: ❌ Presigned URL error: $error');
        return null;
      },
      (data) {
        final presigned = data['presigned_url'] as String?;
        final public = data['public_url'] as String?;
        if (presigned == null || public == null) {
          debugPrint('S3: ❌ Invalid response structure: $data');
          return null;
        }
        debugPrint('S3: ✅ Presigned URL received. Public: $public');
        return {'presigned_url': presigned, 'public_url': public};
      },
    );
  }

  // ─── Step 2: Upload File to S3 (raw binary PUT) ──────────────────────────
  static Future<bool> uploadToS3({
    required String presignedUrl,
    required File file,
    required String contentType,
  }) async {
    try {
      final dio = Dio();
      final fileBytes = await file.readAsBytes();
      debugPrint('S3: ▶️ Uploading ${fileBytes.length} bytes (type: $contentType)');
      final response = await dio.put(
        presignedUrl,
        data: Stream.fromIterable([fileBytes]),
        options: Options(
          headers: {
            'Content-Type': contentType,
            'Content-Length': fileBytes.length,
          },
          sendTimeout: const Duration(seconds: 60),
          receiveTimeout: const Duration(seconds: 60),
        ),
      );
      debugPrint('S3: ✅ Upload status: ${response.statusCode}');
      return (response.statusCode ?? 0) == 200;
    } catch (e) {
      debugPrint('S3: ❌ Upload error: $e');
      return false;
    }
  }

  // ─── Helper: Presign + Upload in one call ──────────────────────────────────
  /// Returns the `public_url` for use in payloads, or null on failure.
  static Future<String?> presignAndUpload(
    File file, {
    String? presignedEndpoint,
    bool skipAuth = false,
  }) async {
    final fileName = file.path.split(RegExp(r'[/\\]')).last;
    final contentType = mimeTypeFor(file.path);

    final urls = await getPresignedUrl(
      contentType: contentType,
      fileName: fileName,
      presignedEndpoint: presignedEndpoint,
      skipAuth: skipAuth,
    );
    if (urls == null) return null;

    final uploaded = await uploadToS3(
      presignedUrl: urls['presigned_url']!,
      file: file,
      contentType: contentType,
    );
    if (!uploaded) return null;

    return urls['public_url'];
  }
}
