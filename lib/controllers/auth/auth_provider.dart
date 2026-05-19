import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:rionydo/app_utils/network/dio_manager.dart';
import 'package:rionydo/app_utils/network/enums.dart';
import 'package:rionydo/app_utils/network/token_manager.dart';
import 'package:rionydo/app_utils/constants/api_service.dart';
import 'package:rionydo/firebase_options.dart';
import 'package:rionydo/models/auth/login_response.dart';
import 'package:rionydo/app_helper/secure_storage_helper.dart';
import 'package:rionydo/core/widgets/widget_snackbar.dart';

import 'package:rionydo/app_utils/constants/global_state.dart';
import 'package:rionydo/models/subscription/subscription_plan.dart';
import 'package:rionydo/services/firebase_service.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> login(
    BuildContext context, {
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    notifyListeners();

    final payload = {'email': email.trim(), 'password': password};
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
        debugPrint('LOGIN: ❌ Error: $error');
        final errorStr = error.isNotEmpty
            ? error
            : 'Login failed. Please try again.';
        if (errorStr.startsWith('UNVERIFIED_EMAIL:')) {
          final msg = errorStr.substring('UNVERIFIED_EMAIL:'.length);
          AppSnackBar.error(context, msg);
          if (context.mounted) {
            // Automatically resend OTP so the user has a fresh code
            await resendOtp(context, email: email.trim());
            if (context.mounted) {
              context.push('/verify-otp', extra: {'email': email.trim()});
            }
          }
        } else {
          AppSnackBar.error(context, errorStr);
        }
      },
      (data) async {
        _isLoading = false;
        notifyListeners();
        debugPrint('LOGIN: ✅ API response: $data');

        final loginData = LoginResponse.fromJson(data);

        // --- 1. Suspended account ---
        if (loginData.approvalStatus == 'suspended') {
          if (context.mounted) {
            final msg =
                (loginData.message != null && loginData.message!.isNotEmpty)
                ? loginData.message!
                : "Your account is suspended. Contact your owner.\nOr try with another account.";
            AppSnackBar.error(context, msg);
          }
          return;
        }

        // --- 2. Pending approval ---
        if (loginData.approvalStatus == 'pending') {
          await SecureStorageHelper.saveAccessToken(loginData.access);
          await SecureStorageHelper.saveRefreshToken(loginData.refresh);
          await SecureStorageHelper.saveUserType(loginData.userType);
          TokenManager.setCache(loginData.access);

          if (context.mounted) {
            if (loginData.message != null && loginData.message!.isNotEmpty) {
              AppSnackBar.warning(context, loginData.message!);
            }
            context.read<GlobalState>().setUserTypeFromString(
              loginData.userType,
            );
            context.go('/pending');
          }
          return;
        }

        // --- 3. Two-Factor Authentication required ---
        if (loginData.isTwoFactorRequired) {
          if (context.mounted) {
            if (loginData.message != null && loginData.message!.isNotEmpty) {
              AppSnackBar.success(context, loginData.message!);
            }
            context.push('/verify-otp', extra: {'email': loginData.email});
          }
          return;
        }

        // --- 4. Approved — save tokens & check subscription ---
        await SecureStorageHelper.saveAccessToken(loginData.access);
        await SecureStorageHelper.saveRefreshToken(loginData.refresh);
        await SecureStorageHelper.saveUserType(loginData.userType);
        TokenManager.setCache(loginData.access);

        if (!context.mounted) return;

        context.read<GlobalState>().setUserTypeFromString(loginData.userType);

        // Check subscription status
        final hasSub = loginData.subscription?.hasSubscription ?? false;
        if (!hasSub) {
          // No subscription → navigate to subscription gate
          context.go('/before-subscription');
          return;
        }

        // Has subscription → set premium based on plan & go to main app
        final plan = loginData.subscription?.plan ?? SubscriptionPlanId.basic;
        context.read<GlobalState>().isPremium =
            (plan == SubscriptionPlanId.premium);
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
        // Init FCM after login with valid token — fire and forget.
        FirebaseService.initFirebaseMessaging();
        await SecureStorageHelper.saveSubscriptionPlan(plan);

        if (!context.mounted) return;

        context.go('/home');
      },
    );
  }

  // ----------------------------------------------------------------
  // 2FA VERIFY — POST /api/auth/login/two-factor/verify/
  // ----------------------------------------------------------------
  Future<void> verify2fa(
    BuildContext context, {
    required String email,
    required String twoFactorToken,
    required String code,
  }) async {
    _isLoading = true;
    notifyListeners();

    final payload = {
      'email': email.trim(),
      'two_factor_token': twoFactorToken,
      'code': code,
    };
    debugPrint('AUTH: ▶️ Calling verify2fa API with payload: $payload');

    final response = await DioManager.apiRequest(
      url: ApiService.verify2fa,
      method: Methods.post,
      body: payload,
      skipAuth: true,
    );

    response.fold(
      (error) {
        debugPrint('AUTH: ❌ verify2fa error: $error');
        final msg = error.isNotEmpty
            ? error
            : 'Two-Factor Verification failed. Please try again.';
        AppSnackBar.error(context, msg);
      },
      (data) async {
        debugPrint('AUTH: ✅ verify2fa success: $data');
        final loginData = LoginResponse.fromJson(data);

        await SecureStorageHelper.saveAccessToken(loginData.access);
        await SecureStorageHelper.saveRefreshToken(loginData.refresh);
        await SecureStorageHelper.saveUserType(loginData.userType);
        TokenManager.setCache(loginData.access);

        if (!context.mounted) return;

        context.read<GlobalState>().setUserTypeFromString(loginData.userType);

        // Check subscription after 2FA
        final hasSub = loginData.subscription?.hasSubscription ?? false;
        if (!hasSub) {
          context.go('/before-subscription');
          return;
        }

        final plan = loginData.subscription?.plan ?? SubscriptionPlanId.basic;
        context.read<GlobalState>().isPremium =
            (plan == SubscriptionPlanId.premium);
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
        // Init FCM after 2FA login with valid token — fire and forget.
        FirebaseService.initFirebaseMessaging();
        await SecureStorageHelper.saveSubscriptionPlan(plan);

        if (!context.mounted) return;

        context.go('/home');
      },
    );

    _isLoading = false;
    notifyListeners();
  }

  // ----------------------------------------------------------------
  // RESEND OTP
  // ----------------------------------------------------------------
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
        final msg = error.isNotEmpty
            ? error
            : 'Failed to resend OTP. Please try again.';
        AppSnackBar.error(context, msg);
      },
      (data) {
        debugPrint('AUTH: ✅ resendOtp API success! Response: $data');
        final msg =
            (data is Map<String, dynamic> &&
                data['message'] != null &&
                data['message'].toString().isNotEmpty)
            ? data['message'].toString()
            : 'OTP has been resent to your email';
        AppSnackBar.success(context, msg);
        success = true;
      },
    );

    _isLoading = false;
    notifyListeners();
    return success;
  }

  // ----------------------------------------------------------------
  // VERIFY OTP (email verification)
  // ----------------------------------------------------------------
  Future<void> verifyOtp(
    BuildContext context, {
    required String email,
    required String otp,
  }) async {
    _isLoading = true;
    notifyListeners();

    final payload = {'email': email.trim(), 'code': otp};
    debugPrint('AUTH: ▶️ Calling verifyOtp API with payload: $payload');

    final response = await DioManager.apiRequest(
      url: ApiService.verifyOtp,
      method: Methods.post,
      body: payload,
      skipAuth: true,
    );

    _isLoading = false;
    notifyListeners();

    await response.fold(
      (error) async {
        debugPrint('AUTH: ❌ verifyOtp API error: $error');
        if (context.mounted) {
          final msg = error.isNotEmpty
              ? error
              : 'Verification failed. Please try again.';
          AppSnackBar.error(context, msg);
        }
      },
      (data) async {
        debugPrint('AUTH: ✅ verifyOtp API success! Response: $data');
        if (context.mounted) {
          final message = data['message']?.toString();
          if (message != null && message.isNotEmpty) {
            AppSnackBar.success(context, message);
          } else {
            AppSnackBar.success(context, "Email verified successfully.");
          }

          final approvalStatus = data['approval_status']?.toString();

          FocusManager.instance.primaryFocus?.unfocus();
          await Future.delayed(const Duration(milliseconds: 50));

          if (approvalStatus == 'approved') {
            await Firebase.initializeApp(
              options: DefaultFirebaseOptions.currentPlatform,
            );
            // Init FCM after OTP-verified login — fire and forget.
            FirebaseService.initFirebaseMessaging();
            if (!context.mounted) return;
            context.go('/home');
          } else if (approvalStatus == 'pending') {
            if (!context.mounted) return;
            context.go('/pending');
          } else {
            if (!context.mounted) return;
            context.go('/login');
          }
        }
      },
    );
  }

  // ----------------------------------------------------------------
  // LOGOUT
  // ----------------------------------------------------------------
  Future<void> logout(BuildContext context) async {
    // 1. Clear session and tokens
    await DioManager.logout();

    // 2. Navigate back to login
    if (context.mounted) {
      context.go('/login');
    }

    notifyListeners();
  }

  // ----------------------------------------------------------------
  // APPROVAL STATUS CHECK (polling from PendingView)
  // ----------------------------------------------------------------
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
              final msg =
                  (data['message'] != null &&
                      data['message'].toString().isNotEmpty)
                  ? data['message'].toString()
                  : "Your account has been approved! Please login.";
              AppSnackBar.success(context, msg);
              context.go('/login');
            }
          } else if (data['approval_status'] == 'suspended') {
            shouldCancelTimer = true;
            if (context.mounted) {
              final msg =
                  (data['message'] != null &&
                      data['message'].toString().isNotEmpty)
                  ? data['message'].toString()
                  : "Your account has been suspended.";
              AppSnackBar.error(context, msg);
              context.go('/login');
            }
          }
        }
      },
    );

    return shouldCancelTimer;
  }

  // ----------------------------------------------------------------
  // SUBSCRIPTION STATUS CHECK (polling from BeforeSubsView)
  // ----------------------------------------------------------------
  Future<bool> checkSubscriptionStatus(BuildContext context) async {
    final response = await DioManager.apiRequest(
      url: ApiService.subscriptionStatus,
      method: Methods.get,
    );

    bool subscriptionActive = false;

    response.fold(
      (error) {
        debugPrint("AUTH: ❌ Subscription Check Error: $error");
      },
      (data) {
        if (data is Map<String, dynamic>) {
          final hasSub = data['has_subscription'] as bool? ?? false;
          final status = data['status'] as String? ?? '';
          if (hasSub && status == 'active') {
            subscriptionActive = true;
            if (context.mounted) {
              final msg =
                  (data['message'] != null &&
                      data['message'].toString().isNotEmpty)
                  ? data['message'].toString()
                  : "Subscription activated! Now login again.";
              AppSnackBar.success(context, msg);
              context.go('/login');
            }
          }
        }
      },
    );

    return subscriptionActive;
  }

  // ----------------------------------------------------------------
  // REQUEST PASSWORD RESET (Forgot Password Step 1)
  // ----------------------------------------------------------------
  Future<bool> requestPasswordReset(
    BuildContext context, {
    required String email,
  }) async {
    _isLoading = true;
    notifyListeners();

    final payload = {'email': email.trim()};
    debugPrint(
      'AUTH: ▶️ Calling requestPasswordReset API with payload: $payload',
    );

    final response = await DioManager.apiRequest(
      url: ApiService.forgotPassword,
      method: Methods.post,
      body: payload,
      skipAuth: true,
    );

    bool success = false;
    response.fold(
      (error) {
        debugPrint('AUTH: ❌ requestPasswordReset API error: $error');
        final msg = error.isNotEmpty
            ? error
            : 'Password reset request failed. Please try again.';
        AppSnackBar.error(context, msg);
      },
      (data) {
        debugPrint('AUTH: ✅ requestPasswordReset API success! Response: $data');
        if (context.mounted) {
          final message = data['message']?.toString();
          AppSnackBar.success(
            context,
            message ?? 'A verification code has been sent to your email.',
          );
        }
        success = true;
      },
    );

    _isLoading = false;
    notifyListeners();
    return success;
  }

  // ----------------------------------------------------------------
  // VERIFY PASSWORD RESET CODE (Forgot Password Step 2)
  // ----------------------------------------------------------------
  Future<String?> verifyResetCode(
    BuildContext context, {
    required String email,
    required String code,
  }) async {
    _isLoading = true;
    notifyListeners();

    final payload = {'email': email.trim(), 'code': code.trim()};
    debugPrint(
      'AUTH: ▶️ Calling verifyResetPasswordCode API with payload: $payload',
    );

    final response = await DioManager.apiRequest(
      url: ApiService.verifyResetPasswordCode,
      method: Methods.post,
      body: payload,
      skipAuth: true,
    );

    String? token;
    response.fold(
      (error) {
        debugPrint('AUTH: ❌ verifyResetPasswordCode API error: $error');
        final msg = error.isNotEmpty
            ? error
            : 'Code verification failed. Please try again.';
        AppSnackBar.error(context, msg);
      },
      (data) {
        debugPrint(
          'AUTH: ✅ verifyResetPasswordCode API success! Response: $data',
        );
        if (data is Map<String, dynamic>) {
          token = data['password_reset_token']?.toString();
        }
      },
    );

    _isLoading = false;
    notifyListeners();
    return token;
  }

  // ----------------------------------------------------------------
  // RESET PASSWORD (Forgot Password Step 3)
  // ----------------------------------------------------------------
  Future<bool> resetPassword(
    BuildContext context, {
    required String email,
    required String newPassword,
    required String token,
  }) async {
    _isLoading = true;
    notifyListeners();

    final payload = {
      'email': email.trim(),
      'new_password': newPassword,
      'password_reset_token': token,
    };
    debugPrint('AUTH: ▶️ Calling resetPassword API with payload: $payload');

    final response = await DioManager.apiRequest(
      url: ApiService.resetPassword,
      method: Methods.post,
      body: payload,
      skipAuth: true,
    );

    bool success = false;
    response.fold(
      (error) {
        debugPrint('AUTH: ❌ resetPassword API error: $error');
        final msg = error.isNotEmpty
            ? error
            : 'Password reset failed. Please try again.';
        AppSnackBar.error(context, msg);
      },
      (data) {
        debugPrint('AUTH: ✅ resetPassword API success! Response: $data');
        if (context.mounted) {
          final message = data['message']?.toString();
          AppSnackBar.success(
            context,
            message ?? 'Password has been reset successfully.',
          );
        }
        success = true;
      },
    );

    _isLoading = false;
    notifyListeners();
    return success;
  }

  // ----------------------------------------------------------------
  // CHANGE PASSWORD (Settings)
  // ----------------------------------------------------------------
  Future<bool> changePassword(
    BuildContext context, {
    required String currentPassword,
    required String newPassword,
  }) async {
    _isLoading = true;
    notifyListeners();

    final payload = {
      'current_password': currentPassword,
      'new_password': newPassword,
    };
    debugPrint('AUTH: ▶️ Calling changePassword API with payload: $payload');

    final response = await DioManager.apiRequest(
      url: ApiService.changePassword,
      method: Methods.post,
      body: payload,
    );

    bool success = false;
    response.fold(
      (error) {
        debugPrint('AUTH: ❌ changePassword API error: $error');
        final msg = error.isNotEmpty
            ? error
            : 'Change password failed. Please try again.';
        AppSnackBar.error(context, msg);
      },
      (data) {
        debugPrint('AUTH: ✅ changePassword API success! Response: $data');
        if (context.mounted) {
          final message = data['message']?.toString();
          AppSnackBar.success(
            context,
            message ?? 'Password has been changed successfully.',
          );
        }
        success = true;
      },
    );

    _isLoading = false;
    notifyListeners();
    return success;
  }

  // ----------------------------------------------------------------
  // TOGGLE TWO-FACTOR AUTHENTICATION (Settings)
  // ----------------------------------------------------------------
  Future<bool> toggle2FA(BuildContext context, {required bool enable}) async {
    _isLoading = true;
    notifyListeners();

    final url = enable ? ApiService.enable2FA : ApiService.disable2FA;
    debugPrint('AUTH: ▶️ Calling toggle2FA API ($url)');

    final response = await DioManager.apiRequest(
      url: url,
      method: Methods.post,
    );

    bool success = false;
    response.fold(
      (error) {
        debugPrint('AUTH: ❌ toggle2FA API error: $error');
        final msg = error.isNotEmpty
            ? error
            : 'Failed to update 2FA settings. Please try again.';
        AppSnackBar.error(context, msg);
      },
      (data) {
        debugPrint('AUTH: ✅ toggle2FA API success! Response: $data');
        if (context.mounted) {
          final message =
              (data is Map<String, dynamic> && data['message'] != null)
              ? data['message'].toString()
              : (enable
                    ? 'Two-Factor Authentication enabled.'
                    : 'Two-Factor Authentication disabled.');
          AppSnackBar.success(context, message);
        }
        success = true;
      },
    );

    _isLoading = false;
    notifyListeners();
    return success;
  }
}
