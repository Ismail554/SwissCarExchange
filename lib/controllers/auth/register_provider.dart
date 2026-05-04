import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:rionydo/app_helper/s3_upload_helper.dart';
import 'package:rionydo/app_utils/network/dio_manager.dart';
import 'package:rionydo/app_utils/network/enums.dart';
import 'package:rionydo/app_utils/constants/api_service.dart';
import 'package:rionydo/core/widgets/widget_snackbar.dart';
import 'package:rionydo/views/auth/sign_up/presentations/sign_up_step2.dart' show UserRole;
import 'package:rionydo/views/auth/sign_up/verify_sign_up/presentations/pending_view.dart';
import 'package:rionydo/views/auth/forgot_password/otp_verify_view.dart';



class RegisterProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // ─── Caching Form State ────────────────────────────────────────────────────
  // Step 1
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();

  // Step 2
  UserRole selectedRole = UserRole.individual;
  final nameController = TextEditingController();
  final individualAddressController = TextEditingController();
  File? idFile;
  String? idFileName;
  bool isIdImage = false;

  final companyController = TextEditingController();
  final uidController = TextEditingController();
  final companyAddressController = TextEditingController();

  // Step 3
  File? photoFile;
  String? photoFileName;
  PlatformFile? licensePickedFile;

  void setRole(UserRole role) {
    selectedRole = role;
    notifyListeners();
  }

  void setIdFile(File? file, String? name, bool isImage) {
    idFile = file;
    idFileName = name;
    isIdImage = isImage;
    notifyListeners();
  }

  void setPhotoFile(File? file, String? name) {
    photoFile = file;
    photoFileName = name;
    notifyListeners();
  }

  void setLicenseFile(PlatformFile? file) {
    licensePickedFile = file;
    notifyListeners();
  }

  void clearRegistrationCache() {
    emailController.clear();
    passwordController.clear();
    phoneController.clear();
    
    selectedRole = UserRole.individual;
    nameController.clear();
    individualAddressController.clear();
    idFile = null;
    idFileName = null;
    isIdImage = false;

    companyController.clear();
    uidController.clear();
    companyAddressController.clear();

    photoFile = null;
    photoFileName = null;
    licensePickedFile = null;
    notifyListeners();
  }


  // ─── Upload via shared S3UploadHelper ─────────────────────────────────────
  Future<String?> _presignAndUpload(File file) =>
      S3UploadHelper.presignAndUpload(file, skipAuth: true);

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
    debugPrint('REGISTER: ▶️ START registerPrivate: email=$email, phone=$phone, name=$fullName');
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
        debugPrint('REGISTER: ❌ registerPrivate: One or more file uploads failed.');
        if (context.mounted) {
          AppSnackBar.error(context, 'File upload failed. Please try again.');
        }
        return;
      }

      final payload = {
        'email': email.trim(),
        'password': password,
        'phone': phone.trim(),
        'address': address.trim(),
        'user_type': 'private',
        'full_name': fullName.trim(),
        'photo_url': photoUrl,
        'id_document_url': idDocUrl,
      };
      debugPrint('REGISTER: ▶️ Calling /api/auth/register/ for private user with payload: $payload');
      
      final response = await DioManager.apiRequest(
        url: ApiService.register,
        method: Methods.post,
        skipAuth: true,
        body: payload,
        successCode: 201,
        altCodes: [200],
      );

      response.fold(
        (error) {
          debugPrint('REGISTER: ❌ registerPrivate API error: $error');
          if (context.mounted) AppSnackBar.error(context, error);
        },
        (data) {
          debugPrint('REGISTER: ✅ registerPrivate API success! Response: $data');
          if (context.mounted) {
            clearRegistrationCache();
            if (data['is_email_verified'] == false) {
              final msg = data['message'] ?? 'Verification code sent to your email.';
              AppSnackBar.success(context, msg);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => OtpVerifyView(email: email.trim())),
                (route) => false,
              );
            } else {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const PendingView()),
                (route) => false,
              );
            }
          }
        },
      );
    } catch (e) {
      debugPrint('REGISTER: ❌ registerPrivate error: $e');
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
    debugPrint('REGISTER: ▶️ START registerCompany: email=$email, phone=$phone, company=$company');
    _setLoading(true);

    try {
      final licenseUrl = await _presignAndUpload(licenseFile);

      if (licenseUrl == null) {
        debugPrint('REGISTER: ❌ registerCompany: License upload failed.');
        if (context.mounted) {
          AppSnackBar.error(context, 'File upload failed. Please try again.');
        }
        return;
      }

      final payload = {
        'email': email.trim(),
        'password': password,
        'phone': phone.trim(),
        'address': address.trim(),
        'user_type': 'company',
        'company': company.trim(),
        'uid': uid.trim(),
        'license_url': licenseUrl,
      };
      debugPrint('REGISTER: ▶️ Calling /api/auth/register/ for company user with payload: $payload');
      
      final response = await DioManager.apiRequest(
        url: ApiService.register,
        method: Methods.post,
        skipAuth: true,
        body: payload,
        successCode: 201,
        altCodes: [200],
      );

      response.fold(
        (error) {
          debugPrint('REGISTER: ❌ registerCompany API error: $error');
          if (context.mounted) AppSnackBar.error(context, error);
        },
        (data) {
          debugPrint('REGISTER: ✅ registerCompany API success! Response: $data');
          if (context.mounted) {
            clearRegistrationCache();
            if (data['is_email_verified'] == false) {
              final msg = data['message'] ?? 'Verification code sent to your email.';
              AppSnackBar.success(context, msg);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => OtpVerifyView(email: email.trim())),
                (route) => false,
              );
            } else {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const PendingView()),
                (route) => false,
              );
            }
          }
        },
      );
    } catch (e) {
      debugPrint('REGISTER: ❌ registerCompany error: $e');
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