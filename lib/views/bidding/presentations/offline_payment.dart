import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rionydo/core/constants/font_manager.dart';
import 'package:rionydo/core/utils/app_colors.dart';
import 'package:rionydo/core/widgets/custom_back_button.dart';
import 'package:rionydo/core/widgets/custom_button.dart';
import 'package:rionydo/views/bidding/presentations/pay_successful.dart';

// ---------------------------------------------------------------------------
// Static bank detail model
// ---------------------------------------------------------------------------

class _BankDetail {
  final String label;
  final String value;
  final bool isTeal; // highlight IBAN in teal

  const _BankDetail({
    required this.label,
    required this.value,
    this.isTeal = false,
  });
}

// ---------------------------------------------------------------------------
// Offline (Bank Transfer) payment screen
// ---------------------------------------------------------------------------

class OfflinePaymentView extends StatelessWidget {
  final String carName;
  final String amount;

  /// Reference number is auto-generated per transaction.
  /// In a real app this comes from the backend.
  final String referenceNumber;

  const OfflinePaymentView({
    super.key,
    required this.carName,
    required this.amount,
    this.referenceNumber = '3',
  });

  static const List<_BankDetail> _bankDetails = [
    _BankDetail(label: 'Bank Name', value: 'UBS Switzerland AG'),
    _BankDetail(label: 'Account Name', value: 'SwissCarExchange AG'),
    _BankDetail(
      label: 'IBAN',
      value: 'CH93 0076 2011 6238 5295 7',
      isTeal: true,
    ),
    _BankDetail(label: 'SWIFT/BIC', value: 'UBSWCHZH80A'),
  ];

  void _copyToClipboard(BuildContext context, String value) {
    Clipboard.setData(ClipboardData(text: value));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Copied to clipboard',
          style: FontManager.bodySmall(color: AppColors.white),
        ),
        backgroundColor: AppColors.sceTeal.withOpacity(0.85),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Payment summary ---
              _PaymentSummaryCard(carName: carName, amount: amount),
              SizedBox(height: 20.h),

              // --- Bank details card ---
              _BankDetailsCard(
                bankDetails: _bankDetails,
                referenceNumber: referenceNumber,
                onCopy: (value) => _copyToClipboard(context, value),
              ),
              SizedBox(height: 20.h),

              // --- Warning box ---
              _WarningBox(referenceNumber: referenceNumber),
              SizedBox(height: 32.h),

              // --- CTA button ---
              CustomButton(
                text: "I've Made the Transfer",
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PaySuccessful()),
                ),
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Payment summary card
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
// Bank details card
// ---------------------------------------------------------------------------

class _BankDetailsCard extends StatelessWidget {
  final List<_BankDetail> bankDetails;
  final String referenceNumber;
  final void Function(String value) onCopy;

  const _BankDetailsCard({
    required this.bankDetails,
    required this.referenceNumber,
    required this.onCopy,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
      decoration: BoxDecoration(
        color: AppColors.sceCardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.grey.withOpacity(0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card header
          Row(
            children: [
              Icon(
                Icons.account_balance_rounded,
                color: AppColors.sceGold,
                size: 18.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                'Bank Transfer Details',
                style: FontManager.bodyMedium(color: AppColors.white),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // Bank detail rows
          ...bankDetails.map(
            (detail) => _BankDetailRow(
              label: detail.label,
              value: detail.value,
              isTeal: detail.isTeal,
              onCopy: () => onCopy(detail.value),
            ),
          ),

          // Reference number row (uses sceGold)
          _BankDetailRow(
            label: 'Reference Number',
            value: referenceNumber,
            valueColor: AppColors.sceGold,
            onCopy: () => onCopy(referenceNumber),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Single bank detail row
// ---------------------------------------------------------------------------

class _BankDetailRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isTeal;
  final Color? valueColor;
  final VoidCallback onCopy;

  const _BankDetailRow({
    required this.label,
    required this.value,
    this.isTeal = false,
    this.valueColor,
    required this.onCopy,
  });

  @override
  Widget build(BuildContext context) {
    final resolvedColor =
        valueColor ?? (isTeal ? AppColors.sceTeal : AppColors.white);

    return Padding(
      padding: EdgeInsets.only(bottom: 14.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: FontManager.labelSmall(color: AppColors.grey)),
          SizedBox(height: 4.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  value,
                  style: FontManager.bodyMedium(color: resolvedColor),
                ),
              ),
              GestureDetector(
                onTap: onCopy,
                child: Icon(
                  Icons.copy_rounded,
                  color: AppColors.grey,
                  size: 18.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Divider(color: AppColors.grey.withOpacity(0.12), height: 1),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Warning box
// ---------------------------------------------------------------------------

class _WarningBox extends StatelessWidget {
  final String referenceNumber;

  const _WarningBox({required this.referenceNumber});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColors.sceGold.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.sceGold.withOpacity(0.35)),
      ),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Important: ',
              style: FontManager.labelSmall(color: AppColors.sceGold),
            ),
            TextSpan(
              text:
                  'Please include the reference number in your bank transfer to ensure proper processing.',
              style: FontManager.labelSmall(
                color: AppColors.sceGold.withOpacity(0.85),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
