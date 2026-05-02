import 'dart:io';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:rionydo/app_utils/constants/api_service.dart';
import 'package:rionydo/app_utils/network/dio_manager.dart';
import 'package:rionydo/app_utils/network/enums.dart';
import 'package:rionydo/core/widgets/widget_snackbar.dart';
import 'package:rionydo/views/auth/sign_up/verify_sign_up/presentations/pending_view.dart';

/// Resolves the MIME content-type from a file extension.
String _mimeTypeFor(String filePath) {
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

class RegisterProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // ─── Step 1: Get Pre-Signed URL ────────────────────────────────────────────
  /// Returns `{presigned_url, public_url}` or null on failure.
  Future<Map<String, String>?> _getPresignedUrl({
    required String contentType,
    required String fileName,
  }) async {
    log('▶️ Requesting presigned URL for "$fileName" (content-type: $contentType)', name: 'REGISTER');
    final response = await DioManager.apiRequest(
      url: ApiService.presignedUrl,
      method: Methods.get,
      queryParameters: {
        'content_type': contentType,
        'file_name': fileName,
      },
      skipAuth: true,
    );

    return response.fold(
      (error) {
        log('❌ Presigned URL error: $error', name: 'REGISTER');
        return null;
      },
      (data) {
        final presigned = data['presigned_url'] as String?;
        final public = data['public_url'] as String?;
        if (presigned == null || public == null) {
          log('❌ Invalid presigned URL response structure: $data', name: 'REGISTER');
          return null;
        }
        log('✅ Presigned URL received successfully. Public URL: $public', name: 'REGISTER');
        return {'presigned_url': presigned, 'public_url': public};
      },
    );
  }

  // ─── Step 2: Upload File to S3 (raw binary PUT) ────────────────────────────
  Future<bool> _uploadToS3({
    required String presignedUrl,
    required File file,
    required String contentType,
  }) async {
    try {
      // Must be raw binary PUT — no JSON, no multipart
      final dio = Dio();
      final fileBytes = await file.readAsBytes();
      log('▶️ Uploading binary to S3: ${fileBytes.length} bytes (type: $contentType)', name: 'REGISTER');
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
      log('✅ S3 upload status: ${response.statusCode}', name: 'REGISTER');
      return (response.statusCode ?? 0) == 200;
    } catch (e) {
      log('❌ S3 upload error: $e', name: 'REGISTER');
      return false;
    }
  }

  // ─── Helper: Upload a single file through presign → S3 ────────────────────
  /// Returns the `public_url` for use in registration, or null on failure.
  Future<String?> _presignAndUpload(File file) async {
    final fileName = file.path.split(RegExp(r'[/\\]')).last;
    final contentType = _mimeTypeFor(file.path);

    final urls = await _getPresignedUrl(
      contentType: contentType,
      fileName: fileName,
    );
    if (urls == null) return null;

    final uploaded = await _uploadToS3(
      presignedUrl: urls['presigned_url']!,
      file: file,
      contentType: contentType,
    );
    if (!uploaded) return null;

    return urls['public_url'];
  }

  // ─── Register: Private (Individual) user ───────────────────────────────────
  Future<void> registerPrivate({
    required BuildContext context,
    required String email,
    required String password,
    required String phone,
    required String address,
    required String fullName,
    required File photoFile,       // profile photo
    required File idDocumentFile,  // NID / Passport
  }) async {
    log('▶️ START registerPrivate: email=$email, phone=$phone, name=$fullName', name: 'REGISTER');
    _setLoading(true);

    try {
      // Upload both files in parallel
      final results = await Future.wait([
        _presignAndUpload(photoFile),
        _presignAndUpload(idDocumentFile),
      ]);

      final photoUrl = results[0];
      final idDocUrl = results[1];

      if (photoUrl == null || idDocUrl == null) {
        log('❌ registerPrivate: One or more file uploads failed.', name: 'REGISTER');
        if (context.mounted) {
          AppSnackBar.error(context, 'File upload failed. Please try again.');
        }
        return;
      }

      log('▶️ Calling /api/auth/register/ for private user...', name: 'REGISTER');
      final response = await DioManager.apiRequest(
        url: ApiService.register,
        method: Methods.post,
        skipAuth: true,
        body: {
          'email': email.trim(),
          'password': password,
          'phone': phone.trim(),
          'address': address.trim(),
          'user_type': 'private',
          'full_name': fullName.trim(),
          'photo_url': photoUrl,
          'id_document_url': idDocUrl,
        },
        successCode: 201,
        altCodes: [200],
      );

      response.fold(
        (error) {
          log('❌ registerPrivate API error: $error', name: 'REGISTER');
          if (context.mounted) AppSnackBar.error(context, error);
        },
        (_) {
          log('✅ registerPrivate API success! Navigating to PendingView.', name: 'REGISTER');
          if (context.mounted) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const PendingView()),
              (route) => false,
            );
          }
        },
      );
    } catch (e) {
      log('❌ registerPrivate error: $e', name: 'REGISTER');
      if (context.mounted) {
        AppSnackBar.error(context, 'An unexpected error occurred.');
      }
    } finally {
      _setLoading(false);
    }
  }

  // ─── Register: Company user ────────────────────────────────────────────────
  Future<void> registerCompany({
    required BuildContext context,
    required String email,
    required String password,
    required String phone,
    required String address,
    required String company,
    required String uid,
    required File licenseFile, // trade-register / commercial license
  }) async {
    log('▶️ START registerCompany: email=$email, phone=$phone, company=$company', name: 'REGISTER');
    _setLoading(true);

    try {
      final licenseUrl = await _presignAndUpload(licenseFile);

      if (licenseUrl == null) {
        log('❌ registerCompany: License upload failed.', name: 'REGISTER');
        if (context.mounted) {
          AppSnackBar.error(context, 'File upload failed. Please try again.');
        }
        return;
      }

      log('▶️ Calling /api/auth/register/ for company user...', name: 'REGISTER');
      final response = await DioManager.apiRequest(
        url: ApiService.register,
        method: Methods.post,
        skipAuth: true,
        body: {
          'email': email.trim(),
          'password': password,
          'phone': phone.trim(),
          'address': address.trim(),
          'user_type': 'company',
          'company': company.trim(),
          'uid': uid.trim(),
          'license_url': licenseUrl,
        },
        successCode: 201,
        altCodes: [200],
      );

      response.fold(
        (error) {
          log('❌ registerCompany API error: $error', name: 'REGISTER');
          if (context.mounted) AppSnackBar.error(context, error);
        },
        (_) {
          log('✅ registerCompany API success! Navigating to PendingView.', name: 'REGISTER');
          if (context.mounted) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const PendingView()),
              (route) => false,
            );
          }
        },
      );
    } catch (e) {
      log('❌ registerCompany error: $e', name: 'REGISTER');
      if (context.mounted) {
        AppSnackBar.error(context, 'An unexpected error occurred.');
      }
    } finally {
      _setLoading(false);
    }
  }

  // ─── Internal ──────────────────────────────────────────────────────────────
  void _setLoading(bool v) {
    _isLoading = v;
    notifyListeners();
  }
}