import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:rionydo/app_utils/constants/global_state.dart';
import 'package:rionydo/app_utils/utils/app_colors.dart';
import 'package:rionydo/app_utils/constants/font_manager.dart';

class PremiumDealerCard extends StatelessWidget {
  const PremiumDealerCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isPremium = context.watch<GlobalState>().isPremium;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isPremium ? AppColors.sceTeal.withOpacity(0.1) : AppColors.scePremiumDealerBg,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: isPremium ? AppColors.sceTeal : AppColors.sceGold.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: isPremium ? AppColors.sceTeal : AppColors.sceGold,
              shape: BoxShape.circle,
            ),
            child: Icon(
              isPremium ? Icons.verified : Icons.workspace_premium_rounded,
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
                  isPremium ? 'Premium Active' : 'Become a Premium Dealer',
                  style: FontManager.labelMedium(
                    color: isPremium ? AppColors.white : AppColors.sceGold,
                    fontSize: 13.sp,
                  ).copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  isPremium ? 'You have priority access and advanced features.' : 'Own auctions & unlock advanced features',
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

