import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rionydo/core/constants/font_manager.dart';
import 'package:rionydo/core/utils/app_colors.dart';
import 'package:rionydo/views/bidding/widgets/bids_models.dart';

/// A single row in the recent-transactions list.
class TransactionRow extends StatelessWidget {
  final Transaction transaction;
  final VoidCallback onPayNow;

  const TransactionRow({
    super.key,
    required this.transaction,
    required this.onPayNow,
  });

  @override
  Widget build(BuildContext context) {
    final isPaid = transaction.status == TransactionStatus.paid;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 14.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left: car name + date
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.carName,
                  style: FontManager.bodyMedium(color: AppColors.white),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                Text(
                  transaction.date,
                  style: FontManager.labelSmall(color: AppColors.grey),
                ),
              ],
            ),
          ),
          SizedBox(width: 12.w),

          // Right: amount + status badge
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                transaction.amount,
                style: FontManager.bodyMedium(color: AppColors.white),
              ),
              SizedBox(height: 6.h),
              if (isPaid)
                Text(
                  'Paid',
                  style: FontManager.labelSmall(color: AppColors.sceTeal),
                )
              else
                PayNowButton(onTap: onPayNow),
            ],
          ),
        ],
      ),
    );
  }
}

/// Teal pill that opens the payment options sheet.
class PayNowButton extends StatelessWidget {
  final VoidCallback onTap;

  const PayNowButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 5.h),
        decoration: BoxDecoration(
          color: AppColors.sceTeal,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          'Pay Now',
          style: FontManager.labelSmall(color: AppColors.black),
        ),
      ),
    );
  }
}
