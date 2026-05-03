import 'package:flutter/material.dart';
import 'package:rionydo/models/profile/user_profile_response.dart';

class GlobalState extends ChangeNotifier {
  /// Simple global flag to track premium status throughout the app.
  bool _isPremium = false;

  bool get isPremium => _isPremium;

  set isPremium(bool value) {
    if (_isPremium != value) {
      _isPremium = value;
      notifyListeners();
    }
  }

  /// User type from the login/profile API ('company' or 'private')
  UserType _userType = UserType.private;

  UserType get userType => _userType;

  set userType(UserType value) {
    if (_userType != value) {
      _userType = value;
      notifyListeners();
    }
  }

  /// Convenience setter that parses the raw string from the login API.
  void setUserTypeFromString(String raw) {
    userType = raw == 'company' ? UserType.company : UserType.private;
  }

  /// User info
  String userName = "Premium Auto Group AG";
}
