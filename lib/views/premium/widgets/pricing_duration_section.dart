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
  final DateTime? startDate;
  final TimeOfDay? startTime;
  final DateTime? endDate;
  final TimeOfDay? endTime;
  final VoidCallback onSelectStartDate;
  final VoidCallback onSelectStartTime;
  final VoidCallback onSelectEndDate;
  final VoidCallback onSelectEndTime;
  final VoidCallback onClearStartTime;

  const PricingDurationSection({
    super.key,
    required this.reservePriceController,
    required this.buyNowPriceController,
    required this.startDate,
    required this.startTime,
    required this.endDate,
    required this.endTime,
    required this.onSelectStartDate,
    required this.onSelectStartTime,
    required this.onSelectEndDate,
    required this.onSelectEndTime,
    required this.onClearStartTime,
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
        _buildPriceField(controller: reservePriceController, hint: "CHF"),
        SizedBox(height: 16.h),

        // Buy Now Price
        Text(
          "Buy Now Price (Optional)",
          style: FontManager.bodySmall(color: AppColors.sceGreyA0),
        ),
        SizedBox(height: 8.h),
        _buildPriceField(
          controller: buyNowPriceController,
          hint: "Buy Now Price",
          validator: (value) {
            if (value == null || value.isEmpty) return null; // Optional
            final buyPrice = double.tryParse(value) ?? 0;
            final reservePrice =
                double.tryParse(reservePriceController.text) ?? 0;
            if (buyPrice < reservePrice) {
              return "Must be ≥ Reserve Price";
            }
            return null;
          },
        ),
        SizedBox(height: 20.h),

        // Start Date & Time
        Text(
          "Auction Starts At",
          style: FontManager.bodySmall(color: AppColors.sceGreyA0),
        ),
        SizedBox(height: 8.h),
        _buildPickerRow(
          dateText: _formatDate(startDate),
          timeText: _formatTime(startTime),
          dateHint: "Select Start Date",
          timeHint: "Select Time (Optional)",
          isDateSelected: startDate != null,
          isTimeSelected: startTime != null,
          onTapDate: onSelectStartDate,
          onTapTime: onSelectStartTime,
          onClearTime: onClearStartTime,
          showClearTime: startTime != null,
        ),
        SizedBox(height: 20.h),

        // End Date & Time
        Text(
          "Auction Ends At",
          style: FontManager.bodySmall(color: AppColors.sceGreyA0),
        ),
        SizedBox(height: 8.h),
        _buildPickerRow(
          dateText: _formatDate(endDate),
          timeText: _formatTime(endTime),
          dateHint: "Select End Date",
          timeHint: "Select End Time",
          isDateSelected: endDate != null,
          isTimeSelected: endTime != null,
          onTapDate: onSelectEndDate,
          onTapTime: onSelectEndTime,
          onClearTime: () {},
          showClearTime: false,
        ),
      ],
    );
  }

  Widget _buildPriceField({
    required TextEditingController controller,
    required String hint,
    String? Function(String?)? validator,
  }) {
    return CustomTextField(
      hintText: hint,
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      textInputAction: TextInputAction.next,
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
              "CHF",
              style: FontManager.bodyMedium(color: AppColors.sceGreyA0),
            ),
          ],
        ),
      ),
      validator: validator,
    );
  }

  Widget _buildPickerRow({
    required String dateText,
    required String timeText,
    required String dateHint,
    required String timeHint,
    required bool isDateSelected,
    required bool isTimeSelected,
    required VoidCallback onTapDate,
    required VoidCallback onTapTime,
    required VoidCallback onClearTime,
    required bool showClearTime,
  }) {
    return Row(
      children: [
        Expanded(
          flex: 5,
          child: GestureDetector(
            onTap: onTapDate,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.04),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: Colors.white.withOpacity(0.08)),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_today_rounded,
                    color: isDateSelected
                        ? AppColors.sceTeal
                        : AppColors.sceGreyA0,
                    size: 18.sp,
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Text(
                      isDateSelected ? dateText : dateHint,
                      style: FontManager.bodySmall(
                        color: isDateSelected
                            ? Colors.white
                            : AppColors.sceGreyA0,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          flex: 4,
          child: GestureDetector(
            onTap: onTapTime,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.04),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: Colors.white.withOpacity(0.08)),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.access_time_rounded,
                    color: isTimeSelected
                        ? AppColors.sceTeal
                        : AppColors.sceGreyA0,
                    size: 18.sp,
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Text(
                      isTimeSelected ? timeText : timeHint,
                      style: FontManager.bodySmall(
                        color: isTimeSelected
                            ? Colors.white
                            : AppColors.sceGreyA0,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (showClearTime) ...[
                    SizedBox(width: 4.w),
                    GestureDetector(
                      onTap: onClearTime,
                      child: Padding(
                        padding: EdgeInsets.all(2.w),
                        child: Icon(
                          Icons.cancel_rounded,
                          color: AppColors.sceGreyA0,
                          size: 16.sp,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return "${date.day} ${months[date.month - 1]} ${date.year}";
  }

  String _formatTime(TimeOfDay? time) {
    if (time == null) return '';
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return "$hour:$minute";
  }
}
