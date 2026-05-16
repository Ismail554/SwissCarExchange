import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:rionydo/app_utils/constants/font_manager.dart';
import 'package:rionydo/app_utils/utils/app_colors.dart';
import 'package:rionydo/core/widgets/custom_back_button.dart';
import 'package:rionydo/core/widgets/custom_button.dart';
import 'package:rionydo/core/widgets/widget_snackbar.dart';
import 'package:rionydo/controllers/bank_account_provider.dart';


/// Screen to collect Switzerland offline bank transfer information (IBAN/SEPA).
class PaymentMethodView extends StatefulWidget {
  final bool isPaymentFlow;
  final String? auctionId;

  const PaymentMethodView({
    super.key,
    this.isPaymentFlow = false,
    this.auctionId,
  });

  @override
  State<PaymentMethodView> createState() => _PaymentMethodViewState();
}

class _PaymentMethodViewState extends State<PaymentMethodView> {
  final _formKey = GlobalKey<FormState>();
  final _accountHolderCtrl = TextEditingController();
  final _ibanCtrl = TextEditingController();
  final _bankNameCtrl = TextEditingController();
  final _swiftCtrl = TextEditingController();

  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BankAccountProvider>().fetchBankDetails();
    });
  }

  @override
  void dispose() {
    _accountHolderCtrl.dispose();
    _ibanCtrl.dispose();
    _bankNameCtrl.dispose();
    _swiftCtrl.dispose();
    super.dispose();
  }

  void _populateForm(BankAccountProvider provider) {
    if (provider.bankAccount != null) {
      _accountHolderCtrl.text = provider.bankAccount!.accountName;
      _ibanCtrl.text = provider.bankAccount!.iban;
      _bankNameCtrl.text = provider.bankAccount!.bankName;
    }
  }

  Future<void> _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      final provider = context.read<BankAccountProvider>();
      final body = {
        "bank_name": _bankNameCtrl.text.trim(),
        "account_name": _accountHolderCtrl.text.trim(),
        "iban": _ibanCtrl.text.trim(),
      };

      bool success;
      if (_isEditing && provider.bankAccount != null) {
        success = await provider.modifyBankDetails(body);
      } else {
        success = await provider.addBankDetails(body);
      }

      if (success && mounted) {
        AppSnackBar.success(context, "Bank details saved successfully!");
        if (widget.isPaymentFlow) {
          context.push('/pay-successful', extra: {'nextRoute': '/auction-contact/${widget.auctionId}'});
        } else {
          setState(() {
            _isEditing = false;
          });
        }
      } else if (provider.errorMessage != null && mounted) {
        AppSnackBar.error(context, provider.errorMessage!);
      }
    }
  }

  void _confirmDelete(BankAccountProvider provider) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.sceCardBg,
        title: Text(
          "Delete Bank Details",
          style: FontManager.heading3(color: AppColors.white),
        ),
        content: Text(
          "Are you sure you want to delete your saved bank details?",
          style: FontManager.bodyMedium(color: AppColors.sceGreyA0),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              "Cancel",
              style: FontManager.bodyMedium(color: AppColors.white),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final success = await provider.deleteBankDetails();
              if (success && mounted) {
                AppSnackBar.success(context, "Bank details deleted.");
                // Reset text controllers
                _accountHolderCtrl.clear();
                _ibanCtrl.clear();
                _bankNameCtrl.clear();
                _swiftCtrl.clear();
              } else if (provider.errorMessage != null && mounted) {
                AppSnackBar.error(context, provider.errorMessage!);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.errorRed,
            ),
            child: Text(
              "Delete",
              style: FontManager.bodyMedium(color: AppColors.white),
            ),
          ),
        ],
      ),
    );
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
      body: Consumer<BankAccountProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return _buildShimmerLoading();
          }

          // Show existing bank info if available and not in editing mode
          if (provider.bankAccount != null && !_isEditing) {
            return _buildExistingBankInfo(provider);
          }

          // Otherwise show the form
          return _buildForm(provider);
        },
      ),
    );
  }

  Widget _buildExistingBankInfo(BankAccountProvider provider) {
    final account = provider.bankAccount!;
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _InfoBanner(
              icon: Icons.account_balance_rounded,
              message: widget.isPaymentFlow
                  ? 'Your saved bank details will be used for this transfer.'
                  : 'Your saved Swiss bank details for offline IBAN/SEPA transfers.',
            ),
            SizedBox(height: 28.h),
            Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: AppColors.sceCardBg,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.account_balance_outlined,
                        color: AppColors.sceTeal,
                        size: 24.sp,
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Text(
                          account.bankName,
                          style: FontManager.heading3(color: AppColors.white),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  _buildDetailRow("Account Holder", account.accountName),
                  SizedBox(height: 12.h),
                  _buildDetailRow("IBAN", account.iban),
                ],
              ),
            ),
            SizedBox(height: 40.h),
            if (widget.isPaymentFlow) ...[
              CustomButton(
                text: 'Confirm Transfer with these details',
                onPressed: () {
                  context.push('/pay-successful', extra: {'nextRoute': '/auction-contact/${widget.auctionId}'});
                },
              ),
              SizedBox(height: 20.h),
            ],
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      _populateForm(provider);
                      setState(() {
                        _isEditing = true;
                      });
                    },
                    icon: Icon(
                      Icons.edit_rounded,
                      size: 18.sp,
                      color: AppColors.white,
                    ),
                    label: Text(
                      "Modify",
                      style: FontManager.bodyMedium(color: AppColors.white),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      side: BorderSide(color: AppColors.grey.withValues(alpha: 0.3)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: provider.isSaving
                        ? null
                        : () => _confirmDelete(provider),
                    icon: Icon(
                      Icons.delete_outline_rounded,
                      size: 18.sp,
                      color: AppColors.errorRed,
                    ),
                    label: Text(
                      "Delete",
                      style: FontManager.bodyMedium(color: AppColors.errorRed),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      side: BorderSide(
                        color: AppColors.errorRed.withValues(alpha: 0.3),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: FontManager.labelMedium(color: AppColors.sceGreyA0)),
        SizedBox(height: 4.h),
        Text(value, style: FontManager.bodyLarge(color: AppColors.white)),
      ],
    );
  }

  Widget _buildShimmerLoading() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner Shimmer
            _buildShimmerBox(
              width: double.infinity,
              height: 60.h,
              borderRadius: BorderRadius.circular(12.r),
            ),
            SizedBox(height: 28.h),
            // Card Shimmer
            Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: AppColors.sceCardBg,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _buildShimmerBox(
                        width: 24.w,
                        height: 24.h,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      SizedBox(width: 12.w),
                      _buildShimmerBox(
                        width: 150.w,
                        height: 20.h,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ],
                  ),
                  SizedBox(height: 24.h),
                  _buildShimmerDetailItem(),
                  SizedBox(height: 16.h),
                  _buildShimmerDetailItem(),
                ],
              ),
            ),
            SizedBox(height: 40.h),
            // Buttons Shimmer
            Row(
              children: [
                Expanded(
                  child: _buildShimmerBox(
                    height: 48.h,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: _buildShimmerBox(
                    height: 48.h,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerDetailItem() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildShimmerBox(
          width: 100.w,
          height: 12.h,
          borderRadius: BorderRadius.circular(3.r),
        ),
        SizedBox(height: 6.h),
        _buildShimmerBox(
          width: 200.w,
          height: 16.h,
          borderRadius: BorderRadius.circular(4.r),
        ),
      ],
    );
  }

  Widget _buildShimmerBox({
    double? width,
    required double height,
    BorderRadius? borderRadius,
  }) {
    return Shimmer.fromColors(
      baseColor: AppColors.sceCardBg.withValues(alpha: 0.6),
      highlightColor: AppColors.grey.withValues(alpha: 0.15),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: borderRadius ?? BorderRadius.circular(8.r),
        ),
      ),
    );
  }

  Widget _buildForm(BankAccountProvider provider) {
    return SafeArea(
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
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Enter bank name' : null,
              ),
              SizedBox(height: 18.h),

              // --- SWIFT/BIC (optional) ---
              const _FieldLabel('SWIFT / BIC Code (Optional)'),

              // SizedBox(height: 8.h),
              // _BankTextField(
              //   controller: _swiftCtrl,
              //   hint: 'e.g. UBSWCHZH80A',
              //   prefixIcon: Icons.code_rounded,
              //   keyboardType: TextInputType.text,
              //   inputFormatters: [
              //     FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9]')),
              //     LengthLimitingTextInputFormatter(11),
              //   ],
              //   textCapitalization: TextCapitalization.characters,
              //   validator: (v) {
              //     if (v == null || v.trim().isEmpty) return null; // optional
              //     final len = v.trim().length;
              //     if (len != 8 && len != 11) {
              //       return 'SWIFT/BIC must be 8 or 11 characters';
              //     }
              //     return null;
              //   },
              // ),
              SizedBox(height: 12.h),

              // --- Security note ---
              _SecurityNote(),

              SizedBox(height: 40.h),

              // --- Submit button ---
              provider.isSaving
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.sceTeal,
                      ),
                    )
                  : CustomButton(
                      text: _isEditing
                          ? 'Update Bank Details'
                          : (widget.isPaymentFlow
                                ? 'Confirm Transfer Details'
                                : 'Save Bank Details'),
                      onPressed: _submit,
                    ),
              SizedBox(height: 20.h),
              if (_isEditing)
                Center(
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        _isEditing = false;
                      });
                    },
                    child: Text(
                      "Cancel Edit",
                      style: FontManager.bodyMedium(color: AppColors.white),
                    ),
                  ),
                ),
            ],
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
        color: AppColors.sceTeal.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.sceTeal.withValues(alpha: 0.3)),
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
  final TextCapitalization textCapitalization;
  final String? Function(String?)? validator;

  const _BankTextField({
    required this.controller,
    required this.hint,
    this.prefixIcon,
    required this.keyboardType,
    this.inputFormatters,
    this.maxLength,
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
      textCapitalization: textCapitalization,
      validator: validator,
      style: FontManager.bodyMedium(color: AppColors.white),
      buildCounter:
          (_, {required currentLength, required isFocused, maxLength}) =>
              const SizedBox.shrink(),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: FontManager.bodyMedium(
          color: AppColors.grey.withValues(alpha: 0.5),
        ),
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, color: AppColors.grey, size: 20.sp)
            : null,
        filled: true,
        fillColor: AppColors.sceCardBg,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: AppColors.grey.withValues(alpha: 0.2)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: AppColors.grey.withValues(alpha: 0.2)),
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
