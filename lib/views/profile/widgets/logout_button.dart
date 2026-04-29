import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rionydo/app_helper/secure_storage_helper.dart';
import 'package:rionydo/app_utils/constants/font_manager.dart';
import 'package:rionydo/app_utils/network/dio_manager.dart';
import 'package:rionydo/app_utils/utils/app_colors.dart';
import 'package:rionydo/views/auth/login/login_views.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: OutlinedButton(
        onPressed: () {
          Navigator.pop(context); // Close dialog
          SecureStorageHelper.clearSession();
          DioManager.logout();
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginViews(),
            ),
            (route) => false,
          );
          // Navigator.pop()
        },
        style: OutlinedButton.styleFrom(
          backgroundColor: AppColors.error.withOpacity(0.05),
          side: BorderSide(color: AppColors.error.withOpacity(0.3)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          padding: EdgeInsets.symmetric(vertical: 16.h),
        ),
        child: Row(
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
