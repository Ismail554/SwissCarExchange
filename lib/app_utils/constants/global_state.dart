import 'package:flutter/material.dart';

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

  /// User info (mockup data)
  String userName = "Premium Auto Group AG";
  String userRole = "Dealer";
}
