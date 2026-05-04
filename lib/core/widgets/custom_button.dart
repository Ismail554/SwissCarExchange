import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rionydo/app_utils/constants/font_manager.dart';
import 'package:rionydo/app_utils/utils/app_colors.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isPrimary;
  final bool isLoading;
  final bool isActive;
  final bool isDanger;
  final IconData? icon;
  final String? loadingText;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isPrimary = true,
    this.isLoading = false,
    this.isActive = true,
    this.isDanger = false,
    this.icon,
    this.loadingText,
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
                colors: isDanger
                    ? [
                        AppColors.errorRed,
                        AppColors.errorRed.withOpacity(0.8),
                      ]
                    : [
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
                color: isDanger
                    ? AppColors.errorRed
                    : (isActive ? AppColors.textHint : AppColors.dividerDark),
              ),
        boxShadow: isPrimary && isActive
            ? [
                BoxShadow(
                  color: (isDanger ? AppColors.errorRed : AppColors.sceTeal).withOpacity(0.25),
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
                ? (loadingText != null
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 16.h,
                            width: 16.w,
                            child: const CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Text(
                            loadingText!,
                            style: FontManager.buttonText(color: AppColors.white),
                          ),
                        ],
                      )
                    : SizedBox(
                        height: 24.h,
                        width: 24.w,
                        child: const CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      ))
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
