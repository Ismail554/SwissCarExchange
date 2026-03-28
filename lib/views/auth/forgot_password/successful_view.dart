import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:rionydo/core/utils/app_spacing.dart';
import 'package:rionydo/core/utils/assets_manager.dart';
import 'package:rionydo/core/widgets/common_background.dart';
import 'package:rionydo/core/widgets/custom_button.dart';
import 'package:rionydo/views/auth/login/login_views.dart';
import 'package:rionydo/views/auth/sign_up/verify_sign_up/presentations/before_subs_view.dart';
import 'package:rionydo/views/auth/sign_up/verify_sign_up/presentations/pending_view.dart';

class SuccessfulView extends StatelessWidget {
  const SuccessfulView({super.key});

  @override
  Widget build(BuildContext context) {
    return CommonBackground(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(JsonAssets.successmark, height: 150, repeat: false),
              AppSpacing.h24,
              Text(
                "Congratulations!",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30.sp,
                  fontWeight: FontWeight.w700,
                ),
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
                      MaterialPageRoute(builder: (context) => PendingView()),
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
