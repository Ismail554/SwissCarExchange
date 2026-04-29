import 'package:flutter/material.dart';
import 'package:rionydo/app_utils/network/dio_manager.dart';

import 'package:rionydo/views/auth/login/login_views.dart';


class AuthProvider extends ChangeNotifier {
  Future<void> logout(BuildContext context) async {
    // 1. Clear session and tokens
    await DioManager.logout();

    // 2. Navigate back to login
    if (context.mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginViews()),
        (route) => false,
      );
    }

    notifyListeners();
  }

}