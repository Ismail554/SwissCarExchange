import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rionydo/core/constants/font_manager.dart';
import 'package:rionydo/core/utils/app_colors.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isPrimary;
  final bool isLoading;
  final bool isActive;
  final IconData? icon;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isPrimary = true,
    this.isLoading = false,
    this.isActive = true,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: 54.h,
      decoration: BoxDecoration(
        color: isPrimary
            ? (isActive ? null : AppColors.cardBG.withOpacity(0.1))
            : Colors.transparent,
        gradient: isPrimary && isActive
            ? LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.sceTeal,
                  AppColors.sceTeal.withOpacity(0.8),
                  AppColors.sceTeal.withOpacity(0.6),
                ],
              )
            : null,
        borderRadius: BorderRadius.circular(12),
        border: isPrimary
            ? null
            : Border.all(
                color: isActive ? AppColors.textHint : AppColors.dividerDark,
              ),
        boxShadow: isPrimary && isActive
            ? [
                BoxShadow(
                  color: AppColors.sceTeal.withOpacity(0.25),
                  blurRadius: 15,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: (isLoading || !isActive) ? null : onPressed,
          child: Center(
            child: isLoading
                ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (icon != null) ...[
                        Icon(icon, color: Colors.white, size: 20.sp),
                        SizedBox(width: 8.w),
                      ],
                      Text(
                        text,
                        style: FontManager.buttonText(color: AppColors.white),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
