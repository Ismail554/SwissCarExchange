import 'dart:io';
import 'package:flutter/material.dart';
import 'package:rionydo/app_helper/s3_upload_helper.dart';
import 'package:rionydo/app_utils/constants/api_service.dart';
import 'package:rionydo/app_utils/network/dio_manager.dart';
import 'package:rionydo/app_utils/network/enums.dart';
import 'package:rionydo/models/profile/user_profile_response.dart';
import 'package:rionydo/app_utils/constants/global_state.dart';
import 'package:rionydo/models/subscription/subscription_plan.dart';
import 'package:rionydo/app_helper/secure_storage_helper.dart';

class UserProfileProvider extends ChangeNotifier {
  UserProfileResponse? _userProfile;
  UserProfileResponse? get userProfile => _userProfile;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  /// Convenience getters for the display name (works for both user types).
  String get displayName {
    final p = _userProfile;
    if (p == null) return '';
    return switch (p) {
      PrivateUserProfile() => p.fullName,
      CompanyUserProfile() => p.company,
    };
  }

  String get photoUrl {
    final p = _userProfile;
    if (p == null) return '';
    return switch (p) {
      PrivateUserProfile() => p.photoUrl,
      CompanyUserProfile() => '',
    };
  }

  bool _isSaving = false;
  bool get isSaving => _isSaving;

  String? _saveError;
  String? get saveError => _saveError;

  // ─── Pending photo (private user edit) ────────────────────────────────────
  File? _pendingPhotoFile;
  String? _pendingPhotoFileName;
  File? get pendingPhotoFile => _pendingPhotoFile;
  String? get pendingPhotoFileName => _pendingPhotoFileName;

  void setPhotoFile(File? file, String? name) {
    _pendingPhotoFile = file;
    _pendingPhotoFileName = name;
    notifyListeners();
  }

  Future<void> fetchProfile({GlobalState? globalState}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await DioManager.apiRequest(
        url: ApiService.userProfile,
        method: Methods.get,
        skipAuth: false,
      );

      response.fold(
        (error) {
          debugPrint('PROFILE: ❌ fetchProfile error: $error');
          _errorMessage = error;
        },
        (data) {
          debugPrint('PROFILE: ✅ fetchProfile success');
          final profile = UserProfileResponse.fromJson(data);
          _userProfile = profile;

          if (globalState != null) {
            final plan = profile.subscription.plan ?? SubscriptionPlanId.basic;
            globalState.isPremium = (plan == SubscriptionPlanId.premium);
            globalState.setUserTypeFromString(profile.userType.name);
            SecureStorageHelper.saveSubscriptionPlan(plan);
            SecureStorageHelper.saveUserType(profile.userType.name);
          }
        },
      );
    } catch (e) {
      debugPrint('PROFILE: ❌ Unexpected error: $e');
      _errorMessage = 'Failed to load profile. Please try again.';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> updateProfile(Map<String, dynamic> body) async {
    _isSaving = true;
    _saveError = null;
    notifyListeners();

    try {
      final response = await DioManager.apiRequest(
        url: ApiService.updateProfile,
        method: Methods.patch,
        body: body,
      );

      return response.fold(
        (error) {
          debugPrint('PROFILE: ❌ updateProfile error: $error');
          _saveError = error;
          _isSaving = false;
          notifyListeners();
          return false;
        },
        (data) {
          debugPrint('PROFILE: ✅ updateProfile success');
          final profile = UserProfileResponse.fromJson(data);
          _userProfile = profile;
          _isSaving = false;
          notifyListeners();
          return true;
        },
      );
    } catch (e) {
      debugPrint('PROFILE: ❌ Unexpected update error: $e');
      _saveError = 'Failed to update profile. Please try again.';
      _isSaving = false;
      notifyListeners();
      return false;
    }
  }

  /// Uploads [photoFile] to S3, merges the returned public URL into [body]
  /// as `photo_url`, then calls [updateProfile]. Returns true on full success.
  Future<bool> uploadPhotoAndUpdate(
    File photoFile,
    Map<String, dynamic> body,
  ) async {
    _isSaving = true;
    _saveError = null;
    notifyListeners();

    debugPrint('PROFILE: ▶️ Uploading photo before profile update...');
    final photoUrl = await S3UploadHelper.presignAndUpload(photoFile);

    if (photoUrl == null) {
      debugPrint('PROFILE: ❌ Photo upload failed, aborting profile update');
      _saveError = 'Photo upload failed. Please try again.';
      _isSaving = false;
      notifyListeners();
      return false;
    }

    debugPrint('PROFILE: ✅ Photo uploaded: $photoUrl');
    // Reset saving flag — updateProfile will set it again
    _isSaving = false;

    return updateProfile({...body, 'photo_url': photoUrl});
  }
}
