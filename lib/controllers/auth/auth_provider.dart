import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rionydo/app_utils/network/dio_manager.dart';
import 'package:rionydo/app_utils/network/enums.dart';
import 'package:rionydo/app_utils/network/token_manager.dart';
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
import 'package:rionydo/views/auth/sign_up/verify_sign_up/presentations/pending_view.dart';
import 'package:rionydo/views/auth/sign_up/verify_sign_up/presentations/before_subs_view.dart';
import 'package:rionydo/models/subscription/subscription_plan.dart';

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
        print("Login response: $data");

        final loginData = LoginResponse.fromJson(data);

        // --- 1. Suspended account ---
        if (loginData.approvalStatus == 'suspended') {
          if (context.mounted) {
            AppSnackBar.error(
              context,
              "Your account is suspended. Contact your owner.\nOr try with another account.",
            );
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
            context.read<GlobalState>().setUserTypeFromString(
              loginData.userType,
            );
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const PendingView()),
              (route) => false,
            );
          }
          return;
        }

        // --- 3. Two-Factor Authentication required ---
        if (loginData.isTwoFactorRequired) {
          if (context.mounted) {
            if (loginData.message != null && loginData.message!.isNotEmpty) {
              AppSnackBar.success(context, loginData.message!);
            }
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OtpVerifyView(email: loginData.email),
              ),
            );
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
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const BeforeSubsView()),
            (route) => false,
          );
          return;
        }

        // Has subscription → set premium based on plan & go to main app
        final plan = loginData.subscription?.plan ?? SubscriptionPlanId.basic;
        context.read<GlobalState>().isPremium =
            (plan == SubscriptionPlanId.premium);
        await SecureStorageHelper.saveSubscriptionPlan(plan);

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const MainNavigationShell(
              pages: [HomeView(), AuctionsView(), BidsView(), ProfileView()],
            ),
          ),
          (route) => false,
        );
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
        AppSnackBar.error(context, error);
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
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const BeforeSubsView()),
            (route) => false,
          );
          return;
        }

        final plan = loginData.subscription?.plan ?? SubscriptionPlanId.basic;
        context.read<GlobalState>().isPremium =
            (plan == SubscriptionPlanId.premium);
        await SecureStorageHelper.saveSubscriptionPlan(plan);

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const MainNavigationShell(
              pages: [HomeView(), AuctionsView(), BidsView(), ProfileView()],
            ),
          ),
          (route) => false,
        );
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
            MaterialPageRoute(builder: (context) => const LoginViews()),
            (route) => false,
          );
        }
      },
    );

    _isLoading = false;
    notifyListeners();
  }

  // ----------------------------------------------------------------
  // LOGOUT
  // ----------------------------------------------------------------
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
              AppSnackBar.success(
                context,
                "Your account has been approved! Please login.",
              );
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
              AppSnackBar.success(
                context,
                "Subscription activated! Now login again.",
              );
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

    return subscriptionActive;
  }
}
