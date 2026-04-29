import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rionydo/app_utils/constants/font_manager.dart';

class PaymentStatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color accentColor;
  final Color bgColor;

  const PaymentStatCard({
    super.key,
    required this.label,
    required this.value,
    required this.accentColor,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: accentColor.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: FontManager.labelSmall(
              color: accentColor.withOpacity(0.6),
            ).copyWith(letterSpacing: 1.2, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.h),
          Text(
            value,
            style: FontManager.heading2(
              color: accentColor,
            ).copyWith(fontWeight: FontWeight.w900),
          ),
          Text(
            "CHF",
            style: FontManager.labelSmall(color: accentColor.withOpacity(0.4)),
          ),
        ],
      ),
    );
  }
}
