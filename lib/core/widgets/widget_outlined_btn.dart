import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WidgetOutlinedBtn extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color themeColor;
  final VoidCallback onPressed; // Added onPressed parameter

  const WidgetOutlinedBtn({
    super.key,
    required this.title,
    required this.icon,
    required this.themeColor,
    required this.onPressed, // Added to constructor
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: OutlinedButton(
        onPressed: onPressed, // Using the parameter here
        style: OutlinedButton.styleFrom(
          backgroundColor: themeColor.withValues(alpha: 0.2),
          side: BorderSide(color: themeColor, width: 1.5),
          fixedSize: Size(1.sw, 60.h), // Made responsive with ScreenUtil
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
        // Use a Row as the child to swap the order
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                color: themeColor,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(width: 10.w), // Space between text and icon
            Icon(icon, color: themeColor, size: 20.sp),
          ],
        ),
      ),
    );
  }
}