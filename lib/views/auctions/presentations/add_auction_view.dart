import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rionydo/core/widgets/common_background.dart';
import 'package:rionydo/app_utils/utils/app_colors.dart';
import 'package:rionydo/core/widgets/custom_back_button.dart';

class AddAuctionView extends StatelessWidget {
  const AddAuctionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.sceDarkBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Post New Auction',
          style: TextStyle(color: Colors.white),
        ),
        leading: Padding(
          padding: EdgeInsets.only(left: 16.w),
          child: Align(
            alignment: Alignment.centerLeft,
            child: const CustomBackButton(),
          ),
        ),
        leadingWidth: 64.w,
      ),
      body: CommonBackground(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add_circle_outline_rounded,
                color: AppColors.sceTeal,
                size: 80.sp,
              ),
              SizedBox(height: 24.h),
              Text(
                'Premium Feature',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 12.h),
              const Text(
                'Start listing your vehicles for auction. Fill in the details to reach thousands of buyers.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
