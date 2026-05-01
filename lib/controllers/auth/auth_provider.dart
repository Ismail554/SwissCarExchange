import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rionydo/app_utils/network/dio_manager.dart';
import 'package:rionydo/app_utils/network/enums.dart';
import 'package:rionydo/app_utils/constants/api_service.dart';
import 'package:rionydo/models/auth/login_response.dart';
import 'package:rionydo/app_helper/secure_storage_helper.dart';
import 'package:rionydo/core/widgets/widget_snackbar.dart';
import 'package:rionydo/views/auth/forgot_password/otp_verify_view.dart';
import 'package:rionydo/views/home/presentation/home_view.dart';
import 'package:rionydo/views/auctions/presentations/auctions_view.dart';
import 'package:rionydo/views/bidding/presentations/bids_view.dart';
import 'package:rionydo/views/profile/presentations/profile_view.dart';
import 'package:rionydo/views/main_navigation/bottom_nav.dart';
import 'package:rionydo/app_utils/constants/global_state.dart';
import 'package:rionydo/views/auth/login/login_views.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> login(BuildContext context, {required String email, required String password}) async {
    _isLoading = true;
    notifyListeners();

    final response = await DioManager.apiRequest(
      url: ApiService.login,
      method: Methods.post,
      body: {
        'email': email.trim(),
        'password': password,
      },
      skipAuth: true,
    );

    response.fold(
      (error) {
        _isLoading = false;
        notifyListeners();
        AppSnackBar.error(context, error);
      },
      (data) async {
        _isLoading = false;
        notifyListeners();
        
        final loginData = LoginResponse.fromJson(data);

        if (loginData.isTwoFactorRequired) {
          if (context.mounted) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OtpVerifyView(email: loginData.email),
              ),
            );
          }
        } else {
          await SecureStorageHelper.saveAccessToken(loginData.access);
          await SecureStorageHelper.saveRefreshToken(loginData.refresh);
          await SecureStorageHelper.saveUserType(loginData.userType);
          
          if (context.mounted) {
            context.read<GlobalState>().userRole = loginData.userType;
            context.read<GlobalState>().isPremium = true;
            
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const MainNavigationShell(
                  pages: [
                    HomeView(),
                    AuctionsView(),
                    BidsView(),
                    ProfileView(),
                  ],
                ),
              ),
              (route) => false,
            );
          }
        }
      },
    );
  }

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