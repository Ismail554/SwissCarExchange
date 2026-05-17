import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:rionydo/app_utils/constants/font_manager.dart';
import 'package:rionydo/app_utils/utils/app_colors.dart';

class MyBidCard extends StatelessWidget {
  final String? imageUrl;
  final String title;
  final String status; // WINNING, OUTBID, WON, LOST
  final double currentBid;
  final int totalBidders;
  final String timeLeft; // or "Ended"
  final int totalBids;
  final VoidCallback? onBidHigher;
  final VoidCallback? onTap;

  const MyBidCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.status,
    required this.currentBid,
    required this.timeLeft,
    required this.totalBidders,
    required this.totalBids,
    this.onBidHigher,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    IconData? statusIcon;

    switch (status.toUpperCase()) {
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

    final hasImage = imageUrl != null && imageUrl!.isNotEmpty;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 20.h),
        decoration: BoxDecoration(
          color: AppColors.sceCardBg,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── IMAGE SECTION ──
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(16.r),
                  ),
                  child: hasImage
                      ? CachedNetworkImage(
                          imageUrl: imageUrl!,
                          height: 180.h,
                          width: double.maxFinite,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Shimmer.fromColors(
                            baseColor: Colors.white.withValues(alpha: 0.05),
                            highlightColor: Colors.white.withValues(alpha: 0.1),
                            child: Container(
                              height: 180.h,
                              width: double.maxFinite,
                              color: Colors.white,
                            ),
                          ),
                          errorWidget: (_, _, _) => _buildPlaceholderImage(),
                        )
                      : _buildPlaceholderImage(),
                ),
                // Status Badge on Image
                Positioned(
                  top: 12.h,
                  right: 12.w,
                  child: _buildStatusBadge(statusColor, statusIcon, status),
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
                    style: FontManager.heading3(
                      color: Colors.white,
                    ).copyWith(fontSize: 18.sp),
                  ),
                  SizedBox(height: 16.h),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildCountColumn("Total Bids", totalBids),
                      _buildCountColumn("Total Bidders", totalBidders),
                      _buildBidColumn("Current Bid", currentBid, isTeal: true),
                    ],
                  ),

                  SizedBox(height: 16.h),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            color: AppColors.sceGreyA0,
                            size: 14.sp,
                          ),
                          SizedBox(width: 6.w),
                          Text(timeLeft, style: FontManager.hintText()),
                        ],
                      ),
                      if (status.toUpperCase() == "OUTBID" &&
                          onBidHigher != null)
                        GestureDetector(
                          onTap: onBidHigher,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 8.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.sceTeal,
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Text(
                              "Bid Higher",
                              style: FontManager.labelMedium(
                                color: Colors.white,
                              ).copyWith(fontWeight: FontWeight.bold),
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
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      height: 180.h,
      width: double.maxFinite,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.sceCardBg, Colors.white.withValues(alpha: 0.05)],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.directions_car_filled_outlined,
              color: Colors.white30,
              size: 48.sp,
            ),
            SizedBox(height: 8.h),
            Text(
              "No Image Available",
              style: FontManager.hintText().copyWith(
                color: Colors.white38,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(
    Color statusColor,
    IconData? statusIcon,
    String status,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.9),
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
            status.toUpperCase(),
            style: TextStyle(
              color: Colors.white,
              fontSize: 10.sp,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCountColumn(String label, int value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: FontManager.hintText()),
        Text(
          "$value",
          style: FontManager.titleText(
            color: Colors.white,
          ).copyWith(fontSize: 18.sp),
        ),
      ],
    );
  }

  Widget _buildBidColumn(String label, double value, {required bool isTeal}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: FontManager.hintText()),
        Text(
          "CHF ${value.toStringAsFixed(0)}",
          style: FontManager.titleText(
            color: isTeal ? AppColors.sceTeal : Colors.white,
          ).copyWith(fontSize: 18.sp),
        ),
      ],
    );
  }
}
