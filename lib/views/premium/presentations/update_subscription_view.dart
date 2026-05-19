import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:rionydo/app_utils/constants/font_manager.dart';
import 'package:rionydo/app_utils/constants/global_state.dart';
import 'package:rionydo/app_utils/utils/app_colors.dart';
import 'package:rionydo/controllers/subscription_provider.dart';
import 'package:rionydo/core/widgets/common_background.dart';
import 'package:rionydo/core/widgets/custom_back_button.dart';
import 'package:rionydo/core/widgets/widget_snackbar.dart';
import 'package:rionydo/models/subscription/subscription_plan.dart';

class PremiumFeature {
  final String title;
  final String subtitle;
  final IconData icon;

  PremiumFeature({
    required this.title,
    required this.subtitle,
    required this.icon,
  });
}

class SubscriptionViews extends StatefulWidget {
  const SubscriptionViews({super.key});

  @override
  State<SubscriptionViews> createState() => _SubscriptionViewsState();
}

class _SubscriptionViewsState extends State<SubscriptionViews> {
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
      context.push('/checkout', extra: {'checkoutUrl': checkoutUrl});
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
    final isPremium = context.watch<GlobalState>().isPremium;

    // Retrieve premium plan, default/fallback if not loaded yet
    final premiumPlan = subProvider.plans.firstWhere(
      (p) => p.plan == SubscriptionPlanId.premium,
      orElse: () => const SubscriptionPlan(
        plan: SubscriptionPlanId.premium,
        name: 'Premium',
        price: '299',
        currency: 'chf',
        interval: 'month',
      ),
    );

