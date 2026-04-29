import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rionydo/app_utils/constants/font_manager.dart';
import 'package:rionydo/app_utils/utils/app_colors.dart';
import 'package:rionydo/core/widgets/common_background.dart';
import 'package:rionydo/core/widgets/custom_back_button.dart';
import 'package:rionydo/views/bidding/presentations/online_payment.dart';

class PremiumFeature {
  final String title;
  final String subtitle;
  final IconData icon;

  PremiumFeature({
    required this.title,
    required this.subtitle,
    required this.icon,
  });
}

class SubscriptionViews extends StatelessWidget {
  const SubscriptionViews({super.key});

  @override
  Widget build(BuildContext context) {
    final List<PremiumFeature> features = [
      PremiumFeature(
        title: 'Create & Publish Auctions',
        subtitle: 'List cars and motorcycles\nfor auction',
        icon: Icons.inventory_2_outlined,
      ),
      PremiumFeature(
        title: 'Upload Multiple Assets',
        subtitle: 'Images, videos, VIN,\ninspection reports',
        icon: Icons.bolt,
      ),
      PremiumFeature(
        title: 'Set Pricing Options',
        subtitle: 'Reserve price, Buy Now,\nauction duration',
        icon: Icons.trending_up,
      ),
      PremiumFeature(
        title: 'Auction Management',
        subtitle: 'View bidders, track\nperformance, history',
        icon: Icons.shield_outlined,
      ),
      PremiumFeature(
        title: 'Advanced Statistics',
        subtitle: 'Win rate, sell-through rate,\navg sale price',
        icon: Icons.show_chart,
      ),
      PremiumFeature(
        title: 'Priority Listing & Notifications',
        subtitle: 'Featured placement &\npush notifications',
        icon: Icons.notifications_none_outlined,
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.sceDarkBg, // Color(0xFF0A0A0A)
      body: CommonBackground(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 4,
          leading: const CustomBackButton(),
          title: Text(
            'Subscription',
            style: FontManager.titleText(color: AppColors.white),
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Crown Icon with Glow
              Container(
                width: 90.w,
                height: 90.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.scePremiumGold, // Light Orange/Gold
                      AppColors.scePremiumOrange, // Darker Orange
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.scePremiumGlow.withOpacity(0.3),
                      blurRadius: 40,
                      spreadRadius: 10,
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    Icons.workspace_premium_outlined,
                    color: Colors.white,
                    size: 48.w,
                  ),
                ),
              ),
              SizedBox(height: 24.h),

              // Header Texts
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: 'Upgrade to ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28.sp,
                    fontWeight: FontWeight.w800,
                  ),
                  children: const [
                    TextSpan(
                      text: 'Premium',
                      style: TextStyle(
                        color: AppColors.scePremiumGold, // Gold
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Unlock dealer features & start selling',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.sceGrey99,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 32.h),

              // Pricing Card
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 24.h),
                decoration: BoxDecoration(
                  color: AppColors.sceDarkBg,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: AppColors.scePremiumDealerBg, // Dark Gold
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.scePremiumDealerBg.withOpacity(0.5),
                      blurRadius: 20,
                      spreadRadius: -5,
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      'DEALER SUBSCRIPTION',
                      style:
                          FontManager.labelSmall(
                            color: AppColors.scePremiumGold,
                          ).copyWith(
                            letterSpacing: 1.2,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          '299',
                          style: FontManager.heading2(
                            color: AppColors.scePremiumGold,
                          ).copyWith(fontSize: 48.sp),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          'CHF',
                          style: FontManager.heading2(
                            color: AppColors.sceGrey99,
                          ).copyWith(fontSize: 20.sp),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'per month',
                      style: TextStyle(
                        color: AppColors.sceGrey99,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 32.h),

              // Features List Title
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'PREMIUM FEATURES',
                  style: FontManager.labelSmall(
                    color: AppColors.greyD4,
                  ).copyWith(letterSpacing: 1.0, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 16.h),

              // Features List
              ...features.map(
                (feature) => Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 16.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.sceCardBg.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: Colors.white.withOpacity(0.05)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 44.w,
                          height: 44.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.scePremiumGold.withOpacity(0.15),
                          ),
                          child: Center(
                            child: Icon(
                              feature.icon,
                              color: AppColors.scePremiumGold,
                              size: 24.w,
                            ),
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                feature.title,
                                style: FontManager.labelMedium(
                                  color: Colors.white,
                                ).copyWith(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                feature.subtitle,
                                style: FontManager.labelSmall(
                                  color: const Color(0xFF99A1AF),
                                ).copyWith(height: 1.4),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.check,
                          color: AppColors.sceTeal, // sceTeal
                          size: 24.w,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(height: 32.h),

              // Upgrade Button
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OnlinePaymentView(
                        carName: "Premium Plan",
                        amount: "299 CHF",
                      ),
                    ),
                  );
                },
                child: Container(
                  width: double.maxFinite,
                  height: 56.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    gradient: const LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        AppColors.scePremiumGold, // Gold
                        AppColors.scePremiumOrange, // Orange
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.scePremiumOrange.withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      'Upgrade to Premium',
                      style: FontManager.labelMedium(
                        color: Colors.white,
                      ).copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.h),

              // Footer Text
              Text(
                'Cancel anytime. Terms and conditions apply.',
                textAlign: TextAlign.center,
                style: FontManager.labelSmall(
                  color: AppColors.grey,
                ).copyWith(fontWeight: FontWeight.w400),
              ),
              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }
}
