import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:rionydo/app_utils/constants/font_manager.dart';
import 'package:rionydo/app_utils/utils/app_colors.dart';
import 'package:rionydo/views/bidding/widgets/bids_models.dart';

/// A floating card row in the recent-transactions list.
class TransactionRow extends StatelessWidget {
  final Transaction transaction;

  const TransactionRow({super.key, required this.transaction});

  void _openPayment(BuildContext context) {
    final id = transaction.auctionId;
    if (id == null || id.isEmpty) return;
    context.push('/payment/$id');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          // Floating card: semi-translucent surface with layered shadows
          color: AppColors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: AppColors.white.withValues(alpha: 0.08),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              blurRadius: 12,
              spreadRadius: 0,
              offset: const Offset(0, 4),
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.10),
              blurRadius: 4,
              spreadRadius: 0,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Leading icon bubble
            _IconBubble(status: transaction.status),
            SizedBox(width: 12.w),

            // Middle: car name + date
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.carName,
                    style: FontManager.bodyMedium(color: AppColors.white),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time_rounded,
                        size: 11.sp,
                        color: AppColors.grey,
                      ),
                      SizedBox(width: 3.w),
                      Text(
                        transaction.date,
                        style: FontManager.labelSmall(color: AppColors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: 12.w),

            // Right: amount + status badge (stacked, end-aligned)
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  transaction.amount,
                  style: FontManager.bodyMedium(
                    color: AppColors.white,
                  ).copyWith(fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 6.h),
                switch (transaction.status) {
                  TransactionStatus.paid => const _PaidBadge(),
                  TransactionStatus.payNow => PayNowButton(
                    onTap: () => _openPayment(context),
                  ),
                  TransactionStatus.unpaid => const _UnpaidBadge(),
                },
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Small icon bubble on the left reflecting transaction status.
class _IconBubble extends StatelessWidget {
  final TransactionStatus status;

  const _IconBubble({required this.status});

  @override
  Widget build(BuildContext context) {
    final (Color bg, Color icon, IconData iconData) = switch (status) {
      TransactionStatus.paid => (
        AppColors.sceTeal.withValues(alpha: 0.15),
        AppColors.sceTeal,
        Icons.check_circle_outline_rounded,
      ),
      TransactionStatus.payNow => (
        AppColors.white.withValues(alpha: 0.08),
        AppColors.white,
        Icons.credit_card_rounded,
      ),
      TransactionStatus.unpaid => (
        AppColors.error.withValues(alpha: 0.12),
        AppColors.error,
        Icons.warning_amber_rounded,
      ),
    };

    return Container(
      width: 40.w,
      height: 40.w,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: icon.withValues(alpha: 0.20), width: 1),
      ),
      child: Icon(iconData, color: icon, size: 18.sp),
    );
  }
}

/// Teal pill — "Paid" status label.
class _PaidBadge extends StatelessWidget {
  const _PaidBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: AppColors.sceTeal.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: AppColors.sceTeal.withValues(alpha: 0.35),
          width: 1,
        ),
      ),
      child: Text(
        'Paid',
        style: FontManager.labelSmall(color: AppColors.sceTeal),
      ),
    );
  }
}

/// Glowing teal pill — opens PaymentProcessView (bidder only).
class PayNowButton extends StatelessWidget {
  final VoidCallback onTap;

  const PayNowButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.sceTeal,
              AppColors.sceTeal.withValues(alpha: 0.80),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.sceTeal.withValues(alpha: 0.40),
              blurRadius: 8,
              spreadRadius: 0,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.bolt_rounded, size: 11.sp, color: AppColors.black),
            SizedBox(width: 3.w),
            Text(
              'Pay Now',
              style: FontManager.labelSmall(
                color: AppColors.black,
              ).copyWith(fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}

/// Red pill — shown for dealer transactions with payment_pending status.
class _UnpaidBadge extends StatelessWidget {
  const _UnpaidBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: AppColors.error.withValues(alpha: 0.35),
          width: 1,
        ),
      ),
      child: Text(
        'Unpaid',
        style: FontManager.labelSmall(color: AppColors.error),
      ),
    );
  }
}
