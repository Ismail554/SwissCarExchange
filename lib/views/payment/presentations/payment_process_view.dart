import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:rionydo/views/profile/presentations/transaction_completed_view.dart';
import 'package:shimmer/shimmer.dart';
import 'package:rionydo/app_utils/constants/font_manager.dart';
import 'package:rionydo/app_utils/utils/app_colors.dart';
import 'package:rionydo/app_utils/utils/app_spacing.dart';
import 'package:rionydo/core/widgets/custom_back_button.dart';
import 'package:rionydo/core/widgets/custom_button.dart';
import 'package:rionydo/core/widgets/widget_snackbar.dart';
import 'package:rionydo/controllers/payment_process_provider.dart';
import 'package:rionydo/views/won_auction/widgets/left_days_widget.dart';

class PaymentProcessView extends StatefulWidget {
  final String auctionId;
  final int initialStep;

  const PaymentProcessView({
    super.key,
    required this.auctionId,
    this.initialStep = 0,
  });

  @override
  State<PaymentProcessView> createState() => _PaymentProcessViewState();
}

class _PaymentProcessViewState extends State<PaymentProcessView> {
  int _currentStep = 0; // 0: Payment, 1: Shipping Method, 2: Mark Received
  String _selectedShippingMethod = 'local_pickup';

