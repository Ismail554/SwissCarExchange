import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rionydo/app_utils/utils/app_colors.dart';
import 'package:rionydo/app_utils/utils/app_spacing.dart';
import 'package:rionydo/app_utils/utils/assets_manager.dart';

class WidgetCommonTopLogocard extends StatelessWidget {
  final String title;
  final String subtitle;
  const WidgetCommonTopLogocard({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 184.w,
                height: 184.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.sceTeal,
                    width: 5.0,
                  ),
                ),
              ),
              Image.asset(
                IconAssets.app_logo,
                width: 180,
                height: 180,
                fit: BoxFit.contain,
              ),
            ],
          ),
        ),

        AppSpacing.h40,
        Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 26.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        AppSpacing.h12,
        Text(
          subtitle,
          style: TextStyle(
            color: Colors.white.withOpacity(0.4),
            fontSize: 16.sp,
          ),
        ),

        AppSpacing.h40,
      ],
    );
  }
}
