import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rionydo/app_utils/utils/app_colors.dart';
import 'package:rionydo/views/profile/presentations/my_bids_view.dart';

class MyBidsTile extends StatelessWidget {
  const MyBidsTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.sceCardBg,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.darkGrey, width: 1),
      ),
      child: ListTile(
        leading: Icon(
          Icons.feed_outlined,
          color: AppColors.sceGold,
          size: 20.sp,
        ),
        title: Text(
          'My Bids',
          style: TextStyle(
            color: AppColors.sceGold,
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: Icon(Icons.chevron_right, color: AppColors.grey, size: 20.sp),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MyBidsView()),
          );
        },
      ),
    );
  }
}
