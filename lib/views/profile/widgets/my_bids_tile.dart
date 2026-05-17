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

  const MyBidsTile({
    super.key,
    this.title = '',
    this.subtitle,
    this.icon = Icons.feed_outlined,
    required this.onTap,
    this.accentColor = AppColors.sceTeal,
  });

  @override
  Widget build(BuildContext context) {
    final Color iconBgStart = accentColor.withValues(alpha: 0.25);
    final Color iconBgEnd = accentColor.withValues(alpha: 0.08);

    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14.r),
          splashColor: accentColor.withValues(alpha: 0.08),
          highlightColor: accentColor.withValues(alpha: 0.04),
          child: Ink(
            decoration: BoxDecoration(
              color: AppColors.sceCardBg,
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(
                color: accentColor.withValues(alpha: 0.15),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                // Left accent bar
                Container(
                  width: 4.w,
                  height: 64.h,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        accentColor,
                        accentColor.withValues(alpha: 0.2),
                      ],
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(14.r),
                      bottomLeft: Radius.circular(14.r),
                    ),
                  ),
                ),
                SizedBox(width: 14.w),
                // Icon badge
                Container(
                  width: 44.w,
                  height: 44.w,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [iconBgStart, iconBgEnd],
                    ),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: accentColor.withValues(alpha: 0.25),
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    icon,
                    color: accentColor,
                    size: 20.sp,
                  ),
                ),
                SizedBox(width: 14.w),
                // Text content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: FontManager.labelMedium(
                          color: Colors.white,
                        ),
                      ),
                      if (subtitle != null) ...[
                        SizedBox(height: 2.h),
                        Text(
                          subtitle!,
                          style: FontManager.labelSmall(
                            color: AppColors.textHint,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                // Chevron
                Container(
                  margin: EdgeInsets.only(right: 14.w),
                  padding: EdgeInsets.all(6.w),
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: accentColor,
                    size: 12.sp,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
