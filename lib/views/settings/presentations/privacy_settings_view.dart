import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rionydo/app_helper/secure_storage_helper.dart';
import 'package:rionydo/app_utils/constants/api_service.dart';
import 'package:rionydo/app_utils/constants/font_manager.dart';
import 'package:rionydo/app_utils/network/dio_manager.dart';
import 'package:rionydo/app_utils/network/enums.dart';
import 'package:rionydo/app_utils/utils/app_colors.dart';
import 'package:rionydo/app_utils/utils/app_spacing.dart';
import 'package:rionydo/core/widgets/common_background.dart';
import 'package:rionydo/core/widgets/custom_back_button.dart';
import 'package:rionydo/core/widgets/custom_button.dart';
import 'package:rionydo/core/widgets/custom_text_field.dart';
import 'package:rionydo/core/widgets/widget_snackbar.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:rionydo/controllers/auth/auth_provider.dart';

class PrivacySettingsView extends StatefulWidget {

  const PrivacySettingsView({super.key});

  @override
  State<PrivacySettingsView> createState() => _PrivacySettingsViewState();
}

class _PrivacySettingsViewState extends State<PrivacySettingsView> {
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _showDeleteAccountDialog() {

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => const _DeleteAccountDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CommonBackground(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const CustomBackButton(),
        title: Text(
          'Security & Privacy',
          style: FontManager.titleText(color: AppColors.white),
        ),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text(
            //   "SECURITY",
            //   style: FontManager.labelMedium(color: AppColors.sceGreyA0),
            // ),
            // AppSpacing.h16,
            // Container(
            //   decoration: BoxDecoration(
            //     color: AppColors.sceCardBg,
            //     borderRadius: BorderRadius.circular(16.r),
            //     border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
            //   ),
            //   child: Column(
            //     children: [
            //       _SecurityOption(
            //         icon: Icons.lock_outline,
            //         title: "Change Password",
            //         subtitle: "Last changed 30 days ago",
            //         onTap: () {
            //           // Logic to trigger password change flow/fields
            //         },
            //       ),
            //       Divider(color: Colors.white.withValues(alpha: 0.05), height: 1),
            //       Padding(
            //         padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            //         child: Row(
            //           children: [
            //             Icon(Icons.phone_android_outlined, color: AppColors.sceGreyA0, size: 24.sp),
            //             AppSpacing.w16,
            //             Expanded(
            //               child: Column(
            //                 crossAxisAlignment: CrossAxisAlignment.start,
            //                 children: [
            //                   Text(
            //                     "Two-Factor Authentication",
            //                     style: FontManager.bodyMedium(color: AppColors.white)
            //                         .copyWith(fontWeight: FontWeight.w600),
            //                   ),
            //                   Text(
            //                     "Add an extra layer of security",
            //                     style: FontManager.bodySmall(color: AppColors.sceGrey99),
            //                   ),
            //                 ],
            //               ),
            //             ),
            //             CupertinoSwitch(
            //               activeColor: AppColors.sceTeal,
            //               value: _twoFactorEnabled,
            //               onChanged: (val) => setState(() => _twoFactorEnabled = val),
            //             ),
            //           ],
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            // AppSpacing.h40,
            // Change Password Form (Optional if user taps Change Password, showing it directly for convenience)
            Text(
              "CHANGE PASSWORD",
              style: FontManager.labelMedium(color: AppColors.sceGreyA0),
            ),
            AppSpacing.h16,
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextField(
                    controller: _currentPasswordController,
                    hintText: "Enter Current Password",
                    obscureText: _obscureCurrent,
                    prefixIcon: const Icon(Icons.lock_open, color: AppColors.sceGreyA0),
                    suffixIcon: GestureDetector(
                      onTap: () => setState(() => _obscureCurrent = !_obscureCurrent),
                      child: Icon(
                        _obscureCurrent ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                        color: AppColors.sceGreyA0,
                        size: 20.sp,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Current password is required';
                      }
                      return null;
                    },
                  ),
                  AppSpacing.h16,
                  CustomTextField(
                    controller: _newPasswordController,
                    hintText: "Enter New Password",
                    obscureText: _obscureNew,
                    prefixIcon: const Icon(Icons.lock_outline, color: AppColors.sceGreyA0),
                    suffixIcon: GestureDetector(
                      onTap: () => setState(() => _obscureNew = !_obscureNew),
                      child: Icon(
                        _obscureNew ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                        color: AppColors.sceGreyA0,
                        size: 20.sp,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'New password is required';
                      }
                      if (value.trim().length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  AppSpacing.h16,
                  CustomTextField(
                    controller: _confirmPasswordController,
                    hintText: "Confirm New Password",
                    obscureText: _obscureConfirm,
                    prefixIcon: const Icon(Icons.lock_person, color: AppColors.sceGreyA0),
                    suffixIcon: GestureDetector(
                      onTap: () => setState(() => _obscureConfirm = !_obscureConfirm),
                      child: Icon(
                        _obscureConfirm ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                        color: AppColors.sceGreyA0,
                        size: 20.sp,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please confirm your new password';
                      }
                      if (value != _newPasswordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  AppSpacing.h24,
                  Consumer<AuthProvider>(
                    builder: (context, authProvider, child) {
                      return CustomButton(
                        text: "Change Password",
                        isLoading: authProvider.isLoading,
                        onPressed: authProvider.isLoading
                            ? () {}
                            : () async {
                                if (_formKey.currentState!.validate()) {
                                  final success = await authProvider.changePassword(
                                    context,
                                    currentPassword: _currentPasswordController.text.trim(),
                                    newPassword: _newPasswordController.text.trim(),
                                  );
                                  if (success) {
                                    _currentPasswordController.clear();
                                    _newPasswordController.clear();
                                    _confirmPasswordController.clear();
                                  }
                                }
                              },
                      );
                    },
                  ),
                ],
              ),
            ),


            AppSpacing.h48,
            Text(
              "DANGER ZONE",
              style: FontManager.labelMedium(color: AppColors.errorRed),
            ),
            AppSpacing.h16,
            InkWell(
              onTap: _showDeleteAccountDialog,
              borderRadius: BorderRadius.circular(16.r),
              child: Container(
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: AppColors.errorRed.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: AppColors.errorRed.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.delete_outline,
                      color: AppColors.errorRed,
                      size: 28.sp,
                    ),
                    AppSpacing.w16,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Delete Account",
                            style: FontManager.bodyLarge(
                              color: AppColors.errorRed,
                            ).copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Permanently delete your account and data",
                            style: FontManager.bodySmall(
                              color: AppColors.errorRed.withValues(alpha: 0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            AppSpacing.h40,
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Delete Account Dialog — fully self‑contained StatefulWidget
// ---------------------------------------------------------------------------

class _DeleteAccountDialog extends StatefulWidget {
  const _DeleteAccountDialog();

  @override
  State<_DeleteAccountDialog> createState() => _DeleteAccountDialogState();
}

class _DeleteAccountDialogState extends State<_DeleteAccountDialog> {
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isDeleting = false;
  bool _obscurePassword = true;
  String? _errorMessage;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleDeleteAccount() async {
    // Validate the form first
    if (!_formKey.currentState!.validate()) return;

    final password = _passwordController.text.trim();

    setState(() {
      _isDeleting = true;
      _errorMessage = null;
    });

    try {
      final response = await DioManager.apiRequest(
        url: ApiService.deleteAccount,
        method: Methods.post,
        body: {'password': password},
      );

      if (!mounted) return;

      response.fold(
        (error) {
          // API returned an error — show it in the dialog
          setState(() {
            _isDeleting = false;
            _errorMessage = error.toString().contains('password')
                ? 'Incorrect password. Please try again.'
                : error.toString().isNotEmpty
                    ? error.toString()
                    : 'Failed to delete account. Please try again.';
          });
        },
        (data) async {
          // Account deleted successfully — clear session & navigate to login
          await SecureStorageHelper.clearSession();
          DioManager.logout();

          if (!mounted) return;

          // Close the dialog first
          Navigator.of(context).pop();

          // Show success message & navigate to login
          AppSnackBar.success(
            context,
            'Your account has been deleted successfully.',
          );

          context.go('/login');
        },
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isDeleting = false;
        _errorMessage = 'Something went wrong. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
        decoration: BoxDecoration(
          color: AppColors.sceCardBg.withValues(alpha: 0.95),
          borderRadius: BorderRadius.circular(28.r),
          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// 🔴 ICON
              Container(
                height: 70.h,
                width: 70.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      Colors.red.withValues(alpha: 0.2),
                      Colors.redAccent.withValues(alpha: 0.05),
                    ],
                  ),
                  border: Border.all(
                    color: Colors.redAccent.withValues(alpha: 0.4),
                    width: 1.2.w,
                  ),
                ),
                child: Icon(
                  Icons.delete_forever_rounded,
                  color: Colors.redAccent,
                  size: 34.sp,
                ),
              ),

              SizedBox(height: 20.h),

              ///  TITLE
              Text(
                "Delete Account",
                style: FontManager.heading2(
                  color: AppColors.white,
                ).copyWith(fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 10.h),

              /// ⚠️ DESCRIPTION
              Text(
                "This action is permanent and cannot be undone.\nAll your data will be erased forever.",
                style: FontManager.bodyMedium(color: AppColors.sceGreyA0),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 24.h),

              /// 🔑 PASSWORD FIELD
              CustomTextField(
                controller: _passwordController,
                hintText: "Enter your password",
                obscureText: _obscurePassword,
                prefixIcon: const Icon(
                  Icons.lock_outline,
                  color: AppColors.sceGreyA0,
                ),
                suffixIcon: GestureDetector(
                  onTap: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                  child: Icon(
                    _obscurePassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: AppColors.sceGreyA0,
                    size: 20.sp,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Password is required to delete your account';
                  }
                  if (value.trim().length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),

              /// ❌ ERROR MESSAGE
              if (_errorMessage != null) ...[
                SizedBox(height: 12.h),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 10.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.errorRed.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(
                      color: AppColors.errorRed.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: AppColors.errorRed,
                        size: 16.sp,
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: FontManager.bodySmall(
                            color: AppColors.errorRed,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              SizedBox(height: 24.h),

              ///  DELETE BUTTON
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.errorRed,
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    elevation: 0,
                    disabledBackgroundColor:
                        AppColors.errorRed.withValues(alpha: 0.4),
                  ),
                  onPressed: _isDeleting ? null : _handleDeleteAccount,
                  child: _isDeleting
                      ? SizedBox(
                          height: 20.sp,
                          width: 20.sp,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          "Delete My Account",
                          style: FontManager.bodyMedium(
                            color: Colors.white,
                          ).copyWith(fontWeight: FontWeight.w600),
                        ),
                ),
              ),

              SizedBox(height: 12.h),

              /// CANCEL BUTTON (Ghost style)
              CustomButton(
                text: "Cancel",
                onPressed: _isDeleting ? () {} : () => Navigator.pop(context),
                isPrimary: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