    final List<PremiumFeature> features = [
      PremiumFeature(
        title: 'Create & Publish Auctions',
        subtitle: 'List cars and motorcycles\nfor auction',
        icon: Icons.inventory_2_outlined,
      ),
      PremiumFeature(
        title: 'Upload Multiple Assets',
        subtitle: 'Images, videos, VIN,\ninspection reports',
        icon: Icons.bolt,
      ),
      PremiumFeature(
        title: 'Set Pricing Options',
        subtitle: 'Reserve price, Buy Now,\nauction duration',
        icon: Icons.trending_up,
      ),
      PremiumFeature(
        title: 'Auction Management',
        subtitle: 'View bidders, track\nperformance, history',
        icon: Icons.shield_outlined,
      ),
      PremiumFeature(
        title: 'Advanced Statistics',
        subtitle: 'Win rate, sell-through rate,\navg sale price',
        icon: Icons.show_chart,
      ),
      PremiumFeature(
        title: 'Priority Listing & Notifications',
        subtitle: 'Featured placement &\npush notifications',
        icon: Icons.notifications_none_outlined,
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.sceDarkBg, // AppColors.sceDarkBg
      body: CommonBackground(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 4,
          leading: const CustomBackButton(),
          title: Text(
            'Subscription',
            style: FontManager.titleText(color: AppColors.white),
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Crown Icon with Glow
              Container(
                width: 90.w,
                height: 90.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.scePremiumGold, // Light Orange/Gold
                      AppColors.scePremiumOrange, // Darker Orange
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.scePremiumGlow.withValues(alpha: 0.3),
                      blurRadius: 40,
                      spreadRadius: 10,
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    Icons.workspace_premium_outlined,
                    color: Colors.white,
                    size: 48.w,
                  ),
                ),
              ),
              SizedBox(height: 24.h),

              // Header Texts
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: 'Upgrade to ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28.sp,
                    fontWeight: FontWeight.w800,
                  ),
                  children: const [
                    TextSpan(
                      text: 'Premium',
                      style: TextStyle(
                        color: AppColors.scePremiumGold, // Gold
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Unlock dealer features & start selling',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.sceGrey99,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 32.h),

              // Pricing Card Section
              if (subProvider.isLoading)
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 36.h),
                  decoration: BoxDecoration(
                    color: AppColors.sceDarkBg,
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(
                      color: AppColors.scePremiumDealerBg.withValues(alpha: 0.3),
                      width: 1.5,
                    ),
                  ),
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.scePremiumGold,
                    ),
                  ),
                )
              else if (subProvider.errorMessage != null)
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(
                    color: AppColors.sceDarkBg,
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(
                      color: Colors.redAccent.withValues(alpha: 0.3),
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.error_outline_outlined,
                        color: Colors.redAccent,
                        size: 32.w,
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        subProvider.errorMessage!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.greyD9,
                          fontSize: 14.sp,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      OutlinedButton.icon(
                        onPressed: () => context.read<SubscriptionProvider>().fetchPlans(),
                        icon: const Icon(Icons.refresh_outlined, color: AppColors.scePremiumGold),
                        label: const Text(
                          'Retry',
                          style: TextStyle(color: AppColors.scePremiumGold),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: AppColors.scePremiumGold.withValues(alpha: 0.5)),
                        ),
                      ),
                    ],
                  ),
                )
              else
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 24.h),
                  decoration: BoxDecoration(
                    color: AppColors.sceDarkBg,
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(
                      color: AppColors.scePremiumDealerBg, // Dark Gold
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.scePremiumDealerBg.withValues(alpha: 0.5),
                        blurRadius: 20,
                        spreadRadius: -5,
                        offset: const Offset(0, 0),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        'DEALER SUBSCRIPTION',
                        style: FontManager.labelSmall(
                          color: AppColors.scePremiumGold,
                        ).copyWith(
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            premiumPlan.price,
                            style: FontManager.heading2(
                              color: AppColors.scePremiumGold,
                            ).copyWith(fontSize: 48.sp),
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            premiumPlan.currency.toUpperCase(),
                            style: FontManager.heading2(
                              color: AppColors.sceGrey99,
                            ).copyWith(fontSize: 20.sp),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'per ${premiumPlan.interval}',
                        style: TextStyle(
                          color: AppColors.sceGrey99,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      if (isPremium) ...[
                        SizedBox(height: 12.h),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                          decoration: BoxDecoration(
                            color: AppColors.sceTeal.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(20.r),
                            border: Border.all(color: AppColors.sceTeal.withValues(alpha: 0.3)),
                          ),
                          child: Text(
                            'ACTIVE PLAN',
                            style: TextStyle(
                              color: AppColors.sceTeal,
                              fontSize: 11.sp,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              SizedBox(height: 32.h),

              // Features List Title
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'PREMIUM FEATURES',
                  style: FontManager.labelSmall(
                    color: AppColors.greyD4,
                  ).copyWith(letterSpacing: 1.0, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 16.h),

              // Features List
              ...features.map(
                (feature) => Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 16.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.sceCardBg.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 44.w,
                          height: 44.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.scePremiumGold.withValues(alpha: 0.15),
                          ),
                          child: Center(
                            child: Icon(
                              feature.icon,
                              color: AppColors.scePremiumGold,
                              size: 24.w,
                            ),
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                feature.title,
                                style: FontManager.labelMedium(
                                  color: Colors.white,
                                ).copyWith(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                feature.subtitle,
                                style: FontManager.labelSmall(
                                  color: AppColors.sceGrey99,
                                ).copyWith(height: 1.4),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.check,
                          color: AppColors.sceTeal, // sceTeal
                          size: 24.w,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(height: 32.h),

              // Upgrade Button
              GestureDetector(
                onTap: isPremium || subProvider.isCheckingOut || subProvider.isLoading || subProvider.errorMessage != null
                    ? null
                    : () => _onSelectPlan(premiumPlan.plan),
                child: Container(
                  width: double.maxFinite,
                  height: 56.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    gradient: isPremium || subProvider.isLoading || subProvider.errorMessage != null
                        ? null
                        : const LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              AppColors.scePremiumGold, // Gold
                              AppColors.scePremiumOrange, // Orange
                            ],
                          ),
                    color: isPremium || subProvider.isLoading || subProvider.errorMessage != null
                        ? AppColors.sceCardBg.withValues(alpha: 0.5)
                        : null,
                    border: isPremium
                        ? Border.all(color: AppColors.scePremiumGold.withValues(alpha: 0.3))
                        : (subProvider.isLoading || subProvider.errorMessage != null
                            ? Border.all(color: AppColors.sceGrey99.withValues(alpha: 0.2))
                            : null),
                    boxShadow: isPremium || subProvider.isLoading || subProvider.errorMessage != null
                        ? null
                        : [
                            BoxShadow(
                              color: AppColors.scePremiumOrange.withValues(alpha: 0.3),
                              blurRadius: 15,
                              offset: const Offset(0, 4),
                            ),
                          ],
                  ),
                  child: Center(
                    child: subProvider.isCheckingOut
                        ? SizedBox(
                            width: 24.w,
                            height: 24.w,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            isPremium
                                ? 'Your Active Plan'
                                : (subProvider.errorMessage != null
                                    ? 'Error loading plans'
                                    : 'Upgrade to Premium'),
                            style: FontManager.labelMedium(
                              color: isPremium
                                  ? AppColors.scePremiumGold
                                  : (subProvider.errorMessage != null || subProvider.isLoading
                                      ? AppColors.sceGrey99
                                      : Colors.white),
                            ).copyWith(fontWeight: FontWeight.bold),
                          ),
                  ),
                ),
              ),
              SizedBox(height: 16.h),

              // Footer Text
              Text(
                'Cancel anytime. Terms and conditions apply.',
                textAlign: TextAlign.center,
                style: FontManager.labelSmall(
                  color: AppColors.grey,
                ).copyWith(fontWeight: FontWeight.w400),
              ),
              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }
}
