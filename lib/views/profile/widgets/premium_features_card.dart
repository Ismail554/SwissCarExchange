import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rionydo/core/utils/app_colors.dart';
import 'package:rionydo/views/profile/widgets/profile_helpers.dart';

class PremiumFeaturesCard extends StatelessWidget {
  const PremiumFeaturesCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 4.w, bottom: 12.h),
          child: Row(
            children: [
              Icon(Icons.workspace_premium, color: AppColors.sceGold, size: 20.sp),
              SizedBox(width: 8.w),
              Text(
                'PREMIUM FEATURES',
                style: TextStyle(
                  color: AppColors.sceGold,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.sceCardBg,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: AppColors.darkGrey, width: 1),
          ),
          child: const Column(
            children: [
              ProfileListTile(Icons.add, 'Create Auction', isPremiumFeature: true),
              ProfileDivider(),
              ProfileListTile(Icons.inventory_2_outlined, 'Auction Management', isPremiumFeature: true),
              ProfileDivider(),
              ProfileListTile(Icons.trending_up, 'Advanced Statistics', isPremiumFeature: true),
              ProfileDivider(),
              ProfileListTile(Icons.attach_money, 'Receive Payments', isPremiumFeature: true),
            ],
          ),
        ),
      ],
    );
  }
}
