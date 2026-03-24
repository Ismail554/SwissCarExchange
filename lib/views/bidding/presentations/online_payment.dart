import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rionydo/core/constants/font_manager.dart';
import 'package:rionydo/core/utils/app_colors.dart';
import 'package:rionydo/core/widgets/custom_back_button.dart';
import 'package:rionydo/core/widgets/custom_button.dart';
import 'package:rionydo/views/bidding/presentations/pay_successful.dart';

/// Card (online) payment screen.
/// Receives the [carName] and [amount] from the payment option sheet.
class OnlinePaymentView extends StatefulWidget {
  final String carName;
  final String amount;

  const OnlinePaymentView({
    super.key,
    required this.carName,
    required this.amount,
  });

  @override
  State<OnlinePaymentView> createState() => _OnlinePaymentViewState();
}

class _OnlinePaymentViewState extends State<OnlinePaymentView> {
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

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const PaySuccessful()),
      );
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
          'Card Payment',
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
                // --- Payment summary card ---
                _PaymentSummaryCard(
                  carName: widget.carName,
                  amount: widget.amount,
                ),
                SizedBox(height: 28.h),

                // --- Card Number ---
                _FieldLabel('Card Number'),
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
                _FieldLabel('Cardholder Name'),
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
                          _FieldLabel('Expiry Date'),
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
                          _FieldLabel('CVV'),
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
                SizedBox(height: 36.h),

                // --- Pay button ---
                CustomButton(text: 'Pay ${widget.amount}', onPressed: _submit),
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
// Payment summary card (top teal box)
// ---------------------------------------------------------------------------

class _PaymentSummaryCard extends StatelessWidget {
  final String carName;
  final String amount;

  const _PaymentSummaryCard({required this.carName, required this.amount});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
      decoration: BoxDecoration(
        color: AppColors.sceTeal.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.sceTeal.withOpacity(0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Payment For',
            style: FontManager.labelSmall(color: AppColors.grey),
          ),
          SizedBox(height: 6.h),
          Text(carName, style: FontManager.bodyMedium(color: AppColors.white)),
          SizedBox(height: 14.h),
          Row(
            children: [
              Text(
                'Total Amount: ',
                style: FontManager.labelMedium(color: AppColors.grey),
              ),
              Text(
                amount,
                style: FontManager.heading2(color: AppColors.sceTeal),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Field label
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
// Reusable card text field
// ---------------------------------------------------------------------------

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
        fillColor: const Color(0xFF111827),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.grey.withOpacity(0.2)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.grey.withOpacity(0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.sceTeal, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Input formatters
// ---------------------------------------------------------------------------

/// Formats raw digits as: 1234 5678 9012 3456
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

/// Formats raw digits as: MM/YY
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
