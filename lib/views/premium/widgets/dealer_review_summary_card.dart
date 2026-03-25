import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rionydo/core/constants/font_manager.dart';
import 'package:rionydo/core/utils/app_colors.dart';
import 'package:rionydo/views/premium/widgets/sce_star_rating.dart';

class DealerReviewSummaryCard extends StatelessWidget {
  final double overallRating;
  final double communication;
  final double accuracy;
  final double reliability;

  const DealerReviewSummaryCard({
    super.key,
    required this.overallRating,
    required this.communication,
    required this.accuracy,
    required this.reliability,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24.r),
      decoration: BoxDecoration(
        color: AppColors.sceGoldStatBg.withOpacity(0.8),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: AppColors.sceGold.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(12.r),
                decoration: const BoxDecoration(
                  color: AppColors.sceGold,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.star_rounded, color: Colors.white, size: 32.sp),
              ),
              SizedBox(width: 16.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: overallRating.toString(),
                          style: FontManager.heading2(color: AppColors.sceGold).copyWith(
                            fontSize: 36.sp,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        TextSpan(
                          text: " / 5",
                          style: FontManager.hintText().copyWith(fontSize: 18.sp),
                        ),
                      ],
                    ),
                  ),
                  Text("Overall Rating", style: FontManager.hintText()),
                ],
              ),
            ],
          ),
          SizedBox(height: 24.h),
          Divider(color: AppColors.sceGold.withOpacity(0.1)),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildRatingColumn("Communication", communication),
              _buildRatingColumn("Accuracy", accuracy),
              _buildRatingColumn("Reliability", reliability),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRatingColumn(String label, double rating) {
    return Column(
      children: [
        Text(
          label,
          style: FontManager.labelSmall(color: AppColors.sceGreyA0),
        ),
        SizedBox(height: 8.h),
        SceStarRating(rating: rating, size: 14),
      ],
    );
  }
}
