import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rionydo/app_utils/utils/app_colors.dart';
import 'package:rionydo/app_utils/constants/font_manager.dart';
import 'package:rionydo/core/widgets/custom_button.dart';

class BidConfirmationDialog extends StatefulWidget {
  final int bidAmount;
  final String formattedAmount;
  final VoidCallback onConfirm;

  const BidConfirmationDialog({
    super.key,
    required this.bidAmount,
    required this.formattedAmount,
    required this.onConfirm,
  });

  @override
  State<BidConfirmationDialog> createState() => _BidConfirmationDialogState();
}

class _BidConfirmationDialogState extends State<BidConfirmationDialog>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  Timer? _autoCloseTimer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..forward();

    _autoCloseTimer = Timer(const Duration(seconds: 5), () {
      if (mounted) Navigator.of(context).pop();
    });
  }

  @override
  void dispose() {
    _autoCloseTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.sceCardBg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
        side: BorderSide(color: AppColors.sceTeal.withValues(alpha: 0.2)),
      ),
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Countdown indicator
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 56.w,
                      height: 56.w,
                      child: CircularProgressIndicator(
                        value: 1.0 - _controller.value,
                        strokeWidth: 3,
                        backgroundColor: Colors.white.withValues(alpha: 0.1),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.sceTeal,
                        ),
                      ),
                    ),
                    Text(
                      '${(5 - (_controller.value * 5)).ceil()}',
                      style: FontManager.heading3(color: AppColors.sceTeal),
                    ),
                  ],
                );
              },
            ),
            SizedBox(height: 20.h),

            Text(
              'Confirm Your Bid',
              style: FontManager.heading3(color: Colors.white),
            ),
            SizedBox(height: 8.h),

            Text(
              'You are about to place a bid of',
              style: FontManager.bodyMedium(color: AppColors.sceGreyA0),
            ),
            SizedBox(height: 12.h),

            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: AppColors.sceTeal.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: AppColors.sceTeal.withValues(alpha: 0.3),
                ),
              ),
              child: Text(
                'CHF ${widget.formattedAmount}',
                style: FontManager.heading2(color: AppColors.sceTeal),
              ),
            ),
            SizedBox(height: 8.h),

            Text(
              'This action cannot be undone.',
              style: FontManager.bodySmall(color: AppColors.errorRed),
            ),
            SizedBox(height: 24.h),

            // Buttons
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    text: 'Cancel',
                    isPrimary: false,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: CustomButton(
                    text: 'Confirm',
                    onPressed: widget.onConfirm,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
