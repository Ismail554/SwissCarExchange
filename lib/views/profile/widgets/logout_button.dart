import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rionydo/app_helper/secure_storage_helper.dart';
import 'package:rionydo/app_utils/constants/api_service.dart';
import 'package:rionydo/app_utils/constants/font_manager.dart';
import 'package:rionydo/app_utils/network/dio_manager.dart';
import 'package:rionydo/app_utils/network/enums.dart';
import 'package:rionydo/app_utils/utils/app_colors.dart';
import 'package:rionydo/views/auth/login/login_views.dart';

class LogoutButton extends StatefulWidget {
  const LogoutButton({super.key});

  @override
  State<LogoutButton> createState() => _LogoutButtonState();
}

class _LogoutButtonState extends State<LogoutButton> {
  bool _isLoading = false;

  Future<void> _handleLogout() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    try {
      // Send refresh token to backend logout endpoint
      final refreshToken = await SecureStorageHelper.getRefreshToken();
      await DioManager.apiRequest(
        url: ApiService.logout,
        method: Methods.post,
        body: {'refresh': refreshToken ?? ''},
      );
    } catch (_) {
      // Proceed with local logout even if API call fails
    }

    // Clear local session & Dio auth state
    await SecureStorageHelper.clearSession();
    DioManager.logout();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginViews()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: OutlinedButton(
        onPressed: _isLoading ? null : _handleLogout,
        style: OutlinedButton.styleFrom(
          backgroundColor: AppColors.error.withOpacity(0.05),
          side: BorderSide(color: AppColors.error.withOpacity(0.3)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          padding: EdgeInsets.symmetric(vertical: 16.h),
        ),
        child: _isLoading
            ? SizedBox(
                height: 20.sp,
                width: 20.sp,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.error,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.logout, color: AppColors.error, size: 20.sp),
                  SizedBox(width: 8.w),
                  Text(
                    'Logout',
                    style: FontManager.bodyMedium(color: AppColors.error),
                  ),
                ],
              ),
      ),
    );
  }
}
