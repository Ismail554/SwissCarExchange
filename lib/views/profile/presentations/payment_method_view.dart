import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rionydo/app_utils/constants/font_manager.dart';
import 'package:rionydo/app_utils/utils/app_colors.dart';
import 'package:rionydo/core/widgets/custom_back_button.dart';
import 'package:rionydo/core/widgets/custom_button.dart';
import 'package:rionydo/core/widgets/widget_snackbar.dart';

import 'package:rionydo/views/bidding/presentations/pay_successful.dart';
import 'package:rionydo/views/won_auction/presentations/auction_contact_view.dart';

/// Screen to collect Switzerland offline bank transfer information (IBAN/SEPA).
class PaymentMethodView extends StatefulWidget {
  final bool isPaymentFlow;

  const PaymentMethodView({super.key, this.isPaymentFlow = false});

  @override
  State<PaymentMethodView> createState() => _PaymentMethodViewState();
}

class _PaymentMethodViewState extends State<PaymentMethodView> {
  final _formKey = GlobalKey<FormState>();
  final _accountHolderCtrl = TextEditingController();
  final _ibanCtrl = TextEditingController();
  final _bankNameCtrl = TextEditingController();
  final _swiftCtrl = TextEditingController();

  @override
  void dispose() {
    _accountHolderCtrl.dispose();
    _ibanCtrl.dispose();
    _bankNameCtrl.dispose();
    _swiftCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      if (widget.isPaymentFlow) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                const PaySuccessful(nextScreen: AuctionContactView()),
          ),
        );
      } else {
        AppSnackBar.success(context, "Bank details saved successfully!");
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.sceDarkBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 56.w,
        leading: const CustomBackButton(),
        title: Text(
          'Bank Transfer',
          style: FontManager.heading2(color: AppColors.white),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- Info banner ---
                _InfoBanner(
                  icon: Icons.account_balance_rounded,
                  message: widget.isPaymentFlow
                      ? 'Provide your Swiss bank details to receive the payment via IBAN/SEPA transfer.'
                      : 'Save your Swiss bank details for offline IBAN/SEPA transfers.',
                ),
                SizedBox(height: 28.h),

                // --- Account Holder Name ---
                const _FieldLabel('Account Holder Name'),
                SizedBox(height: 8.h),
                _BankTextField(
                  controller: _accountHolderCtrl,
                  hint: 'e.g. Hans Müller',
                  prefixIcon: Icons.person_outline_rounded,
                  keyboardType: TextInputType.name,
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Enter account holder name'
                      : null,
                ),
                SizedBox(height: 18.h),

                // --- IBAN ---
                const _FieldLabel('IBAN'),
                SizedBox(height: 8.h),
                _BankTextField(
                  controller: _ibanCtrl,
                  hint: 'CH56 0483 5012 3456 7800 9',
                  prefixIcon: Icons.tag_rounded,
                  keyboardType: TextInputType.text,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9 ]')),
                    _IbanFormatter(),
                  ],
                  maxLength: 26, // CH IBAN: 21 digits + 5 spaces
                  textCapitalization: TextCapitalization.characters,
                  validator: (v) {
                    final raw = v?.replaceAll(' ', '') ?? '';
                    if (raw.isEmpty) return 'Enter IBAN';
                    if (!raw.toUpperCase().startsWith('CH')) {
                      return 'Swiss IBAN must start with CH';
                    }
                    if (raw.length < 21) return 'IBAN is too short';
                    return null;
                  },
                ),
                SizedBox(height: 18.h),

                // --- Bank Name ---
                const _FieldLabel('Bank Name'),
                SizedBox(height: 8.h),
                _BankTextField(
                  controller: _bankNameCtrl,
                  hint: 'e.g. UBS, Credit Suisse, PostFinance',
                  prefixIcon: Icons.account_balance_outlined,
                  keyboardType: TextInputType.text,
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Enter bank name'
                      : null,
                ),
                SizedBox(height: 18.h),

                // --- SWIFT/BIC (optional) ---
                const _FieldLabel('SWIFT / BIC Code (Optional)'),
                SizedBox(height: 8.h),
                _BankTextField(
                  controller: _swiftCtrl,
                  hint: 'e.g. UBSWCHZH80A',
                  prefixIcon: Icons.code_rounded,
                  keyboardType: TextInputType.text,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9]')),
                    LengthLimitingTextInputFormatter(11),
                  ],
                  textCapitalization: TextCapitalization.characters,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return null; // optional
                    final len = v.trim().length;
                    if (len != 8 && len != 11) {
                      return 'SWIFT/BIC must be 8 or 11 characters';
                    }
                    return null;
                  },
                ),

                SizedBox(height: 12.h),

                // --- Security note ---
                _SecurityNote(),

                SizedBox(height: 40.h),

                // --- Submit button ---
                CustomButton(
                  text: widget.isPaymentFlow
                      ? 'Confirm Transfer Details'
                      : 'Save Bank Details',
                  onPressed: _submit,
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Info Banner
// ---------------------------------------------------------------------------

class _InfoBanner extends StatelessWidget {
  final IconData icon;
  final String message;

  const _InfoBanner({required this.icon, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.sceTeal.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.sceTeal.withOpacity(0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.sceTeal, size: 20.sp),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              message,
              style: FontManager.bodySmall(color: AppColors.sceGreyA0),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Security Note
// ---------------------------------------------------------------------------

class _SecurityNote extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.lock_outline_rounded,
          color: AppColors.sceGreyA0,
          size: 14.sp,
        ),
        SizedBox(width: 6.w),
        Expanded(
          child: Text(
            'Your bank details are stored securely and only used for IBAN/SEPA transfers.',
            style: FontManager.bodySmall(color: AppColors.sceGreyA0),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Reusable Field Label
// ---------------------------------------------------------------------------

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text, style: FontManager.labelMedium(color: AppColors.white));
  }
}

// ---------------------------------------------------------------------------
// Reusable Bank Text Field
// ---------------------------------------------------------------------------

class _BankTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData? prefixIcon;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;
  final bool obscureText;
  final TextCapitalization textCapitalization;
  final String? Function(String?)? validator;

  const _BankTextField({
    required this.controller,
    required this.hint,
    this.prefixIcon,
    required this.keyboardType,
    this.inputFormatters,
    this.maxLength,
    this.obscureText = false,
    this.textCapitalization = TextCapitalization.none,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      maxLength: maxLength,
      obscureText: obscureText,
      textCapitalization: textCapitalization,
      validator: validator,
      style: FontManager.bodyMedium(color: AppColors.white),
      buildCounter:
          (_, {required currentLength, required isFocused, maxLength}) =>
              const SizedBox.shrink(),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: FontManager.bodyMedium(
          color: AppColors.grey.withOpacity(0.5),
        ),
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, color: AppColors.grey, size: 20.sp)
            : null,
        filled: true,
        fillColor: AppColors.sceCardBg,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: AppColors.grey.withOpacity(0.2)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: AppColors.grey.withOpacity(0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: AppColors.sceTeal, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// IBAN Formatter — groups into blocks of 4 separated by spaces
// e.g. CH56 0483 5012 3456 7800 9
// ---------------------------------------------------------------------------

class _IbanFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final raw = newValue.text.replaceAll(' ', '').toUpperCase();
    final buffer = StringBuffer();
    for (int i = 0; i < raw.length; i++) {
      if (i > 0 && i % 4 == 0) buffer.write(' ');
      buffer.write(raw[i]);
    }
    final formatted = buffer.toString();
    return newValue.copyWith(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
