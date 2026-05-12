import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rionydo/app_utils/constants/font_manager.dart';
import 'package:rionydo/app_utils/utils/app_colors.dart';
import 'package:rionydo/views/bidding/widgets/bids_models.dart';
import 'package:rionydo/views/payment/presentations/payment_process_view.dart';

/// A single row in the recent-transactions list.
class TransactionRow extends StatelessWidget {
  final Transaction transaction;

  const TransactionRow({
    super.key,
    required this.transaction,
  });

  void _openPayment(BuildContext context) {
    final id = transaction.auctionId;
    if (id == null || id.isEmpty) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentProcessView(auctionId: id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
              switch (transaction.status) {
                TransactionStatus.paid => Text(
                    'Paid',
                    style: FontManager.labelSmall(color: AppColors.sceTeal),
                  ),
                TransactionStatus.payNow =>
                  PayNowButton(onTap: () => _openPayment(context)),
                TransactionStatus.unpaid => const _UnpaidTag(),
              },
            ],
          ),
        ],
      ),
    );
  }
}

/// Teal pill — opens PaymentProcessView (bidder only).
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

/// Grey pill — shown for dealer transactions with payment_pending status.
class _UnpaidTag extends StatelessWidget {
  const _UnpaidTag();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.35)),
      ),
      child: Text(
        'Unpaid',
        style: FontManager.labelSmall(color: AppColors.error),
      ),
    );
  }
}
