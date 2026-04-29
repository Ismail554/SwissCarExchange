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

/// Screen to save and manage user payment methods (cards) or complete a payment.
class PaymentMethodView extends StatefulWidget {
  final bool isPaymentFlow;
  
  const PaymentMethodView({super.key, this.isPaymentFlow = false});


  @override
  State<PaymentMethodView> createState() => _PaymentMethodViewState();
}

class _PaymentMethodViewState extends State<PaymentMethodView> {
  final _formKey = GlobalKey<FormState>();
  final _cardNumberCtrl = TextEditingController();
  final _cardHolderCtrl = TextEditingController();
  final _expiryCtrl = TextEditingController();
  final _cvvCtrl = TextEditingController();

  @override
  void dispose() {
    _cardNumberCtrl.dispose();
    _cardHolderCtrl.dispose();
    _expiryCtrl.dispose();
    _cvvCtrl.dispose();
    super.dispose();
  }

  void _saveCard() {
    if (_formKey.currentState?.validate() ?? false) {
      if (widget.isPaymentFlow) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const PaySuccessful(
              nextScreen: AuctionContactView(),
            ),
          ),
        );
      } else {
        AppSnackBar.success(context, "Card saved successfully!");
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
          'Payment Methods',
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
                Text(
                  widget.isPaymentFlow 
                      ? 'Enter your card details to complete the payment'
                      : 'Save your cards for getting online payments',
                  style: FontManager.bodyMedium(color: AppColors.sceGreyA0),
                ),
                SizedBox(height: 32.h),

                // --- Card Number ---
                const _FieldLabel('Card Number'),
                SizedBox(height: 8.h),
                _CardTextField(
                  controller: _cardNumberCtrl,
                  hint: '1234 5678 9012 3456',
                  prefixIcon: Icons.credit_card_rounded,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    _CardNumberFormatter(),
                  ],
                  maxLength: 19,
                  validator: (v) => (v == null || v.length < 19)
                      ? 'Enter a valid card number'
                      : null,
                ),
                SizedBox(height: 18.h),

                // --- Cardholder Name ---
                const _FieldLabel('Cardholder Name'),
                SizedBox(height: 8.h),
                _CardTextField(
                  controller: _cardHolderCtrl,
                  hint: 'John Doe',
                  keyboardType: TextInputType.name,
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Enter cardholder name'
                      : null,
                ),
                SizedBox(height: 18.h),

                // --- Expiry + CVV row ---
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const _FieldLabel('Expiry Date'),
                          SizedBox(height: 8.h),
                          _CardTextField(
                            controller: _expiryCtrl,
                            hint: 'MM/YY',
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              _ExpiryFormatter(),
                            ],
                            maxLength: 5,
                            validator: (v) =>
                                (v == null || v.length < 5) ? 'Invalid' : null,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const _FieldLabel('CVV'),
                          SizedBox(height: 8.h),
                          _CardTextField(
                            controller: _cvvCtrl,
                            hint: '123',
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            maxLength: 3,
                            obscureText: true,
                            validator: (v) =>
                                (v == null || v.length < 3) ? 'Invalid' : null,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 48.h),

                // --- Save button ---
                CustomButton(
                  text: widget.isPaymentFlow ? 'Pay Now' : 'Save',
                  onPressed: _saveCard,
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
// Reused Internal Widgets (adapted from OnlinePaymentView for better encapsulation)
// ---------------------------------------------------------------------------

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text, style: FontManager.labelMedium(color: AppColors.white));
  }
}

class _CardTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData? prefixIcon;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;
  final bool obscureText;
  final String? Function(String?)? validator;

  const _CardTextField({
    required this.controller,
    required this.hint,
    this.prefixIcon,
    required this.keyboardType,
    this.inputFormatters,
    this.maxLength,
    this.obscureText = false,
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

class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(' ', '');
    final buffer = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      if (i > 0 && i % 4 == 0) buffer.write(' ');
      buffer.write(digits[i]);
    }
    final formatted = buffer.toString();
    return newValue.copyWith(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class _ExpiryFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll('/', '');
    if (digits.length <= 2) {
      return newValue.copyWith(
        text: digits,
        selection: TextSelection.collapsed(offset: digits.length),
      );
    }
    final formatted = '${digits.substring(0, 2)}/${digits.substring(2)}';
    return newValue.copyWith(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}