  @override
  void initState() {
    super.initState();
    _currentStep = widget.initialStep;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PaymentProcessProvider>().fetchPaymentInfo(widget.auctionId);
    });
  }

  void _nextStep() {
    setState(() {
      _currentStep++;
    });
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
          'Transaction Process',
          style: FontManager.heading2(color: AppColors.white),
        ),
      ),
      body: Consumer<PaymentProcessProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.paymentInfo == null) {
            return _buildShimmerLoading();
          }

          if (provider.error != null && provider.paymentInfo == null) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.error_outline,
                    color: AppColors.errorRed,
                    size: 48.sp,
                  ),
                  AppSpacing.h16,
                  Text(
                    provider.error!,
                    style: FontManager.bodyMedium(color: AppColors.white),
                  ),
                  AppSpacing.h16,
                  CustomButton(
                    text: 'Retry',
                    onPressed: () {
                      provider.fetchPaymentInfo(widget.auctionId);
                    },
                  ),
                ],
              ),
            );
          }

          if (provider.paymentAlreadyProcessed && _currentStep == 0) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                setState(() {
                  _currentStep = 1;
                });
              }
            });
          }

          if (provider.paymentInfo == null &&
              !provider.paymentAlreadyProcessed) {
            return const SizedBox.shrink();
          }

          return SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStepper(),
                  AppSpacing.h32,
                  if (_currentStep == 0 && provider.paymentInfo != null)
                    _buildPaymentStep(provider),
                  if (_currentStep == 1) _buildShippingStep(provider),
                  if (_currentStep == 2) _buildReceivedStep(provider),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStepper() {
    return Row(
      children: [
        _buildStepIndicator(0, 'Payment'),
        _buildStepLine(0),
        _buildStepIndicator(1, 'Shipping'),
        _buildStepLine(1),
        _buildStepIndicator(2, 'Received'),
      ],
    );
  }

  Widget _buildStepIndicator(int stepIndex, String title) {
    final isActive = _currentStep >= stepIndex;
    return Column(
      children: [
        Container(
          width: 32.w,
          height: 32.w,
          decoration: BoxDecoration(
            color: isActive ? AppColors.sceTeal : AppColors.sceCardBg,
            shape: BoxShape.circle,
            border: Border.all(
              color: isActive
                  ? AppColors.sceTeal
                  : AppColors.sceGreyA0.withValues(alpha: 0.3),
            ),
          ),
          child: Center(
            child: isActive
                ? Icon(Icons.check, color: AppColors.white, size: 16.sp)
                : Text(
                    '${stepIndex + 1}',
                    style: FontManager.bodySmall(color: AppColors.sceGreyA0),
                  ),
          ),
        ),
        AppSpacing.h8,
        Text(
          title,
          style: FontManager.labelMedium(
            color: isActive ? AppColors.white : AppColors.sceGreyA0,
          ),
        ),
      ],
    );
  }

  Widget _buildStepLine(int stepIndex) {
    final isActive = _currentStep > stepIndex;
    return Expanded(
      child: Container(
        height: 2.h,
        color: isActive ? AppColors.sceTeal : AppColors.sceCardBg,
        margin: EdgeInsets.symmetric(horizontal: 8.w).copyWith(bottom: 24.h),
      ),
    );
  }

  Widget _buildPaymentStep(PaymentProcessProvider provider) {
    final info = provider.paymentInfo!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'PAYMENT DETAILS',
          style: FontManager.labelMedium(color: AppColors.sceGreyA0),
        ),
        AppSpacing.h12,
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
                      info.bankName.isNotEmpty ? info.bankName : 'Seller Bank',
                      style: FontManager.heading3(color: AppColors.white),
                    ),
                  ),
                ],
              ),
              AppSpacing.h20,
              _buildDetailRow("Amount", "${info.currency} ${info.amount}"),
              AppSpacing.h12,
              _buildDetailRow("Account Name", info.accountName),
              AppSpacing.h12,
              _buildDetailRow("IBAN", info.iban),
            ],
          ),
        ),
        AppSpacing.h40,
        if (info.paymentDeadline != null) ...[
          LeftDaysWidget(deadline: info.paymentDeadline!),
          AppSpacing.h16,
        ],
        provider.isLoading
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.sceTeal),
              )
            : (info.paymentDeadline != null &&
                  info.paymentDeadline!.isBefore(DateTime.now()))
            ? const SizedBox.shrink()
            : CustomButton(
                text: "I've made the payment",
                onPressed: () async {
                  final success = await provider.markPayment(widget.auctionId);
                  if (success && mounted) {
                    AppSnackBar.success(context, "Payment marked successfully");
                    _nextStep();
                  } else if (provider.error != null && mounted) {
                    AppSnackBar.error(context, provider.error!);
                  }
                },
              ),
      ],
    );
  }

  Widget _buildShippingStep(PaymentProcessProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'CHOOSE DELIVERY METHOD',
          style: FontManager.labelMedium(color: AppColors.sceGreyA0),
        ),
        AppSpacing.h12,
        _DeliveryMethodCard(
          title: 'Local Pickup',
          subtitle: "Pick up vehicle at seller's location",
          icon: Icons.inventory_2_outlined,
          isSelected: _selectedShippingMethod == 'local_pickup',
          onTap: () {
            setState(() {
              _selectedShippingMethod = 'local_pickup';
            });
          },
        ),
        AppSpacing.h12,
        _DeliveryMethodCard(
          title: 'Shipping',
          subtitle: 'Arrange vehicle shipping with seller',
          icon: Icons.local_shipping_outlined,
          isSelected: _selectedShippingMethod == 'shipping',
          onTap: () {
            setState(() {
              _selectedShippingMethod = 'shipping';
            });
          },
        ),
        AppSpacing.h40,
        provider.isLoading
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.sceTeal),
              )
            : CustomButton(
                text: 'Confirm Delivery Method',
                onPressed: () async {
                  final success = await provider.chooseShipping(
                    widget.auctionId,
                    _selectedShippingMethod,
                  );
                  if (success && mounted) {
                    AppSnackBar.success(context, "Delivery method confirmed");
                    _nextStep();
                  } else if (provider.error != null && mounted) {
                    AppSnackBar.error(context, provider.error!);
                  }
                },
              ),
      ],
    );
  }

  Widget _buildReceivedStep(PaymentProcessProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'MARK AS COMPLETED',
          style: FontManager.labelMedium(color: AppColors.sceGreyA0),
        ),
        AppSpacing.h12,
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
                    Icons.check_circle_outline,
                    color: AppColors.sceTeal,
                    size: 24.sp,
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      'Transaction Finalization',
                      style: FontManager.heading3(color: AppColors.white),
                    ),
                  ),
                ],
              ),
              AppSpacing.h12,
              Text(
                'By marking shipping as complete, you confirm that you have received the vehicle and the transaction is finalized.',
                style: FontManager.bodyMedium(color: AppColors.sceGreyA0),
              ),
            ],
          ),
        ),
        AppSpacing.h40,
        provider.isLoading
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.sceTeal),
              )
            : Container(
                width: double.infinity,
                height: 54.h,
                decoration: BoxDecoration(
                  color: const Color(0xFF0F1B1A), // Dark teal tint
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: AppColors.sceTeal.withValues(alpha: 0.3),
                  ),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12.r),
                    onTap: () async {
                      final success = await provider.markShipping(
                        widget.auctionId,
                      );
                      if (success && mounted) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TransactionCompletedView(
                              auctionId: widget.auctionId,
                            ),
                          ),
                        );
                      } else if (provider.error != null && mounted) {
                        AppSnackBar.error(context, provider.error!);
                      }
                    },
                    child: Center(
                      child: Text(
                        'Mark Shipping as Complete',
                        style: FontManager.buttonText(color: AppColors.sceTeal),
                      ),
                    ),
                  ),
                ),
              ),
      ],
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
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Shimmer.fromColors(
            baseColor: AppColors.sceCardBg.withValues(alpha: 0.6),
            highlightColor: AppColors.grey.withValues(alpha: 0.15),
            child: Container(
              width: double.infinity,
              height: 150.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
              ),
            ),
          ),
          AppSpacing.h32,
          Shimmer.fromColors(
            baseColor: AppColors.sceCardBg.withValues(alpha: 0.6),
            highlightColor: AppColors.grey.withValues(alpha: 0.15),
            child: Container(
              width: double.infinity,
              height: 54.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DeliveryMethodCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _DeliveryMethodCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.sceTeal.withValues(alpha: 0.1)
              : AppColors.sceCardBg,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected
                ? AppColors.sceTeal
                : AppColors.white.withValues(alpha: 0.05),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: AppColors.white.withValues(alpha: 0.05),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isSelected ? AppColors.sceTeal : AppColors.white,
                size: 24.sp,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: FontManager.bodyMedium(
                      color: AppColors.white,
                    ).copyWith(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    subtitle,
                    style: FontManager.bodySmall(color: AppColors.sceGreyA0),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle, color: AppColors.sceTeal, size: 24.sp),
          ],
        ),
      ),
    );
  }
}
