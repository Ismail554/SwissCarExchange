import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rionydo/core/constants/font_manager.dart';
import 'package:rionydo/core/utils/app_colors.dart';
import 'package:rionydo/views/premium/widgets/sce_star_rating.dart';

class DealerReviewCard extends StatelessWidget {
  final String author;
  final String date;
  final double rating;
  final String review;
  final double communication;
  final double accuracy;
  final double reliability;

  const DealerReviewCard({
    super.key,
    required this.author,
    required this.date,
    required this.rating,
    required this.review,
    required this.communication,
    required this.accuracy,
    required this.reliability,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: AppColors.sceCardBg,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 20.r,
                    backgroundColor: AppColors.sceTeal.withOpacity(0.1),
                    child: Icon(Icons.person_outline_rounded, color: AppColors.sceTeal, size: 20.sp),
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    author,
                    style: FontManager.bodyMedium(color: Colors.white).copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Text(date, style: FontManager.hintText().copyWith(fontSize: 12.sp)),
            ],
          ),
          SizedBox(height: 12.h),
          SceStarRating(rating: rating, size: 18),
          SizedBox(height: 16.h),
          Text(
            review,
            style: FontManager.bodySmall(color: AppColors.sceGreyA0).copyWith(
              height: 1.5,
            ),
          ),
          SizedBox(height: 20.h),
          _buildDetailRow("Communication:", communication),
          SizedBox(height: 8.h),
          _buildDetailRow("Accuracy:", accuracy),
          SizedBox(height: 8.h),
          _buildDetailRow("Reliability:", reliability),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, double rating) {
    return Row(
      children: [
        SizedBox(
          width: 100.w,
          child: Text(
            label,
            style: FontManager.labelSmall(color: AppColors.sceGreyA0),
          ),
        ),
        SceStarRating(rating: rating, size: 12),
      ],
    );
  }
}
