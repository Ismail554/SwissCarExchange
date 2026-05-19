import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rionydo/app_utils/utils/app_colors.dart';

class CustomTextField extends StatefulWidget {
  final String hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final TextInputAction? textInputAction;
  final bool enabled;
  final TextCapitalization? textCapitalization;
  final List<TextInputFormatter>? inputFormatters;
  final int? validationMinLength;
  final int? validationMaxLength;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;
  final FocusNode? focusNode;

  const CustomTextField({
    super.key,
    required this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.textInputAction,
    this.inputFormatters,
    this.enabled = true,
    this.validationMinLength,
    this.textCapitalization,
    this.validationMaxLength,
    this.onChanged,
    this.onFieldSubmitted,
    this.focusNode,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  // Own the controller internally if none is provided,
  // so it's never recreated across rebuilds.
  late final TextEditingController _internalController;
  late final FocusNode _internalFocusNode;

  TextEditingController get _effectiveController =>
      widget.controller ?? _internalController;

  FocusNode get _effectiveFocusNode => widget.focusNode ?? _internalFocusNode;

  @override
  void initState() {
    super.initState();
    _internalController = TextEditingController();
    _internalFocusNode = FocusNode();
  }

  @override
  void dispose() {
    // Only dispose what we own.
    if (widget.controller == null) _internalController.dispose();
    if (widget.focusNode == null) _internalFocusNode.dispose();
    super.dispose();
  }

  String? _defaultValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter ${widget.hintText}";
    }
    if (widget.validationMinLength != null &&
        value.length < widget.validationMinLength!) {
      return "${widget.hintText} must be at least ${widget.validationMinLength} characters long";
    }
    if (widget.validationMaxLength != null &&
        value.length > widget.validationMaxLength!) {
      return "${widget.hintText} must be at most ${widget.validationMaxLength} characters long";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textCapitalization: widget.textCapitalization ?? TextCapitalization.none,
      enabled: widget.enabled,
      controller: _effectiveController,
      focusNode: _effectiveFocusNode,
      obscureText: widget.obscureText,
      // Fixes cursor jumping on some Android keyboards
      obscuringCharacter: '•',
      keyboardType: widget.keyboardType,
      // Preserves cursor position correctly during text composition (CJK, etc.)
      textInputAction: widget.textInputAction,
      inputFormatters: widget.inputFormatters,
      onChanged: widget.onChanged,
      onFieldSubmitted: widget.onFieldSubmitted,
      // Prevents autocorrect from repositioning the cursor unexpectedly
      autocorrect:
          widget.keyboardType != TextInputType.emailAddress &&
          widget.keyboardType != TextInputType.visiblePassword,
      enableSuggestions: !widget.obscureText,
      // Keeps text vertically centered so tap target aligns with cursor
      textAlignVertical: TextAlignVertical.center,
      validator: widget.validator ?? _defaultValidator,
      style: TextStyle(color: Colors.white, fontSize: 14.sp),
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: TextStyle(color: AppColors.sceGreyA0, fontSize: 14.sp),
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.suffixIcon,
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.04),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.sceOnboardingGold,
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.errorRed, width: 1.0),
        ),
      ),
    );
  }
}
