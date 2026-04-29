import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rionydo/app_utils/constants/font_manager.dart';
import 'package:rionydo/app_utils/utils/app_colors.dart';
import 'package:rionydo/core/widgets/widget_snackbar.dart';

class PaymentTransactionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String status;
  final String amount;
  final String date;
  final Color statusColor;

  const PaymentTransactionCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.status,
    required this.amount,
    required this.date,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.sceCardBg,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 20.r,
                backgroundColor: AppColors.sceTeal.withOpacity(0.1),
                child: Icon(
                  Icons.person_outline_rounded,
                  color: AppColors.sceTeal,
                  size: 20.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: FontManager.bodyMedium(
                        color: Colors.white,
                      ).copyWith(fontWeight: FontWeight.bold, fontSize: 16.sp),
                    ),
                    Text(subtitle, style: FontManager.hintText()),
                  ],
                ),
              ),
              Text(
                status,
                style: FontManager.labelSmall(
                  color: statusColor,
                ).copyWith(fontWeight: FontWeight.bold, letterSpacing: 0.5),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Amount",
                    style: FontManager.labelSmall(color: AppColors.sceGreyA0),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    "CHF $amount",
                    style: FontManager.heading3(
                      color: AppColors.sceTeal,
                    ).copyWith(fontWeight: FontWeight.w900),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        color: AppColors.sceGreyA0,
                        size: 12.sp,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        "Date",
                        style: FontManager.labelSmall(
                          color: AppColors.sceGreyA0,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    date,
                    style: FontManager.bodyMedium(color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
          if (status == "COMPLETED") ...[
            SizedBox(height: 4.h),
            Divider(color: Colors.white.withOpacity(0.1), thickness: 1),
            SizedBox(height: 2.h),
            SizedBox(
              width: double.maxFinite,
              child: ElevatedButton.icon(
                onPressed: () {
                  AppSnackBar.success(context, "Invoice is downloading.....");
                },
                icon: Icon(
                  Icons.download_rounded,
                  color: Colors.white,
                  size: 18.sp,
                ),
                label: Text(
                  "Download Invoice",
                  style: FontManager.labelMedium(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4A5568),
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  elevation: 0,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
