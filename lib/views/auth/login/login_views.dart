import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wynante/core/assets_manager.dart';
import 'package:wynante/core/global_state.dart';
import 'package:wynante/core/widgets/common_background.dart';
import 'package:wynante/core/widgets/custom_button.dart';
import 'package:wynante/core/widgets/custom_text_field.dart';
import 'package:wynante/views/auth/forgot_password/forgot_pass_view.dart';
import 'package:wynante/views/home/presentation/home_view.dart';
import 'package:wynante/views/auctions/presentations/auctions_view.dart';
import 'package:wynante/views/bidding/bids_view.dart';
import 'package:wynante/views/profile/profile_view.dart';
import 'package:wynante/views/main_navigation/bottom_nav.dart';

class LoginViews extends StatefulWidget {
  const LoginViews({super.key});

  @override
  State<LoginViews> createState() => _LoginViewsState();
}

class _LoginViewsState extends State<LoginViews> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

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
              Image.asset(IconAssets.app_logo, height: 40.h),
              SizedBox(height: 48.h),
              Text(
                'Welcome Back',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Sign in to continue',
                style: TextStyle(color: Colors.white54, fontSize: 16.sp),
              ),
              SizedBox(height: 48.h),
              CustomTextField(
                controller: _emailController,
                hintText: 'Email',
                prefixIcon: const Icon(
                  Icons.email_outlined,
                  color: Color(0xFFA0AABF),
                  size: 20,
                ),
              ),
              SizedBox(height: 16.h),
              CustomTextField(
                controller: _passwordController,
                hintText: 'Password',
                obscureText: _obscurePassword,
                prefixIcon: const Icon(
                  Icons.lock_outline,
                  color: Color(0xFFA0AABF),
                  size: 20,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: const Color(0xFFA0AABF),
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
                    style: TextStyle(color: Color(0xFF00D5BE)),
                  ),
                ),
              ),
              SizedBox(height: 24.h),
              CustomButton(
                text: 'Login',
                onPressed: () {
                  // Store premium status globally
                  GlobalState.isPremium = true; // Toggle to false to test basic user UI

                  Navigator.push(
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
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
