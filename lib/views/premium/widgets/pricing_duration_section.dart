import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rionydo/app_utils/constants/font_manager.dart';
import 'package:rionydo/app_utils/utils/app_colors.dart';
import 'package:rionydo/core/widgets/custom_text_field.dart';
import 'section_header.dart';

class PricingDurationSection extends StatelessWidget {
  final TextEditingController reservePriceController;
  final TextEditingController buyNowPriceController;
  final String selectedDuration;
  final VoidCallback onSelectDuration;

  const PricingDurationSection({
    super.key,
    required this.reservePriceController,
    required this.buyNowPriceController,
    required this.selectedDuration,
    required this.onSelectDuration,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AuctionSectionHeader(title: "PRICING & DURATION"),
        SizedBox(height: 12.h),

        // Reserve Price
        Text(
          "Reserve Price (Minimum)",
          style: FontManager.bodySmall(color: AppColors.sceGreyA0),
        ),
        SizedBox(height: 8.h),
        _buildPriceField(
          controller: reservePriceController,
          hint: "CHF",
        ),
        SizedBox(height: 16.h),

        // Buy Now Price
        Text(
          "Buy Now Price (Optional)",
          style: FontManager.bodySmall(color: AppColors.sceGreyA0),
        ),
        SizedBox(height: 8.h),
        _buildPriceField(
          controller: buyNowPriceController,
          hint: "CHF",
        ),
        SizedBox(height: 16.h),

        // Auction Duration
        Text(
          "Auction Duration",
          style: FontManager.bodySmall(color: AppColors.sceGreyA0),
        ),
        SizedBox(height: 8.h),
        _buildDurationPicker(),
      ],
    );
  }

  Widget _buildPriceField({
    required TextEditingController controller,
    required String hint,
  }) {
    return CustomTextField(
      hintText: hint,
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      textInputAction: TextInputAction.done,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
      ],
      prefixIcon: Padding(
        padding: EdgeInsets.only(left: 16.w, right: 8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "\$",
              style: FontManager.bodyMedium(color: AppColors.sceGreyA0),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDurationPicker() {
    return GestureDetector(
      onTap: onSelectDuration,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.04),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.white.withOpacity(0.08)),
        ),
        child: Row(
          children: [
            Icon(Icons.schedule, color: AppColors.sceGreyA0, size: 20.sp),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                selectedDuration.isEmpty ? "Select duration" : selectedDuration,
                style: FontManager.bodySmall(
                  color: selectedDuration.isEmpty
                      ? AppColors.sceGreyA0
                      : Colors.white,
                ),
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppColors.sceGreyA0,
              size: 22.sp,
            ),
          ],
        ),
      ),
    );
  }
}
