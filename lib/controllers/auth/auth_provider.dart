import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rionydo/app_utils/network/dio_manager.dart';
import 'package:rionydo/app_utils/network/enums.dart';
import 'package:rionydo/app_utils/constants/api_service.dart';
import 'package:rionydo/models/auth/login_response.dart';
import 'package:rionydo/app_helper/secure_storage_helper.dart';
import 'package:rionydo/core/widgets/widget_snackbar.dart';
import 'package:rionydo/views/auth/forgot_password/otp_verify_view.dart';
import 'package:rionydo/views/auth/forgot_password/successful_view.dart';
import 'package:rionydo/views/home/presentation/home_view.dart';
import 'package:rionydo/views/auctions/presentations/auctions_view.dart';
import 'package:rionydo/views/bidding/presentations/bids_view.dart';
import 'package:rionydo/views/profile/presentations/profile_view.dart';
import 'package:rionydo/views/main_navigation/bottom_nav.dart';
import 'package:rionydo/app_utils/constants/global_state.dart';
import 'package:rionydo/views/auth/login/login_views.dart';
import 'package:rionydo/views/auth/sign_up/verify_sign_up/presentations/pending_view.dart';
class AuthProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> login(BuildContext context, {required String email, required String password}) async {
    _isLoading = true;
    notifyListeners();

    final payload = {
      'email': email.trim(),
      'password': password,
    };
    debugPrint('LOGIN: ▶️ Calling login API with payload: $payload');

    final response = await DioManager.apiRequest(
      url: ApiService.login,
      method: Methods.post,
      body: payload,
      skipAuth: true,
    );

    response.fold(
      (error) async {
        _isLoading = false;
        notifyListeners();
        debugPrint('LOGIN: ❌ Unverified Email: $error');
        if (error.startsWith('UNVERIFIED_EMAIL:')) {
          final msg = error.substring('UNVERIFIED_EMAIL:'.length);
          AppSnackBar.error(context, msg);
          if (context.mounted) {
            // Automatically resend OTP so the user has a fresh code
            await resendOtp(context, email: email.trim());
            if (context.mounted) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OtpVerifyView(email: email.trim()),
                ),
              );
            }
          }
        } else {
          AppSnackBar.error(context, error);
        }
      },
      (data) async {
        _isLoading = false;
        notifyListeners();
        debugPrint('LOGIN: ✅ API response: $data');
        
        final loginData = LoginResponse.fromJson(data);

        if (loginData.approvalStatus == 'suspended') {
          if (context.mounted) {
            AppSnackBar.error(context, "Try login with different account");
          }
          return;
        }

        if (loginData.approvalStatus == 'pending') {
          await SecureStorageHelper.saveAccessToken(loginData.access);
          await SecureStorageHelper.saveRefreshToken(loginData.refresh);
          await SecureStorageHelper.saveUserType(loginData.userType);
          
          if (context.mounted) {
            context.read<GlobalState>().userRole = loginData.userType;
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const PendingView()),
              (route) => false,
            );
          }
          return;
        }

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

  Future<bool> resendOtp(BuildContext context, {required String email}) async {
    _isLoading = true;
    notifyListeners();

    final payload = {'email': email.trim()};
    debugPrint('AUTH: ▶️ Calling resendOtp API with payload: $payload');

    final response = await DioManager.apiRequest(
      url: ApiService.resendOtp,
      method: Methods.post,
      body: payload,
      skipAuth: true,
    );

    bool success = false;
    response.fold(
      (error) {
        debugPrint('AUTH: ❌ resendOtp API error: $error');
        AppSnackBar.error(context, error);
      },
      (data) {
        debugPrint('AUTH: ✅ resendOtp API success! Response: $data');
        AppSnackBar.success(context, 'OTP has been resent to your email');
        success = true;
      },
    );

    _isLoading = false;
    notifyListeners();
    return success;
  }

  Future<void> verifyOtp(BuildContext context, {required String email, required String otp}) async {
    _isLoading = true;
    notifyListeners();

    final payload = {
      'email': email.trim(),
      'code': otp,
    };
    debugPrint('AUTH: ▶️ Calling verifyOtp API with payload: $payload');

    final response = await DioManager.apiRequest(
      url: ApiService.verifyOtp,
      method: Methods.post,
      body: payload,
      skipAuth: true,
    );

    response.fold(
      (error) {
        debugPrint('AUTH: ❌ verifyOtp API error: $error');
        AppSnackBar.error(context, error);
      },
      (data) {
        debugPrint('AUTH: ✅ verifyOtp API success! Response: $data');
        if (context.mounted) {
          final message = data['message']?.toString();
          if (message != null && message.isNotEmpty) {
            AppSnackBar.success(context, message);
          } else {
            AppSnackBar.success(context, "Email verified successfully.");
          }
          
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginViews(),
            ),
            (route) => false,
          );
        }
      },
    );

    _isLoading = false;
    notifyListeners();
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

  Future<bool> checkApprovalStatus(BuildContext context) async {
    final response = await DioManager.apiRequest(
      url: ApiService.authStatus,
      method: Methods.get,
    );

    bool shouldCancelTimer = false;

    response.fold(
      (error) {
        debugPrint("AUTH: ❌ Status Check Error: $error");
      },
      (data) {
        if (data is Map<String, dynamic>) {
          if (data['approval_status'] == 'approved') {
            shouldCancelTimer = true;
            if (context.mounted) {
              AppSnackBar.success(context, "Your account has been approved! Please login.");
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginViews()),
                (route) => false,
              );
            }
          } else if (data['approval_status'] == 'suspended') {
            shouldCancelTimer = true;
            if (context.mounted) {
              AppSnackBar.error(context, "Your account has been suspended.");
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginViews()),
                (route) => false,
              );
            }
          }
        }
      },
    );

    return shouldCancelTimer;
  }
}