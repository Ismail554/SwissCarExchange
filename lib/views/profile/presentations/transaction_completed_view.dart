import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:rionydo/core/constants/font_manager.dart';
import 'package:rionydo/core/utils/app_colors.dart';
import 'package:rionydo/core/utils/app_spacing.dart';
import 'package:rionydo/core/utils/assets_manager.dart';
import 'package:rionydo/core/widgets/common_background.dart';
import 'package:rionydo/core/widgets/custom_button.dart';
import 'package:rionydo/views/won_auction/presentations/rate_dealer_view.dart';

class TransactionCompletedView extends StatelessWidget {
  const TransactionCompletedView({super.key});

  @override
  Widget build(BuildContext context) {
    return CommonBackground(
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 8.w),
          child: Column(
            mainAxisAlignment: .center,
            children: [
              Lottie.asset(JsonAssets.successmark, height: 150, repeat: false),
              Text(
                "Transaction Completed!",
                style: FontManager.heading1(color: AppColors.white),
              ),
              AppSpacing.h8,
              Text(
                "Please rate your experience with this dealer.",
                style: FontManager.bodyMedium(color: AppColors.grey),
                textAlign: TextAlign.center,
              ),
              AppSpacing.h18,
              CustomButton(
                text: "Rate Now",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RateDealerView(),
                    ),
                  );
                },
              ),
              AppSpacing.h18,
              CustomButton(
                text: "Skip",
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
