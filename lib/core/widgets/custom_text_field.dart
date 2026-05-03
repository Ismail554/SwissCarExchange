import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rionydo/app_utils/utils/app_colors.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;

  const CustomTextField({
    super.key,
    required this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.validator, this.textInputAction, this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(

      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      textInputAction: textInputAction,
      inputFormatters: inputFormatters,
      style: TextStyle(color: Colors.white, fontSize: 14.sp),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: AppColors.sceGreyA0, fontSize: 14.sp),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: Colors.white.withOpacity(0.04), // Slight transluscent fill
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.08)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.sceOnboardingGold, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.errorRed, width: 1.0),
        ),
      ),
    );
  }
}
