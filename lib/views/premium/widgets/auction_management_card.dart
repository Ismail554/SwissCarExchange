import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rionydo/core/constants/font_manager.dart';
import 'package:rionydo/core/utils/app_colors.dart';

class AuctionManagementCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String status;
  final String subStatus;
  final int views;
  final int bids;
  final int bidders;
  final double currentBid;
  final double reservePrice;
  final bool isReserveMet;
  final String timeLeft;
  final VoidCallback onViewDetails;
  final VoidCallback onMenuTap;

  const AuctionManagementCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.status,
    required this.subStatus,
    required this.views,
    required this.bids,
    required this.bidders,
    required this.currentBid,
    required this.reservePrice,
    required this.isReserveMet,
    required this.timeLeft,
    required this.onViewDetails,
    required this.onMenuTap,
  });

  @override
  Widget build(BuildContext context) {
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
              // Badges
              Positioned(
                top: 12.h,
                left: 12.w,
                child: Row(
                  children: [
                    _buildBadge(status, AppColors.sceTeal),
                    SizedBox(width: 6.w),
                    _buildBadge(subStatus, subStatus == "LIVE" ? AppColors.errorRed.withOpacity(0.8) : Colors.blue.withOpacity(0.8)),
                  ],
                ),
              ),
              // Menu Icon
              Positioned(
                top: 12.h,
                right: 12.w,
                child: GestureDetector(
                  onTap: onMenuTap,
                  child: Container(
                    padding: EdgeInsets.all(6.r),
                    decoration: BoxDecoration(
                      color: Colors.black45,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Icon(Icons.more_vert_rounded, color: Colors.white, size: 20.sp),
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
                // Title
                Text(
                  title,
                  style: FontManager.heading3(color: Colors.white).copyWith(fontSize: 18.sp),
                ),
                SizedBox(height: 16.h),

                // Stats Row
                Row(
                  children: [
                    _buildStatItem("Views", views, Icons.visibility_outlined, Colors.cyan),
                    SizedBox(width: 12.w),
                    _buildStatItem("Bids", bids, Icons.trending_up_rounded, Colors.tealAccent),
                    SizedBox(width: 12.w),
                    _buildStatItem("Bidders", bidders, Icons.group_outlined, Colors.orangeAccent),
                  ],
                ),
                SizedBox(height: 16.h),

                // Price Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Current Bid", style: FontManager.hintText()),
                        Text(
                          "CHF ${currentBid.toStringAsFixed(0)}",
                          style: FontManager.titleText(color: AppColors.sceTeal).copyWith(fontSize: 18.sp),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text("Reserve", style: FontManager.hintText()),
                        Text(
                          "CHF ${reservePrice.toStringAsFixed(0)}",
                          style: FontManager.bodyMedium(color: Colors.white).copyWith(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 12.h),

                // Reserve Price Met Indicator
                if (isReserveMet)
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
                    decoration: BoxDecoration(
                      color: AppColors.sceTeal.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(color: AppColors.sceTeal.withOpacity(0.2)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.check_rounded, color: AppColors.sceTeal, size: 14.sp),
                        SizedBox(width: 6.w),
                        Text(
                          "Reserve Price Met",
                          style: FontManager.labelSmall(color: AppColors.sceTeal).copyWith(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                
                SizedBox(height: 16.h),
                
                // Footer
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(timeLeft, style: FontManager.hintText()),
                    GestureDetector(
                      onTap: onViewDetails,
                      child: Row(
                        children: [
                          Text(
                            "View Details",
                            style: FontManager.labelMedium(color: AppColors.sceTeal),
                          ),
                          SizedBox(width: 4.w),
                          Icon(Icons.arrow_forward_rounded, color: AppColors.sceTeal, size: 14.sp),
                        ],
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

  Widget _buildBadge(String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: 10.sp,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, int val, IconData icon, Color iconColor) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 8.w),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.03),
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: Colors.white.withOpacity(0.03)),
        ),
        child: Column(
          children: [
            Text(label, style: FontManager.labelSmall(color: AppColors.sceGreyA0).copyWith(fontSize: 9.sp)),
            SizedBox(height: 4.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: AppColors.sceTeal, size: 12.sp),
                SizedBox(width: 4.w),
                Text(
                  val.toString(),
                  style: FontManager.labelMedium(color: Colors.white).copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
