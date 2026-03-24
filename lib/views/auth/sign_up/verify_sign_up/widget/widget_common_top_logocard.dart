import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wynante/core/utils/app_spacing.dart';
import 'package:wynante/core/utils/assets_manager.dart';

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
                width: 184,
                height: 184,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF00D5BE),
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
