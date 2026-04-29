import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rionydo/app_utils/constants/font_manager.dart';
import 'package:rionydo/app_utils/utils/app_colors.dart';

class PaymentInfoCard extends StatelessWidget {
  const PaymentInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.sceTealStatBg.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.sceTeal.withOpacity(0.1)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.attach_money_rounded,
            color: AppColors.sceTeal,
            size: 24.sp,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Payment Processing",
                  style: FontManager.bodyMedium(
                    color: Colors.white,
                  ).copyWith(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4.h),
                Text(
                  "Payments are transferred to your registered bank account within 2-3 business days after buyer confirmation.",
                  style: FontManager.bodySmall(
                    color: AppColors.textHint,
                  ).copyWith(height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
