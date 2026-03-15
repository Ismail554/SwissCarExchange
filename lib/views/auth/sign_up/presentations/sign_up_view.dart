import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wynante/core/assets_manager.dart';
import 'package:wynante/core/widgets/common_background.dart';
import 'package:wynante/core/widgets/custom_button.dart';
import 'package:wynante/core/widgets/custom_text_field.dart';
import 'package:wynante/views/auth/sign_up/presentations/sign_up_step2.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _obscurePassword = true;
  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_validate);
    _passwordController.addListener(_validate);
    _phoneController.addListener(_validate);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _validate() {
    final valid = _emailController.text.trim().contains('@') &&
        _passwordController.text.length >= 6 &&
        _phoneController.text.trim().length >= 6;
    if (_isFormValid != valid) setState(() => _isFormValid = valid);
  }

  @override
  Widget build(BuildContext context) {
    return CommonBackground(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Step badge
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2A2208),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: const Color(0xFFE2B93B).withOpacity(0.4)),
                        ),
                        child: Text(
                          '1. REGISTRATION',
                          style: TextStyle(
                            color: const Color(0xFFE2B93B),
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 32.h),

                    // Logo
                    Center(
                      child: Image.asset(
                        IconAssets.app_logo,
                        height: 80.h,
                      ),
                    ),

                    SizedBox(height: 36.h),

                    // Dealer Registration Title
                    Text(
                      'DEALER',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28.sp,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 2,
                      ),
                    ),
                    Text(
                      'REGISTRATION',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: const Color(0xFF00D5BE),
                        fontSize: 28.sp,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 2,
                      ),
                    ),

                    SizedBox(height: 36.h),

                    // E-Mail Label
                    Text(
                      'E-Mail',
                      style: TextStyle(color: Colors.white70, fontSize: 13.sp),
                    ),
                    SizedBox(height: 8.h),
                    CustomTextField(
                      controller: _emailController,
                      hintText: 'info@premiumauto.ch',
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: const Icon(Icons.email_outlined, color: Color(0xFFA0AABF), size: 20),
                    ),

                    SizedBox(height: 20.h),

                    // Password Label
                    Text(
                      'Password',
                      style: TextStyle(color: Colors.white70, fontSize: 13.sp),
                    ),
                    SizedBox(height: 8.h),
                    CustomTextField(
                      controller: _passwordController,
                      hintText: '••••••••',
                      obscureText: _obscurePassword,
                      prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFFA0AABF), size: 20),
                      suffixIcon: GestureDetector(
                        onTap: () => setState(() => _obscurePassword = !_obscurePassword),
                        child: Icon(
                          _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                          color: const Color(0xFFA0AABF),
                          size: 20,
                        ),
                      ),
                    ),

                    SizedBox(height: 20.h),

                    // Phone Label
                    Text(
                      'Phone',
                      style: TextStyle(color: Colors.white70, fontSize: 13.sp),
                    ),
                    SizedBox(height: 8.h),
                    CustomTextField(
                      controller: _phoneController,
                      hintText: '+41 79 123 45 67',
                      keyboardType: TextInputType.phone,
                      prefixIcon: const Icon(Icons.phone_outlined, color: Color(0xFFA0AABF), size: 20),
                    ),

                    SizedBox(height: 32.h),

                    // Continue Button
                    CustomButton(
                      text: 'Continue',
                      isActive: _isFormValid,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const SignUpStep2()),
                        );
                      },
                    ),

                    SizedBox(height: 20.h),

                    // Already registered?
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already registered?  ',
                          style: TextStyle(color: Colors.white54, fontSize: 13.sp),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Text(
                            'Login',
                            style: TextStyle(
                              color: const Color(0xFF00D5BE),
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 28.h),

                    // Security Badges
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _SecurityBadge(icon: Icons.shield_outlined, label: 'Secure Connection'),
                        SizedBox(width: 12.w),
                        _SecurityBadge(icon: Icons.lock_outline, label: 'SSL Encrypted'),
                      ],
                    ),

                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SecurityBadge extends StatelessWidget {
  final IconData icon;
  final String label;

  const _SecurityBadge({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: const Color(0xFFE2B93B).withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFE2B93B), size: 14.sp),
          SizedBox(width: 6.w),
          Text(
            label,
            style: TextStyle(color: Colors.white70, fontSize: 11.sp),
          ),
        ],
      ),
    );
  }
}