import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rionydo/app_utils/utils/app_colors.dart';

class CustomDropdownField extends StatefulWidget {
  final String hintText;
  final String? label;
  final List<String> items;
  final String? value;
  final void Function(String?)? onChanged;
  final String? Function(String?)? validator;
  final IconData? prefixIcon;
  final TextInputAction? textInputAction;

  const CustomDropdownField({
    super.key,
    required this.hintText,
    required this.items,
    this.label,
    this.value,
    this.onChanged,
    this.validator,
    this.prefixIcon,
    this.textInputAction,
  });

  @override
  State<CustomDropdownField> createState() => _CustomDropdownFieldState();
}

class _CustomDropdownFieldState extends State<CustomDropdownField>
    with SingleTickerProviderStateMixin {
  bool _isFocused = false;
  late AnimationController _glowController;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _glowAnimation = CurvedAnimation(
      parent: _glowController,
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  void _onFocusChange(bool focused) {
    setState(() => _isFocused = focused);
    focused ? _glowController.forward() : _glowController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final hasValue =
        widget.value != null && widget.items.contains(widget.value);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Floating label above the field
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: TextStyle(
              color: _isFocused
                  ? AppColors.sceOnboardingGold
                  : AppColors.sceGreyA0,
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.4,
            ),
          ),
          SizedBox(height: 6.h),
        ],

        // Animated glow wrapper
        AnimatedBuilder(
          animation: _glowAnimation,
          builder: (context, child) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14.r),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.sceOnboardingGold.withOpacity(
                      0.18 * _glowAnimation.value,
                    ),
                    blurRadius: 16,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: child,
            );
          },
          child: Focus(
            onFocusChange: _onFocusChange,
            child: DropdownButtonFormField<String>(
              value: widget.items.contains(widget.value) ? widget.value : null,
              items: widget.items.map((item) {
                final isSelected = item == widget.value;
                return DropdownMenuItem<String>(
                  value: item,
                  child: Row(
                    children: [
                      // Gold dot for selected item
                      AnimatedContainer(
                        
                        duration: const Duration(milliseconds: 150),
                        width: isSelected ? 6.w : 0,
                        height: 6.h,
                        margin: EdgeInsets.only(right: isSelected ? 8.w : 0),
                        decoration: const BoxDecoration(
                          color: AppColors.sceOnboardingGold,
                          shape: BoxShape.circle,
                        ),
                      ),
                      Text(
                        item,
                        style: TextStyle(
                          color: isSelected
                              ? AppColors.sceOnboardingGold
                              : Colors.white,
                          fontSize: 14.sp,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: widget.onChanged,
              validator: widget.validator,

              // Premium dark menu
              dropdownColor: AppColors.sceCardBg,
              menuMaxHeight: 260.h,

              style: TextStyle(
                color: hasValue ? Colors.white : AppColors.sceGreyA0,
                fontSize: 14.sp,
                fontWeight: hasValue ? FontWeight.w500 : FontWeight.w400,
              ),

              // Animated rotate icon
              icon: AnimatedRotation(
                turns: _isFocused ? 0.5 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: _isFocused
                      ? AppColors.sceOnboardingGold
                      : AppColors.sceGreyA0,
                  size: 22.sp,
                ),
              ),

              decoration: InputDecoration(
                hintText: hasValue ? null : widget.hintText,
                hintStyle: TextStyle(
                  color: AppColors.sceGreyA0,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                ),

                // Optional prefix icon
                prefixIcon: widget.prefixIcon != null
                    ? Padding(
                        padding: EdgeInsets.only(left: 16.w, right: 4.w),
                        child: Icon(
                          widget.prefixIcon,
                          color: _isFocused
                              ? AppColors.sceOnboardingGold
                              : AppColors.sceGreyA0,
                          size: 18.sp,
                        ),
                      )
                    : null,
                prefixIconConstraints: BoxConstraints(
                  minWidth: widget.prefixIcon != null ? 44.w : 0,
                  minHeight: 0,
                ),

                filled: true,
                // Subtle gradient-like layered fill
                fillColor: _isFocused
                    ? AppColors.sceOnboardingGold.withOpacity(0.05)
                    : Colors.white.withOpacity(0.04),

                contentPadding: EdgeInsets.symmetric(
                  horizontal: 20.w,
                  vertical: 16.h,
                ),

                border: _buildBorder(Colors.white.withOpacity(0.1)),
                enabledBorder: _buildBorder(Colors.white.withOpacity(0.08)),
                focusedBorder: _buildBorder(
                  AppColors.sceOnboardingGold,
                  width: 1.5,
                ),
                errorBorder: _buildBorder(AppColors.errorRed, width: 1.0),
                focusedErrorBorder: _buildBorder(
                  AppColors.errorRed,
                  width: 1.5,
                ),

                errorStyle: TextStyle(
                  fontSize: 11.sp,
                  color: AppColors.errorRed,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  OutlineInputBorder _buildBorder(Color color, {double width = 1.0}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(14.r),
      borderSide: BorderSide(color: color, width: width),
    );
  }
}
