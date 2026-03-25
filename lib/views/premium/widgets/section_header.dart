import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rionydo/core/constants/font_manager.dart';
import 'package:rionydo/core/utils/app_colors.dart';

class AuctionSectionHeader extends StatelessWidget {
  final String title;
  const AuctionSectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: FontManager.labelSmall(color: AppColors.sceGreyA0).copyWith(
        letterSpacing: 1.5,
        fontSize: 11.sp,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
