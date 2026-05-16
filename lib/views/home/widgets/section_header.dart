import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rionydo/app_utils/utils/app_colors.dart';
import 'package:rionydo/app_utils/constants/font_manager.dart';
import 'package:go_router/go_router.dart';

class SectionHeader extends StatelessWidget {
  final String title;

  const SectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: FontManager.heading4(
            color: AppColors.sceSectionHeaderGold,
            fontSize: 15.sp,
          ).copyWith(fontWeight: FontWeight.w800, letterSpacing: 0.5),
        ),
        GestureDetector(
          onTap: () {
            context.go('/auctions');
          },
          child: Text(
            'View All',
            style: FontManager.bodySmall(
              color: AppColors.sceTeal,
              fontSize: 12.sp,
            ),
          ),
        ),
      ],
    );
  }
}
