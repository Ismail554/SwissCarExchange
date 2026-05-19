import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rionydo/app_utils/constants/font_manager.dart';
import 'package:rionydo/app_utils/utils/app_colors.dart';

class MyBidsTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final VoidCallback onTap;
  final Color accentColor;
  final List<Color> gradientColors;

  const MyBidsTile({
    super.key,
    this.title = '',
    this.subtitle,
    this.icon = Icons.feed_outlined,
    required this.onTap,
    this.accentColor = AppColors.sceTeal,
    this.gradientColors = const [AppColors.sceTeal, AppColors.sceTealDark],
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.sceCardBg,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.03),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16.r),
          splashColor: accentColor.withValues(alpha: 0.08),
          highlightColor: accentColor.withValues(alpha: 0.04),
          child: Padding(
            padding: EdgeInsets.all(16.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 40.r,
                      height: 40.r,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: gradientColors,
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: gradientColors.first.withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Icon(
                        icon,
                        color: Colors.white,
                        size: 20.sp,
                      ),
                    ),
                    Icon(
                      Icons.arrow_outward_rounded,
                      color: AppColors.sceGreyA0.withValues(alpha: 0.5),
                      size: 16.sp,
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                // Text content
                Text(
                  title,
                  style: FontManager.heading3(color: Colors.white).copyWith(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (subtitle != null) ...[
                  SizedBox(height: 4.h),
                  Text(
                    subtitle!,
                    style: FontManager.bodySmall(color: AppColors.sceGreyA0).copyWith(
                      fontSize: 11.sp,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
