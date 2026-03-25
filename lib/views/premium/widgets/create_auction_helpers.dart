import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rionydo/core/constants/font_manager.dart';
import 'package:rionydo/core/utils/app_colors.dart';

class CreateAuctionHelpers {
  /// Vertical center handle for bottom sheets
  static Widget sheetHandle() {
    return Container(
      width: 40.w,
      height: 4.h,
      decoration: BoxDecoration(
        color: Colors.white24,
        borderRadius: BorderRadius.circular(2.r),
      ),
    );
  }

  /// Option row for bottom sheets (pickers)
  static Widget sheetOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? color,
  }) {
    final c = color ?? Colors.white;
    return ListTile(
      leading: Icon(icon, color: c, size: 24.sp),
      title: Text(label, style: FontManager.bodyMedium(color: c)),
      onTap: onTap,
    );
  }

  /// Row with icon and text for media categories
  static Widget mediaSubLabel(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, color: AppColors.sceGreyA0, size: 18.sp),
        SizedBox(width: 6.w),
        Text(label, style: FontManager.bodySmall(color: AppColors.sceGreyA0)),
      ],
    );
  }

  /// Dashed/bordered placeholder for uploading
  static Widget uploadButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    String? subtitle,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 14.h),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.04),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.white.withOpacity(0.08)),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: AppColors.sceGreyA0, size: 20.sp),
                SizedBox(width: 8.w),
                Text(
                  label,
                  style: FontManager.labelMedium(color: AppColors.sceGreyA0),
                ),
              ],
            ),
            if (subtitle != null) ...[
              SizedBox(height: 4.h),
              Text(
                subtitle,
                style: FontManager.labelSmall(color: AppColors.sceGreyA0)
                    .copyWith(fontSize: 10.sp),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// The teal card showing a selected file (video/doc)
  static Widget selectedFileCard({
    required IconData icon,
    required String fileName,
    required String sizeString,
    required VoidCallback onRemove,
    VoidCallback? onReplace,
  }) {
    return GestureDetector(
      onTap: onReplace,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: AppColors.sceTealStatBg,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.sceTeal.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: AppColors.sceTeal.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(icon, color: AppColors.sceTeal, size: 22.sp),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fileName,
                    style: FontManager.labelMedium(color: Colors.white)
                        .copyWith(fontSize: 13.sp),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    sizeString,
                    style: FontManager.labelSmall(color: AppColors.sceGreyA0)
                        .copyWith(fontSize: 11.sp),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: onRemove,
              child: Container(
                padding: EdgeInsets.all(6.w),
                decoration: BoxDecoration(
                  color: AppColors.errorRed.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.close,
                  color: AppColors.errorRed,
                  size: 16.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
