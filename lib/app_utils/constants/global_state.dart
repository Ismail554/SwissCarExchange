import 'package:flutter/material.dart';
import 'package:rionydo/models/profile/user_profile_response.dart';
import 'package:rionydo/app_helper/secure_storage_helper.dart';
import 'package:rionydo/models/subscription/subscription_plan.dart';

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

  /// Rehydrate state from secure storage
  Future<void> rehydrate() async {
    final plan = await SecureStorageHelper.getSubscriptionPlan();
    _isPremium = (plan == SubscriptionPlanId.premium);

    final type = await SecureStorageHelper.getUserType();
    if (type != null) {
      setUserTypeFromString(type);
    }

    debugPrint('GLOBAL_STATE: ♻️ Rehydrated. isPremium: $_isPremium, userType: $_userType');
    notifyListeners();
  }
}
