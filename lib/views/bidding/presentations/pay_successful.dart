import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:rionydo/core/constants/font_manager.dart';
import 'package:rionydo/core/utils/app_colors.dart';
import 'package:rionydo/core/utils/app_spacing.dart';
import 'package:rionydo/core/utils/assets_manager.dart';
import 'package:rionydo/core/widgets/common_background.dart';
import 'package:rionydo/views/home/presentation/home_view.dart';
import 'package:rionydo/views/auctions/presentations/auctions_view.dart';
import 'package:rionydo/views/bidding/presentations/bids_view.dart';
import 'package:rionydo/views/profile/presentations/profile_view.dart';
import 'package:rionydo/views/main_navigation/bottom_nav.dart';

class PaySuccessful extends StatefulWidget {
  const PaySuccessful({super.key});

  @override
  State<PaySuccessful> createState() => _PaySuccessfulState();
}

class _PaySuccessfulState extends State<PaySuccessful> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        int count = 0;
        Navigator.popUntil(context, (route) => count++ == 3);
        // Navigator.of(context).pushAndRemoveUntil(
        //   MaterialPageRoute(
        //     builder: (context) => const
        //     MainNavigationShell(
        //       initialIndex: 2,
        //       pages: [HomeView(), AuctionsView(), BidsView(), ProfileView()],
        //     ),
        //   ),
        //   (route) => false,
        // );
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
