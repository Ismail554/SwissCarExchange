import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rionydo/app_utils/constants/font_manager.dart';
import 'package:rionydo/app_utils/utils/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:rionydo/app_utils/utils/assets_manager.dart';
import 'package:rionydo/app_utils/constants/global_state.dart';
import 'package:rionydo/core/widgets/common_background.dart';
import 'package:rionydo/core/widgets/custom_button.dart';
import 'package:rionydo/core/widgets/custom_text_field.dart';
import 'package:rionydo/views/auth/forgot_password/forgot_pass_view.dart';
import 'package:rionydo/views/auth/sign_up/presentations/sign_up_view.dart';
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

class LoginViews extends StatefulWidget {
  const LoginViews({super.key});

  @override
  State<LoginViews> createState() => _LoginViewsState();
}

class _LoginViewsState extends State<LoginViews> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  Future<void> _handleLogin() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      AppSnackBar.error(context, 'Please enter email and password');
      return;
    }

    setState(() => _isLoading = true);

    final response = await DioManager.apiRequest(
      url: ApiService.login,
      method: Methods.post,
      body: {
        'email': _emailController.text.trim(),
        'password': _passwordController.text,
      },
      skipAuth: true,
    );

    response.fold(
      (error) {
        setState(() => _isLoading = false);
        AppSnackBar.error(context, error);
      },
      (data) async {
        setState(() => _isLoading = false);
        final loginData = LoginResponse.fromJson(data);

        if (loginData.isTwoFactorRequired) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OtpVerifyView(email: loginData.email),
            ),
          );
        } else {
          await SecureStorageHelper.saveAccessToken(loginData.access);
          await SecureStorageHelper.saveRefreshToken(loginData.refresh);
          await SecureStorageHelper.saveUserType(loginData.userType);
          
          if (mounted) {
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

  @override
  Widget build(BuildContext context) {
    return CommonBackground(
      child: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 48.h),
              Image.asset(IconAssets.app_logo, height: 74.h),
              SizedBox(height: 48.h),
              Text(
                'Welcome Back',
                style: FontManager.heading1(
                  color: Colors.white,
                  fontSize: 32.sp,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Sign in to continue',
                style: FontManager.bodyMedium(
                  color: Colors.white54,
                  fontSize: 16.sp,
                ),
              ),
              SizedBox(height: 48.h),
              CustomTextField(
                textInputAction: .next,
                controller: _emailController,
                hintText: 'Email',
                prefixIcon: Icon(
                  Icons.email_outlined,
                  color: AppColors.sceGreyA0,
                  size: 20.sp,
                ),
              ),
              SizedBox(height: 16.h),
              CustomTextField(
                textInputAction: TextInputAction.done,
                controller: _passwordController,
                hintText: 'Password',
                obscureText: _obscurePassword,
                prefixIcon: Icon(
                  Icons.lock_outline,
                  color: AppColors.sceGreyA0,
                  size: 20.sp,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: AppColors.sceGreyA0,
                  ),
                  onPressed: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ForgotPassView(),
                      ),
                    );
                  },
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(color: AppColors.sceTeal),
                  ),
                ),
              ),
              SizedBox(height: 24.h),
              CustomButton(
                text: 'Login',
                isLoading: _isLoading,
                onPressed: _handleLogin,
              ),
              SizedBox(height: 24.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account? ",
                    style: FontManager.bodySmall(color: AppColors.sceGrey99),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignUpView(),
                        ),
                      );
                    },
                    child: Text(
                      "Sign Up",
                      style: FontManager.bodySmall(
                        color: AppColors.sceTeal,
                      ).copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
