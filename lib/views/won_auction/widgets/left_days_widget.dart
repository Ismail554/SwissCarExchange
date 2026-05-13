import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rionydo/app_utils/constants/font_manager.dart';
import 'package:rionydo/app_utils/utils/app_colors.dart';
import 'package:rionydo/app_utils/utils/app_spacing.dart';

class LeftDaysWidget extends StatelessWidget {
  final DateTime deadline;

  const LeftDaysWidget({super.key, required this.deadline});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final difference = deadline.difference(now);
    final isExpired = difference.isNegative;

    final days = isExpired ? 0 : difference.inDays;
    final hours = isExpired ? 0 : difference.inHours % 24;

    final formattedDate = DateFormat('M/d/yyyy').format(deadline);

    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: const Color(0xFF1E140C), // Dark brown/orange tint
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: AppColors.sceOnboardingGold.withValues(alpha: 0.3),
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    color: AppColors.sceOnboardingGold,
                    size: 24.sp,
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '3-Day Communication Window',
                          style: FontManager.bodyMedium(
                            color: AppColors.white,
                          ).copyWith(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'Contact each other to arrange payment & delivery',
                          style: FontManager.bodySmall(
                            color: AppColors.sceGreyA0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 12.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF2A1B0D),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Column(
                  children: [
                    Text(
                      isExpired ? 'Expired' : '${days}d ${hours}h remaining',
                      style: FontManager.heading3(
                        color: AppColors.sceOnboardingGold,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Expires on $formattedDate',
                      style: FontManager.bodySmall(color: AppColors.sceGreyA0),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        AppSpacing.h32,
      ],
    );
  }
}
