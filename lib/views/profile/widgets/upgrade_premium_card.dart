import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rionydo/core/utils/app_colors.dart';
import 'package:rionydo/core/utils/app_spacing.dart';

class UpgradePremiumCard extends StatelessWidget {
  const UpgradePremiumCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF3B250A), Color(0xFF1D1408)],
        ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.sceGold.withOpacity(0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Upgrade to Premium',
            style: TextStyle(
              color: AppColors.sceGold,
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          AppSpacing.h12,
          Text(
            'Get priority bidding, advanced analytics, and\ncreate your own auctions.',
            style: TextStyle(
              color: AppColors.greyD9,
              fontSize: 13.sp,
              height: 1.4,
            ),
          ),
          AppSpacing.h16,
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              backgroundColor: AppColors.scePremiumDealerBg,
              side: BorderSide(color: AppColors.sceGold.withOpacity(0.5)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Text(
              'View Benefits',
              style: TextStyle(
                color: AppColors.sceGold,
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
