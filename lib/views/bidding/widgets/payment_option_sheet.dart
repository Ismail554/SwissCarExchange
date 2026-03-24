import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rionydo/core/constants/font_manager.dart';
import 'package:rionydo/core/utils/app_colors.dart';
import 'package:rionydo/views/bidding/presentations/offline_payment.dart';
import 'package:rionydo/views/bidding/presentations/online_payment.dart';

/// Shows a modal bottom sheet with two payment options:
///  - In-App Payment (card/wallet)
///  - Bank Transfer / Offline
void showPaymentOptionSheet(
  BuildContext context, {
  required String carName,
  required String amount,
}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (_) => _PaymentOptionSheet(carName: carName, amount: amount),
  );
}

class _PaymentOptionSheet extends StatelessWidget {
  final String carName;
  final String amount;

  const _PaymentOptionSheet({required this.carName, required this.amount});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF111827),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(24.w, 12.h, 24.w, 32.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: AppColors.grey.withOpacity(0.4),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          SizedBox(height: 20.h),

          // Title
          Text(
            'Payment Options',
            style: FontManager.heading2(color: AppColors.white),
          ),
          SizedBox(height: 6.h),

          // Subtitle
          Text(
            'Choose how you want to pay for $carName',
            style: FontManager.bodySmall(color: AppColors.grey),
          ),
          SizedBox(height: 24.h),

          // In-App Payment option
          _PaymentOptionTile(
            icon: Icons.credit_card_rounded,
            iconBgColor: AppColors.sceTeal.withOpacity(0.15),
            iconColor: AppColors.sceTeal,
            title: 'In-App Payment',
            subtitle: 'Pay securely with card or wallet',
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      OnlinePaymentView(carName: carName, amount: amount),
                ),
              );
            },
          ),
          SizedBox(height: 12.h),

          // Bank Transfer / Offline option
          _PaymentOptionTile(
            icon: Icons.account_balance_rounded,
            iconBgColor: AppColors.sceGold.withOpacity(0.15),
            iconColor: AppColors.sceGold,
            title: 'Bank Transfer / Offline',
            subtitle: 'Pay via bank or in person',
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      OfflinePaymentView(carName: carName, amount: amount),
                ),
              );
            },
          ),
          SizedBox(height: 20.h),

          // Cancel button
          Center(
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: FontManager.bodyMedium(color: AppColors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// A single tappable payment option row with icon + title + subtitle
class _PaymentOptionTile extends StatelessWidget {
  final IconData icon;
  final Color iconBgColor;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _PaymentOptionTile({
    required this.icon,
    required this.iconBgColor,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          decoration: BoxDecoration(
            color: const Color(0xFF1C2537),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: AppColors.grey.withOpacity(0.15),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              // Icon container
              Container(
                width: 48.w,
                height: 48.w,
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 24.sp),
              ),
              SizedBox(width: 16.w),

              // Text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: FontManager.bodyMedium(color: AppColors.white),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      subtitle,
                      style: FontManager.bodySmall(color: AppColors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
