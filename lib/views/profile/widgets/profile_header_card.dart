import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rionydo/app_utils/constants/font_manager.dart';
import 'package:rionydo/app_utils/utils/app_colors.dart';
import 'package:rionydo/app_utils/utils/app_spacing.dart';
import 'package:rionydo/views/profile/widgets/profile_helpers.dart';

class ProfileHeaderCard extends StatelessWidget {
  final bool isPremium;

  const ProfileHeaderCard({super.key, required this.isPremium});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColors.sceCardBg,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.darkGrey, width: 1),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 28.r,
                backgroundImage: const NetworkImage('https://i.pravatar.cc/150?img=11'),
                backgroundColor: AppColors.darkGrey,
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Premium Auto\nGroup AG',
                      style: FontManager.heading3(color: AppColors.white),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Member since 2023',
                      style: FontManager.bodySmall(color: AppColors.grey),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: isPremium ? AppColors.scePremiumDealerBg : Colors.transparent,
                  borderRadius: BorderRadius.circular(100.r),
                  border: Border.all(
                    color: isPremium ? AppColors.sceGold : AppColors.sceTeal,
                  ),
                ),
                child: Text(
                  isPremium ? 'Premium' : 'Basic',
                  style: TextStyle(
                    color: isPremium ? AppColors.sceGold : AppColors.sceTeal,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          AppSpacing.h20,
          Container(
            height: 1,
            color: AppColors.darkGrey,
          ),
          AppSpacing.h20,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ProfileStatItem('47', 'Bids', AppColors.sceTeal),
              ProfileStatItem('12', 'Won', AppColors.sceGold),
              ProfileStatItem('96%', 'Success Rate', AppColors.sceTeal),
            ],
          ),
        ],
      ),
    );
  }
}
