import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rionydo/core/utils/app_colors.dart';
import 'package:rionydo/core/constants/font_manager.dart';

class PremiumDealerCard extends StatelessWidget {
  const PremiumDealerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.scePremiumDealerBg,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.sceGold.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: const BoxDecoration(
              color: AppColors.sceGold,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.workspace_premium_rounded,
              color: Colors.white,
              size: 20.sp,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Become a Premium Dealer',
                  style: FontManager.labelMedium(
                    color: AppColors.sceGold,
                    fontSize: 13.sp,
                  ).copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  'Own auctions & unlock advanced features',
                  style: FontManager.bodySmall(
                    color: Colors.white70,
                    fontSize: 11.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
