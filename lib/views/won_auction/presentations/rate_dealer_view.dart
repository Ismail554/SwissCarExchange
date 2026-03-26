import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rionydo/core/constants/font_manager.dart';
import 'package:rionydo/core/utils/app_colors.dart';
import 'package:rionydo/core/utils/app_spacing.dart';
import 'package:rionydo/core/widgets/common_background.dart';
import 'package:rionydo/core/widgets/custom_back_button.dart';
import 'package:rionydo/core/widgets/custom_button.dart';
import 'package:rionydo/core/widgets/widget_snackbar.dart';
import 'package:rionydo/views/won_auction/presentations/review_submitted_view.dart';

class RateDealerView extends StatefulWidget {
  const RateDealerView({super.key});

  @override
  State<RateDealerView> createState() => _RateDealerViewState();
}

class _RateDealerViewState extends State<RateDealerView> {
  int _overallRating = 0;
  int _communicationRating = 0;
  int _accuracyRating = 0;
  int _reliabilityRating = 0;
  final _reviewCtrl = TextEditingController();

  @override
  void dispose() {
    _reviewCtrl.dispose();
    super.dispose();
  }

  void _submitReview() {
    if (_overallRating == 0 ||
        _communicationRating == 0 ||
        _accuracyRating == 0 ||
        _reliabilityRating == 0) {
      AppSnackBar.warning(
        context,
        "Please rate all aspects before submitting.",
      );
      return;
    }

    // Logic to submit the review
    AppSnackBar.success(context, "Review submitted successfully!");
    // Navigator.pop(context); // Go back to Home or previous screen
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ReviewSubmittedView()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CommonBackground(
      appBar: AppBar(
        leading: const CustomBackButton(),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Rate Dealer',
              style: FontManager.titleText(color: AppColors.white),
            ),
            Text(
              'Dealer',
              style: FontManager.bodySmall(color: AppColors.sceGreyA0),
            ),
          ],
        ),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Overall Experience ---
            _OverallRatingCard(
              rating: _overallRating,
              onRatingChanged: (val) => setState(() => _overallRating = val),
            ),
            AppSpacing.h24,

            // --- Specific Aspects ---
            Text(
              'RATE SPECIFIC ASPECTS',
              style: FontManager.labelMedium(color: AppColors.sceGreyA0),
            ),
            AppSpacing.h12,
            _AspectRatingCard(
              title: 'Communication',
              rating: _communicationRating,
              onRatingChanged: (val) =>
                  setState(() => _communicationRating = val),
            ),
            AppSpacing.h12,
            _AspectRatingCard(
              title: 'Vehicle Accuracy',
              rating: _accuracyRating,
              onRatingChanged: (val) => setState(() => _accuracyRating = val),
            ),
            AppSpacing.h12,
            _AspectRatingCard(
              title: 'Transaction Reliability',
              rating: _reliabilityRating,
              onRatingChanged: (val) =>
                  setState(() => _reliabilityRating = val),
            ),
            AppSpacing.h24,

            // --- Written Review ---
            Text(
              'WRITTEN REVIEW (OPTIONAL)',
              style: FontManager.labelMedium(color: AppColors.sceGreyA0),
            ),
            AppSpacing.h12,
            _ReviewTextField(controller: _reviewCtrl),
            AppSpacing.h32,

            // --- Submit Button ---
            CustomButton(text: 'Submit Review', onPressed: _submitReview),
            AppSpacing.h10,
            Center(
              child: Text(
                'Please rate all aspects to submit your review',
                style: FontManager.bodySmall(color: AppColors.sceGreyA0),
              ),
            ),
            AppSpacing.h40,
          ],
        ),
      ),
    );
  }
}

class _OverallRatingCard extends StatelessWidget {
  final int rating;
  final Function(int) onRatingChanged;

  const _OverallRatingCard({
    required this.rating,
    required this.onRatingChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: const Color(0xFF1E140C), // Dark brown/orange tint
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.sceOnboardingGold.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'OVERALL EXPERIENCE',
            style: FontManager.labelMedium(
              color: AppColors.sceOnboardingGold,
            ).copyWith(fontWeight: FontWeight.bold),
          ),
          AppSpacing.h16,
          _StarRatingBar(
            rating: rating,
            onRatingChanged: onRatingChanged,
            size: 36.sp,
          ),
        ],
      ),
    );
  }
}

class _AspectRatingCard extends StatelessWidget {
  final String title;
  final int rating;
  final Function(int) onRatingChanged;

  const _AspectRatingCard({
    required this.title,
    required this.rating,
    required this.onRatingChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.sceCardBg,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: FontManager.bodyMedium(
              color: AppColors.white,
            ).copyWith(fontWeight: FontWeight.bold),
          ),
          AppSpacing.h12,
          _StarRatingBar(rating: rating, onRatingChanged: onRatingChanged),
        ],
      ),
    );
  }
}

class _StarRatingBar extends StatelessWidget {
  final int rating;
  final Function(int) onRatingChanged;
  final double? size;

  const _StarRatingBar({
    required this.rating,
    required this.onRatingChanged,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(5, (index) {
        final starValue = index + 1;
        return Padding(
          padding: EdgeInsets.only(right: 8.w),
          child: GestureDetector(
            onTap: () => onRatingChanged(starValue),
            child: Icon(
              starValue <= rating ? Icons.star : Icons.star_outline,
              color: starValue <= rating
                  ? AppColors.sceOnboardingGold
                  : AppColors.sceGreyA0.withOpacity(0.5),
              size: size ?? 28.sp,
            ),
          ),
        );
      }),
    );
  }
}

class _ReviewTextField extends StatelessWidget {
  final TextEditingController controller;
  const _ReviewTextField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: 6,
      style: FontManager.bodyMedium(color: AppColors.white),
      decoration: InputDecoration(
        hintText: 'Share your experience with this dealer...',
        hintStyle: FontManager.bodyMedium(
          color: AppColors.sceGreyA0.withOpacity(0.5),
        ),
        filled: true,
        fillColor: AppColors.sceCardBg,
        contentPadding: EdgeInsets.all(20.w),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide(color: AppColors.white.withOpacity(0.1)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide(color: AppColors.white.withOpacity(0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: const BorderSide(color: AppColors.sceTeal, width: 1.5),
        ),
      ),
    );
  }
}
