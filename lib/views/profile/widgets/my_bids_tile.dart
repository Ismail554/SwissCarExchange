import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rionydo/app_utils/utils/app_colors.dart';


class MyBidsTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  const MyBidsTile({
    super.key,
    this.title = "",
    this.icon = Icons.feed_outlined,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.sceCardBg,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.darkGrey, width: 1),
      ),
      child: ListTile(
        leading: Icon(icon, color: AppColors.sceGold, size: 20.sp),
        title: Text(
          title,
          style: TextStyle(
            color: AppColors.sceGold,
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: Icon(Icons.chevron_right, color: AppColors.grey, size: 20.sp),
        onTap: onTap,
      ),
    );
  }
}
