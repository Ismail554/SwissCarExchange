import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rionydo/core/widgets/common_background.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return CommonBackground(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person_rounded,
              color: const Color(0xFF00D5BE),
              size: 64.sp,
            ),
            SizedBox(height: 16.h),
            Text(
              'Profile',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Manage your account settings',
              style: TextStyle(color: Colors.white54, fontSize: 14.sp),
            ),
          ],
        ),
      ),
    );
  }
}
