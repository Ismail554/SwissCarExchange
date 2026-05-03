import 'package:flutter/material.dart';
import 'package:rionydo/app_utils/constants/api_service.dart';
import 'package:rionydo/app_utils/network/dio_manager.dart';
import 'package:rionydo/app_utils/network/enums.dart';
import 'package:rionydo/models/profile/user_profile_response.dart';

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

  Future<void> fetchProfile() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await DioManager.apiRequest(
        url: ApiService.userProfile,
        method: Methods.get,
      );

      response.fold(
        (error) {
          debugPrint('PROFILE: ❌ fetchProfile error: $error');
          _errorMessage = error;
        },
        (data) {
          debugPrint('PROFILE: ✅ fetchProfile success');
          _userProfile = UserProfileResponse.fromJson(data);
        },
      );
    } catch (e) {
      debugPrint('PROFILE: ❌ Unexpected error: $e');
      _errorMessage = 'Failed to load profile. Please try again.';
    }

    _isLoading = false;
    notifyListeners();
  }
}
