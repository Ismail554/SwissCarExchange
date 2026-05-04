import 'package:flutter/material.dart';
import 'package:rionydo/models/subscription/subscription_plan.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:rionydo/app_utils/constants/global_state.dart';
import 'package:rionydo/app_utils/utils/app_colors.dart';
import 'package:rionydo/app_utils/utils/app_spacing.dart';
import 'package:rionydo/controllers/subscription_provider.dart';
import 'package:rionydo/core/widgets/common_background.dart';
import 'package:rionydo/core/widgets/widget_snackbar.dart';
import 'package:rionydo/models/profile/user_profile_response.dart';
import 'package:rionydo/views/auth/sign_up/verify_sign_up/presentations/checkout_webview.dart';
import 'package:rionydo/views/auth/sign_up/verify_sign_up/widget/widget_common_top_logocard.dart';
import 'package:rionydo/views/auth/sign_up/verify_sign_up/widget/widget_premium_card.dart';

class SubscriptionView extends StatefulWidget {
  const SubscriptionView({super.key});

  @override
  State<SubscriptionView> createState() => _SubscriptionViewState();
}

class _SubscriptionViewState extends State<SubscriptionView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SubscriptionProvider>().fetchPlans();
    });
  }

  Future<void> _onSelectPlan(String planId) async {
    final provider = context.read<SubscriptionProvider>();
    final checkoutUrl = await provider.checkout(planId);

    if (!mounted) return;

    if (checkoutUrl != null && checkoutUrl.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CheckoutWebView(checkoutUrl: checkoutUrl),
        ),
      );
    } else {
      AppSnackBar.error(
        context,
        provider.errorMessage ?? 'Failed to start checkout.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final subProvider = context.watch<SubscriptionProvider>();
    final userType = context.watch<GlobalState>().userType;

    // Filter plans: private → only "basic", company → all plans
    final visiblePlans = subProvider.plans.where((p) {
      if (userType == UserType.private) return p.plan == SubscriptionPlanId.basic;
      return true; // company sees all
    }).toList();

    return CommonBackground(
      child: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              AppSpacing.h24,
              const WidgetCommonTopLogocard(
                title: "Choose Your Plan",
                subtitle: "Select a subscription to get started",
              ),
              AppSpacing.h40,

              // Loading state
              if (subProvider.isLoading)
                Padding(
                  padding: EdgeInsets.only(top: 60.h),
                  child: const CircularProgressIndicator(
                    color: AppColors.sceTeal,
                  ),
                ),

              // Error state
              if (!subProvider.isLoading && subProvider.errorMessage != null)
                Padding(
                  padding: EdgeInsets.only(top: 40.h),
                  child: Column(
                    children: [
                      Text(
                        subProvider.errorMessage!,
                        style: TextStyle(
                          color: AppColors.grey,
                          fontSize: 14.sp,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      AppSpacing.h16,
                      TextButton(
                        onPressed: () =>
                            context.read<SubscriptionProvider>().fetchPlans(),
                        child: const Text(
                          'Retry',
                          style: TextStyle(color: AppColors.sceTeal),
                        ),
                      ),
                    ],
                  ),
                ),

              // Plans list
              if (!subProvider.isLoading && subProvider.errorMessage == null)
                ...visiblePlans.map((plan) {
                  final isPremiumPlan = plan.plan == SubscriptionPlanId.premium;
                  return Padding(
                    padding: EdgeInsets.only(bottom: 24.h),
                    child: WidgetPremiumCard(
                      title: plan.name,
                      price: plan.displayPrice,
                      period: '/ ${plan.interval}',
                      roleText: isPremiumPlan
                          ? 'Buyer + Seller Role'
                          : 'Buyer Role Only',
                      isPremium: isPremiumPlan,
                      features: isPremiumPlan
                          ? const [
                              'Everything in Basic',
                              'Create & publish auctions',
                              'Set reserve & buy now prices',
                              'Access performance analytics',
                            ]
                          : const [
                              'Browse all live auctions',
                              'Participate in live bidding',
                              'Use auto-bid agent',
                              'Track active & won bids',
                            ],
                      onSelect: subProvider.isCheckingOut
                          ? () {}
                          : () => _onSelectPlan(plan.plan),
                    ),
                  );
                }),

              // Checkout loading overlay
              if (subProvider.isCheckingOut)
                Padding(
                  padding: EdgeInsets.only(top: 16.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 20.w,
                        height: 20.w,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.sceTeal,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Text(
                        'Preparing checkout...',
                        style: TextStyle(
                          color: AppColors.grey,
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  ),
                ),

              AppSpacing.h40,
            ],
          ),
        ),
      ),
    );
  }
}
