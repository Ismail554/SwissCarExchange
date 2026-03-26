import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rionydo/core/constants/font_manager.dart';
import 'package:rionydo/core/utils/app_colors.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: OutlinedButton(
        onPressed: () {
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
