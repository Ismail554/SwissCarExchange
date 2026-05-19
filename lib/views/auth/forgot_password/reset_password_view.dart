import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:rionydo/controllers/auth/auth_provider.dart';
import 'package:rionydo/app_utils/utils/app_colors.dart';
import 'package:rionydo/app_utils/utils/assets_manager.dart';
import 'package:rionydo/core/widgets/common_background.dart';
import 'package:rionydo/core/widgets/custom_back_button.dart';
import 'package:rionydo/core/widgets/custom_button.dart';
import 'package:rionydo/core/widgets/custom_text_field.dart';

class ResetPasswordView extends StatefulWidget {
  final String email;
  final String resetToken;

  const ResetPasswordView({
    super.key,
    required this.email,
    required this.resetToken,
  });

  @override
  State<ResetPasswordView> createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends State<ResetPasswordView> {
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
  bool _isPasswordValid = false;

  @override
  void initState() {
    super.initState();
    _newPasswordController.addListener(_validatePasswords);
    _confirmPasswordController.addListener(_validatePasswords);
  }

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _validatePasswords() {
    final pw = _newPasswordController.text;
    final confirm = _confirmPasswordController.text;
    final isValid = pw.isNotEmpty && pw.length >= 8 && pw == confirm;
    if (_isPasswordValid != isValid) {
      setState(() {
        _isPasswordValid = isValid;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CommonBackground(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top Bar with Back Button
            Padding(
              padding: EdgeInsets.only(left: 16.w, top: 16.h),
              child: Align(
                alignment: Alignment.centerLeft,
                child: const CustomBackButton(),
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 24.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 20.h),
                    // Logo Image
                    Image.asset(
                      IconAssets.appLogo,
                      width: 250.w,
                      height: 80.h,
                    ),

                    SizedBox(height: 48.h),

                    // Title
                    Text(
                      'Reset Password',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32.sp,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.5,
                      ),
                    ),
                    SizedBox(height: 12.h),

                    // Subtitle
                    Text(
                      'Create a new password for your account. Make sure it is at least 8 characters long.',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: AppColors.sceGreyA0,
                        fontSize: 15.sp,
                        height: 1.5,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 48.h),

                    /// New Password Text Field
                    CustomTextField(
                      controller: _newPasswordController,
                      textInputAction: TextInputAction.next,
                      hintText: 'Enter New Password',
                      obscureText: _obscureNewPassword,
                      prefixIcon: Icon(
                        Icons.lock_outline,
                        color: AppColors.sceGreyA0,
                        size: 20.sp,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureNewPassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: AppColors.sceGreyA0,
                        ),
                        onPressed: () => setState(
                          () => _obscureNewPassword = !_obscureNewPassword,
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),

                    /// Confirm Password Text Field
                    CustomTextField(
                      controller: _confirmPasswordController,
                      textInputAction: TextInputAction.done,
                      hintText: 'Confirm New Password',
                      obscureText: _obscureConfirmPassword,
                      prefixIcon: Icon(
                        Icons.lock_outline,
                        color: AppColors.sceGreyA0,
                        size: 20.sp,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmPassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: AppColors.sceGreyA0,
                        ),
                        onPressed: () => setState(
                          () => _obscureConfirmPassword =
                              !_obscureConfirmPassword,
                        ),
                      ),
                    ),
                    SizedBox(height: 32.h),

                    /// Reset Button
                    CustomButton(
                      text: 'Reset Password',
                      isActive: _isPasswordValid,
                      isLoading: context.watch<AuthProvider>().isLoading,
                      onPressed: () async {
                        final success = await context
                            .read<AuthProvider>()
                            .resetPassword(
                              context,
                              email: widget.email,
                              newPassword: _newPasswordController.text,
                              token: widget.resetToken,
                            );
                        if (success && context.mounted) {
                          context.go('/forgot-password/success', extra: 'approved');
                        }
                      },
                    ),
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
