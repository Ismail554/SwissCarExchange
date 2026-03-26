import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rionydo/core/constants/font_manager.dart';
import 'package:rionydo/core/utils/app_colors.dart';
import 'package:rionydo/core/utils/app_spacing.dart';
import 'package:rionydo/core/widgets/custom_button.dart';
import 'package:rionydo/views/profile/presentations/payment_method_view.dart';
import 'package:rionydo/views/won_auction/presentations/auction_contact_view.dart';
import 'package:rionydo/views/won_auction/presentations/rate_dealer_view.dart';


class WonAuctionCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String date;
  final String price;
  final bool isPaymentCompleted;

  const WonAuctionCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.date,
    required this.price,
    this.isPaymentCompleted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.h),
      decoration: BoxDecoration(
        color: AppColors.sceCardBg,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Image Header with WON Badge ---
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
                child: imageUrl.startsWith('http')
                    ? Image.network(
                        imageUrl,
                        height: 180.h,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
                        imageUrl,
                        height: 180.h,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
              ),
              Positioned(
                top: 12.h,
                right: 12.w,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.sceOnboardingGold,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.military_tech,
                        color: Colors.white,
                        size: 14.sp,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        'WON',
                        style: FontManager.labelMedium(color: Colors.white)
                            .copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 10.sp,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- Vehicle Title ---
                Text(
                  title,
                  style: FontManager.heading3(color: AppColors.white),
                ),
                AppSpacing.h12,

                // --- Date & Price ---
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      color: AppColors.sceGreyA0,
                      size: 14.sp,
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      date,
                      style: FontManager.bodySmall(color: AppColors.sceGreyA0),
                    ),
                    SizedBox(width: 16.w),
                    Icon(
                      Icons.monetization_on_outlined,
                      color: AppColors.sceGreyA0,
                      size: 14.sp,
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      price,
                      style: FontManager.bodySmall(color: AppColors.sceGreyA0),
                    ),
                  ],
                ),
                AppSpacing.h12,

                // --- Payment Status ---
                if (isPaymentCompleted)
                  Row(
                    children: [
                      Container(
                        width: 8.w,
                        height: 8.w,
                        decoration: const BoxDecoration(
                          color: Colors.greenAccent,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        "Payment Completed",
                        style: FontManager.bodySmall(color: Colors.greenAccent),
                      ),
                    ],
                  ),
                AppSpacing.h16,

                // --- Actions ---
                CustomButton(
                  text: 'View Seller Contact',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AuctionContactView(),
                      ),
                    );
                  },
                  isPrimary: false,
                  icon: Icons.chat_bubble_outline,
                ),
                AppSpacing.h10,
                if (isPaymentCompleted)
                  _RateDealerButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RateDealerView(),
                        ),
                      );
                    },
                  )
                else
                  CustomButton(
                    text: 'Complete Payment',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PaymentMethodView(isPaymentFlow: true),
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RateDealerButton extends StatelessWidget {
  final VoidCallback onPressed;
  const _RateDealerButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 54.h,
      decoration: BoxDecoration(
        color: const Color(
          0xFF1E140C,
        ), // Dark brown / orange tint as per design
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.sceOnboardingGold.withOpacity(0.3)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12.r),
          onTap: onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.star_outline,
                color: AppColors.sceOnboardingGold,
                size: 20.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                'Rate Dealer',
                style: FontManager.bodyMedium(
                  color: AppColors.sceOnboardingGold,
                ).copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
