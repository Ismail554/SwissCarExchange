import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:rionydo/app_utils/constants/font_manager.dart';
import 'package:rionydo/app_utils/utils/app_colors.dart';
import 'package:rionydo/app_utils/utils/app_spacing.dart';
import 'package:rionydo/controllers/dealer_reviews_provider.dart';
import 'package:rionydo/core/widgets/common_background.dart';
import 'package:rionydo/core/widgets/custom_back_button.dart';
import 'package:rionydo/models/profile/all_review_response.dart';
import 'package:rionydo/views/premium/widgets/dealer_review_card.dart';
import 'package:rionydo/views/premium/widgets/dealer_review_summary_card.dart';

class DealerReviewsView extends StatefulWidget {
  const DealerReviewsView({super.key});

  @override
  State<DealerReviewsView> createState() => _DealerReviewsViewState();
}

class _DealerReviewsViewState extends State<DealerReviewsView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DealerReviewsProvider>(context, listen: false).fetchReviews();
    });
  }

  String _formatDate(DateTime? dateTime) {
    if (dateTime == null) return '';
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final month = months[dateTime.month - 1];
    return "$month ${dateTime.day}, ${dateTime.year}";
  }

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
      child: Consumer<DealerReviewsProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.reviewResponse == null) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.sceTeal),
            );
          }

          if (provider.errorMessage != null && provider.reviewResponse == null) {
            return Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, color: AppColors.errorRed, size: 48.sp),
                    AppSpacing.h12,
                    Text(
                      provider.errorMessage!,
                      style: FontManager.bodyMedium(color: AppColors.sceGrey99),
                      textAlign: TextAlign.center,
                    ),
                    AppSpacing.h12,
                    TextButton(
                      onPressed: () => provider.fetchReviews(),
                      child: Text(
                        "Retry",
                        style: FontManager.bodyMedium(color: AppColors.sceTeal),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          final results = provider.reviewResponse?.results ?? [];

          return RefreshIndicator(
            color: AppColors.sceTeal,
            onRefresh: () => provider.fetchReviews(),
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              children: [
                if (results.isEmpty) ...[
                  SizedBox(height: MediaQuery.of(context).size.height * 0.2),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.rate_review_outlined,
                          color: AppColors.sceGrey99,
                          size: 64.sp,
                        ),
                        AppSpacing.h16,
                        Text(
                          "No reviews yet",
                          style: FontManager.bodyMedium(color: AppColors.sceGrey99).copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.sp,
                          ),
                        ),
                        AppSpacing.h4,
                        Text(
                          "When buyers leave feedback, it will appear here.",
                          style: FontManager.bodySmall(color: AppColors.sceGreyA0),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ] else ...[
                  // ── OVERALL RATING ──
                  DealerReviewSummaryCard(
                    overallRating: provider.averageOverall,
                    communication: provider.averageCommunication,
                    accuracy: provider.averageAccuracy,
                    reliability: provider.averageReliability,
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
                  _buildReviewList(results),

                  SizedBox(height: 40.h),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildReviewList(List<Review> results) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: results.length,
      separatorBuilder: (context, index) => SizedBox(height: 16.h),
      itemBuilder: (context, index) {
        final r = results[index];
        final authorName = r.reviewer.fullName.isNotEmpty
            ? r.reviewer.fullName
            : (r.reviewer.company.isNotEmpty ? r.reviewer.company : "Anonymous User");

        return DealerReviewCard(
          author: authorName,
          date: _formatDate(r.createdAt),
          rating: r.overallRating,
          review: r.reviewText,
          communication: r.communicationRating,
          accuracy: r.vehicleAccuracyRating,
          reliability: r.transactionReliabilityRating,
        );
      },
    );
  }
}
