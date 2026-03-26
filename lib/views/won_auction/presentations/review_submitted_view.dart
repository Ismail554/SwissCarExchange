import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:rionydo/core/constants/font_manager.dart';
import 'package:rionydo/core/utils/app_colors.dart';
import 'package:rionydo/core/utils/app_spacing.dart';
import 'package:rionydo/core/utils/assets_manager.dart';
import 'package:rionydo/core/widgets/common_background.dart';

class ReviewSubmittedView extends StatefulWidget {
  const ReviewSubmittedView({super.key});

  @override
  State<ReviewSubmittedView> createState() => _ReviewSubmittedViewState();
}

class _ReviewSubmittedViewState extends State<ReviewSubmittedView> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        int count = 0;
        Navigator.popUntil(context, (route) => count++ == 2);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CommonBackground(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(JsonAssets.successmark, height: 150, repeat: true),
              AppSpacing.h14,
              Column(
                spacing: 4.h,
                children: [
                  Text(
                    "Review Submitted!",
                    style: FontManager.titleText(
                      color: AppColors.white,
                      fontSize: 26.sp,
                    ),
                  ),
                  Text(
                    "Thank you for your feedback",
                    style: FontManager.bodyMedium(
                      color: AppColors.grey,
                      fontSize: 20.sp,
                    ),
                  ),
                ],
              ),
              AppSpacing.h12,
            ],
          ),
        ),
      ),
    );
  }
}
