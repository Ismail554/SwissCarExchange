import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rionydo/core/constants/font_manager.dart';
import 'package:rionydo/core/utils/app_colors.dart';
import 'package:rionydo/core/widgets/common_background.dart';
import 'package:rionydo/core/widgets/custom_back_button.dart';
import 'package:rionydo/views/premium/widgets/dealer_review_card.dart';
import 'package:rionydo/views/premium/widgets/dealer_review_summary_card.dart';

class DealerReviewsView extends StatelessWidget {
  const DealerReviewsView({super.key});

  @override
  Widget build(BuildContext context) {
    return CommonBackground(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const CustomBackButton(),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "Dealer Reviews",
                  style: FontManager.titleText(
                    color: Colors.white,
                  ).copyWith(fontSize: 18.sp),
                ),
                SizedBox(width: 4.w),
                Icon(
                  Icons.workspace_premium_rounded,
                  color: AppColors.sceGold,
                  size: 18.sp,
                ),
              ],
            ),
            Text("Manage your reviews", style: FontManager.hintText()),
          ],
        ),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.h),
            
            // ── OVERALL RATING ──
            const DealerReviewSummaryCard(
              overallRating: 4.7,
              communication: 4.8,
              accuracy: 4.5,
              reliability: 4.9,
            ),

            SizedBox(height: 32.h),

            // ── ALL REVIEWS SECTION ──
            Text(
              "ALL REVIEWS",
              style: FontManager.labelSmall(color: AppColors.sceGreyA0).copyWith(
                letterSpacing: 1.2,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.h),

            // ── REVIEW LIST ──
            _buildReviewList(),
            
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewList() {
    final reviews = [
      {
        "author": "AutoSelect Swiss",
        "date": "Oct 20, 2023",
        "rating": 5.0,
        "review": "Excellent dealer, very professional and the car was exactly as described. Highly recommend!",
        "comm": 5.0,
        "acc": 5.0,
        "rel": 5.0,
      },
      {
        "author": "Marcus Weber",
        "date": "Oct 15, 2023",
        "rating": 4.0,
        "review": "Good experience overall. The communication was prompt, though the car preparation took slightly longer than expected.",
        "comm": 4.0,
        "acc": 4.5,
        "rel": 4.0,
      },
      {
        "author": "Zurich Luxury Motors",
        "date": "Oct 02, 2023",
        "rating": 5.0,
        "review": "Seamless transaction. The reliability of this dealer is top-notch. Will definitely work together again.",
        "comm": 5.0,
        "acc": 5.0,
        "rel": 5.0,
      },
    ];

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: reviews.length,
      separatorBuilder: (context, index) => SizedBox(height: 16.h),
      itemBuilder: (context, index) {
        final r = reviews[index];
        return DealerReviewCard(
          author: r["author"] as String,
          date: r["date"] as String,
          rating: r["rating"] as double,
          review: r["review"] as String,
          communication: r["comm"] as double,
          accuracy: r["acc"] as double,
          reliability: r["rel"] as double,
        );
      },
    );
  }
}
