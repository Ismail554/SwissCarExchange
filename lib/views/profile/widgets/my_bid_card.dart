import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rionydo/core/constants/font_manager.dart';
import 'package:rionydo/core/utils/app_colors.dart';

class MyBidCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String status; // WINNING, OUTBID, WON, LOST
  final double myBid;
  final double currentBid;
  final String timeLeft; // or "Ended"
  final VoidCallback? onBidHigher;

  const MyBidCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.status,
    required this.myBid,
    required this.currentBid,
    required this.timeLeft,
    this.onBidHigher,
  });

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    IconData? statusIcon;

    switch (status) {
      case "WINNING":
        statusColor = AppColors.sceTeal;
        statusIcon = Icons.emoji_events_outlined;
        break;
      case "OUTBID":
        statusColor = AppColors.errorRed;
        statusIcon = Icons.cancel_outlined;
        break;
      case "WON":
        statusColor = Colors.orange;
        statusIcon = Icons.emoji_events_rounded;
        break;
      case "LOST":
        statusColor = Colors.grey;
        statusIcon = null;
        break;
      default:
        statusColor = AppColors.sceTeal;
        statusIcon = null;
    }

    return Container(
      margin: EdgeInsets.only(bottom: 20.h),
      decoration: BoxDecoration(
        color: AppColors.sceCardBg,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── IMAGE SECTION ──
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
                child: Image.network(
                  imageUrl,
                  height: 180.h,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 180.h,
                    color: Colors.white10,
                    child: const Icon(Icons.image_not_supported_outlined, color: Colors.white24),
                  ),
                ),
              ),
              // Status Badge
              Positioned(
                top: 12.h,
                right: 12.w,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (statusIcon != null) ...[
                        Icon(statusIcon, color: Colors.white, size: 12.sp),
                        SizedBox(width: 4.w),
                      ],
                      Text(
                        status,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          Padding(
            padding: EdgeInsets.all(16.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: FontManager.heading3(color: Colors.white).copyWith(fontSize: 18.sp),
                ),
                SizedBox(height: 16.h),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildBidColumn("My Bid", myBid),
                    _buildBidColumn("Current Bid", currentBid),
                  ],
                ),

                SizedBox(height: 16.h),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.access_time, color: AppColors.sceGreyA0, size: 14.sp),
                        SizedBox(width: 6.w),
                        Text(timeLeft, style: FontManager.hintText()),
                      ],
                    ),
                    if (status == "OUTBID" && onBidHigher != null)
                      GestureDetector(
                        onTap: onBidHigher,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                          decoration: BoxDecoration(
                            color: AppColors.sceTeal,
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Text(
                            "Bid Higher",
                            style: FontManager.labelMedium(color: Colors.white).copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBidColumn(String label, double value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: FontManager.hintText()),
        Text(
          "CHF ${value.toStringAsFixed(0)}",
          style: FontManager.titleText(color: AppColors.sceTeal).copyWith(fontSize: 18.sp),
        ),
      ],
    );
  }
}
