import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wynante/core/app_colors.dart';
import 'package:wynante/core/font_manager.dart';

class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final String? subValue;
  final String? labelDesc;
  final Color accentColor;
  final bool isWatchlist;

  const StatCard({
    super.key,
    required this.label,
    required this.value,
    this.subValue,
    this.labelDesc,
    required this.accentColor,
    this.isWatchlist = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      height: 100.h,
      decoration: BoxDecoration(
        color: isWatchlist ? AppColors.sceGoldStatBg : AppColors.sceTealStatBg,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: accentColor.withOpacity(0.15)),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: FontManager.labelMedium(
                  color: accentColor.withOpacity(0.8),
                  fontSize: 10.sp,
                ).copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                value,
                style: FontManager.heading3(
                  color: accentColor,
                  fontSize: 18.sp,
                ).copyWith(fontWeight: FontWeight.w800),
              ),
              if (subValue != null)
                Text(
                  subValue!,
                  style: FontManager.bodySmall(
                    color: const Color(0xFF00D5BE).withOpacity(0.6),
                    fontSize: 10.sp,
                  ),
                ),
              if (labelDesc != null)
                Text(
                  labelDesc!,
                  style: FontManager.bodySmall(
                    color: Colors.white30,
                    fontSize: 10.sp,
                  ),
                ),
            ],
          ),
          if (isWatchlist)
            Positioned(
              right: 0,
              top: 0,
              child: Icon(Icons.star_rounded, color: accentColor, size: 18.sp),
            ),
        ],
      ),
    );
  }
}
