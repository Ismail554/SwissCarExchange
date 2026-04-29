import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rionydo/app_utils/utils/app_spacing.dart';
import 'package:rionydo/app_utils/utils/assets_manager.dart';
import 'package:rionydo/core/widgets/common_background.dart';
import 'package:rionydo/core/widgets/custom_button.dart';
import 'package:rionydo/views/won_auction/presentations/rate_dealer_view.dart';

class TransactionCompleteView extends StatelessWidget {
  const TransactionCompleteView({super.key});

  @override
  Widget build(BuildContext context) {
    return CommonBackground(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(SvgAssets.successmark),
              AppSpacing.h24,
              Text(
                "Transaction Complete!",
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              AppSpacing.h12,
              // Text(
              //   "Your password has been reset successfully. You can now login with your new password.",
              //   textAlign: TextAlign.center,
              //   style: TextStyle(
              //     color: const Color(0xFFA0AABF),
              //     fontSize: 15.sp,
              //     height: 1.5,
              //     fontWeight: FontWeight.w400,
              //   ),
              // ),
              AppSpacing.h24,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: CustomButton(
                  text: 'Continue',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>RateDealerView()),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}