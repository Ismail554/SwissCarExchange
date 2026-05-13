import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rionydo/app_utils/constants/font_manager.dart';
import 'package:rionydo/app_utils/utils/app_colors.dart';
import 'package:rionydo/app_utils/utils/app_spacing.dart';
import 'package:rionydo/core/widgets/custom_button.dart';
import 'package:rionydo/views/payment/presentations/payment_process_view.dart';
import 'package:rionydo/views/won_auction/presentations/auction_contact_view.dart';
import 'package:rionydo/views/won_auction/presentations/rate_dealer_view.dart';

class WonAuctionCard extends StatelessWidget {
  final String auctionId;
  final String imageUrl;
  final String title;
  final String date;
  final String price;
  final String transactionStatus;
  final bool hasReviewed;

  const WonAuctionCard({
    super.key,
    required this.auctionId,
    required this.imageUrl,
    required this.title,
    required this.date,
    required this.price,
    this.transactionStatus = '',
    this.hasReviewed = false,
  });

  static const _hiddenStatuses = {
    'completed',
    'payment_expired',
    'shipping_expired',
  };

  String _buttonText() {
    switch (transactionStatus) {
      case 'payment_done':
        return 'Choose Shipping';
      case 'shipping_pending':
        return 'Mark Received';
      default:
        return 'Complete Payment';
    }
  }

  int _targetStep() {
    switch (transactionStatus) {
      case 'payment_done':
        return 1;
      case 'shipping_pending':
        return 2;
      default:
        return 0;
    }
  }

  Color _statusColor() {
    switch (transactionStatus) {
      case 'completed':
        return Colors.greenAccent;
      case 'payment_expired':
      case 'shipping_expired':
        return Colors.redAccent;
      case 'payment_pending':
        return Colors.orangeAccent;
      case 'payment_done':
        return Colors.blueAccent;
      case 'shipping_pending':
        return Colors.purpleAccent;
      default:
        return AppColors.sceGreyA0;
    }
  }

  String _statusLabel() {
    switch (transactionStatus) {
      case 'payment_pending':
        return 'Payment Pending';
      case 'payment_done':
        return 'Payment Done';
      case 'shipping_pending':
        return 'Shipping Pending';
      case 'completed':
        return 'Completed';
      case 'payment_expired':
        return 'Payment Expired';
      case 'shipping_expired':
        return 'Shipping Expired';
      default:
        return transactionStatus;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.h),
      decoration: BoxDecoration(
        color: AppColors.sceCardBg,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Image Header with WON Badge ---
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
                child: imageUrl.isEmpty
                    ? Container(
                        height: 180.h,
                        width: double.infinity,
                        color: Colors.white10,
                        child: const Icon(
                          Icons.image_not_supported_outlined,
                          color: Colors.white24,
                        ),
                      )
                    : imageUrl.startsWith('http')
                    ? Image.network(
                        imageUrl,
                        height: 180.h,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => Container(
                          height: 180.h,
                          width: double.infinity,
                          color: Colors.white10,
                          child: const Icon(
                            Icons.image_not_supported_outlined,
                            color: Colors.white24,
                          ),
                        ),
                      )
                    : Image.asset(
                        imageUrl,
                        height: 180.h,
                        width: double.maxFinite,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => Container(
                          height: 180.h,
                          width: double.maxFinite,
                          color: Colors.white10,
                          child: const Icon(
                            Icons.image_not_supported_outlined,
                            color: Colors.white24,
                          ),
                        ),
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

                // --- Transaction Status Badge ---
                if (transactionStatus.isNotEmpty)
                  Row(
                    children: [
                      Container(
                        width: 8.w,
                        height: 8.w,
                        decoration: BoxDecoration(
                          color: _statusColor(),
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        _statusLabel(),
                        style: FontManager.bodySmall(color: _statusColor()),
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
                        builder: (context) =>
                            AuctionContactView(auctionId: auctionId),
                      ),
                    );
                  },
                  isPrimary: false,
                  icon: Icons.chat_bubble_outline,
                ),
                AppSpacing.h10,
                if (transactionStatus == 'completed' && !hasReviewed)
                  _RateDealerButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              RateDealerView(auctionId: auctionId),
                        ),
                      );
                    },
                  )
                else if (!_hiddenStatuses.contains(transactionStatus))
                  CustomButton(
                    text: _buttonText(),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PaymentProcessView(
                            auctionId: auctionId,
                            initialStep: _targetStep(),
                          ),
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
        border: Border.all(
          color: AppColors.sceOnboardingGold.withValues(alpha: 0.3),
        ),
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
