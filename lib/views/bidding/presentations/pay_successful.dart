import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:rionydo/app_utils/constants/font_manager.dart';
import 'package:rionydo/app_utils/utils/app_colors.dart';
import 'package:rionydo/app_utils/utils/app_spacing.dart';
import 'package:rionydo/app_utils/utils/assets_manager.dart';
import 'package:rionydo/core/widgets/common_background.dart';

class PaySuccessful extends StatefulWidget {
  final String? nextRoute;
  const PaySuccessful({super.key, this.nextRoute});

  @override
  State<PaySuccessful> createState() => _PaySuccessfulState();
}

class _PaySuccessfulState extends State<PaySuccessful> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        if (widget.nextRoute != null) {
          context.go(widget.nextRoute!);
        } else {
          context.go('/home');
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CommonBackground(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Success animation
              Lottie.asset(JsonAssets.successmark, height: 150, repeat: false),

              // Success message
              Text(
                "Payment Successful!",
                style: FontManager.heading1(color: AppColors.white),
              ),
              AppSpacing.h8,
              Text(
                "Your payment has been processed successfully.",
                style: FontManager.bodyMedium(color: AppColors.grey),
                textAlign: TextAlign.center,
              ),

              // auto back to home after 2 seconds
            ],
          ),
        ),
      ),
    );
  }
}
