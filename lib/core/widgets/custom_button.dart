import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isPrimary;
  final bool isLoading;
  final bool isActive;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isPrimary = true,
    this.isLoading = false,
    this.isActive = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: 54.h,
      decoration: BoxDecoration(
        color: isPrimary
            ? (isActive ? null : const Color(0xFF1C212A))
            : Colors.transparent,
        gradient: isPrimary && isActive
            ? const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF00D5BE), // Light green
                  Color(0xFF00BBA7), // Medium green
                  Color(0xFF009689), // Deep green
                ],
              )
            : null,
        borderRadius: BorderRadius.circular(12),
        border: isPrimary ? null : Border.all(color: isActive ? const Color(0xFFA0AABF) : const Color(0xFF323B4B)),
        boxShadow: isPrimary && isActive
            ? [
                BoxShadow(
                  color: const Color(0xFF00D5BE).withOpacity(0.25),
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
                : Text(
                    text,
                    style: TextStyle(
                      color: isActive ? Colors.white : const Color(0xFF6B7280),
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
