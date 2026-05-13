import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rionydo/app_utils/constants/font_manager.dart';
import 'package:rionydo/app_utils/utils/app_colors.dart';

class AuctionCard extends StatelessWidget {
  final String title;
  final String vehicleBrand;
  final String? currentHighestBid;
  final String reservePrice;
  final String status;
  final DateTime? endsAt;
  final String? imageUrl;
  final VoidCallback? onTap;
  final Widget? topRightOverlay;

  const AuctionCard({
    super.key,
    required this.title,
    required this.vehicleBrand,
    this.currentHighestBid,
    required this.reservePrice,
    required this.status,
    this.endsAt,
    this.imageUrl,
    this.onTap,
    this.topRightOverlay,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.sceCardBg,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
        ),
        clipBehavior: Clip.hardEdge,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Image Section ──────────────────────────────────────────
            Expanded(
              flex: 4,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Image / placeholder
                  imageUrl != null && imageUrl!.isNotEmpty
                      ? Image.network(
                          imageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => _buildImagePlaceholder(),
                          loadingBuilder: (_, child, progress) => progress == null
                              ? child
                              : _buildImagePlaceholder(loading: true),
                        )
                      : _buildImagePlaceholder(),

                  // Subtle gradient overlay
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.25),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Status badge
                  if (status == "active")
                    Positioned(
                      top: 8.h,
                      left: 8.w,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.withValues(alpha: 0.85),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 6.w,
                              height: 6.h,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              "Live",
                              style: FontManager.bodySmall(color: Colors.white)
                                  .copyWith(
                                fontWeight: FontWeight.w600,
                                fontSize: 10.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  // Optional Overlay (e.g. Heart button for wishlist)
                  if (topRightOverlay != null)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: topRightOverlay!,
                    ),
                ],
              ),
            ),

            // ── Details Section ────────────────────────────────────────
            Expanded(
              flex: 4,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // ── Title + Brand ──────────────────────────────────
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: FontManager.bodyMedium(
                            color: Colors.white,
                          ).copyWith(fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          vehicleBrand,
                          style: FontManager.bodySmall(
                            color: AppColors.textHint,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),

                    // ── Bid + Time ─────────────────────────────────────
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Divider(
                          color: Colors.white.withValues(alpha: 0.07),
                          height: 1,
                          thickness: 1,
                        ),
                        SizedBox(height: 8.h),

                        Text(
                          "Current Bid",
                          style: FontManager.bodySmall(
                            color: AppColors.textHint,
                          ).copyWith(fontSize: 10.sp),
                        ),
                        SizedBox(height: 2.h),

                        Text(
                          "CHF ${currentHighestBid ?? reservePrice}",
                          style: FontManager.bodyMedium(
                            color: AppColors.sceTeal,
                          ).copyWith(fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),

                        SizedBox(height: 6.h),

                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 6.w,
                              vertical: 3.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.07),
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.access_time_rounded,
                                  size: 10.sp,
                                  color: AppColors.textHint,
                                ),
                                SizedBox(width: 3.w),
                                Text(
                                  _getTimeRemaining(endsAt),
                                  style: FontManager.bodySmall(
                                    color: AppColors.textHint,
                                  ).copyWith(fontSize: 10.sp),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePlaceholder({bool loading = false}) {
    return Container(
      color: Colors.white.withValues(alpha: 0.07),
      child: Center(
        child: loading
            ? SizedBox(
                width: 20.w,
                height: 20.h,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.sceTeal.withValues(alpha: 0.6),
                ),
              )
            : Icon(
                Icons.directions_car_outlined,
                color: AppColors.textHint.withValues(alpha: 0.4),
                size: 32.sp,
              ),
      ),
    );
  }

  String _getTimeRemaining(DateTime? endsAt) {
    if (endsAt == null) {
      return "Ended";
    }
    final now = DateTime.now();
    final difference = endsAt.difference(now);

    if (difference.isNegative) {
      return "Ended";
    }

    if (difference.inDays > 0) {
      return "${difference.inDays}d ${difference.inHours % 24}h remaining";
    } else if (difference.inHours > 0) {
      return "${difference.inHours}h ${difference.inMinutes % 60}m remaining";
    } else {
      return "${difference.inMinutes}m remaining";
    }
  }
}
