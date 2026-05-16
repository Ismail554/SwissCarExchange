import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:rionydo/app_utils/constants/global_state.dart';
import 'package:rionydo/controllers/subscription_provider.dart';
import 'package:rionydo/core/widgets/common_background.dart';
import 'package:rionydo/core/widgets/widget_snackbar.dart';
import 'package:rionydo/models/profile/user_profile_response.dart';
import 'package:rionydo/models/subscription/subscription_plan.dart';
import 'package:rionydo/views/auth/sign_up/verify_sign_up/presentations/checkout_webview.dart';

// ─── View ─────────────────────────────────────────────────────────────────────

class AccountSubscriptionView extends StatefulWidget {
  const AccountSubscriptionView({super.key});

  @override
  State<AccountSubscriptionView> createState() =>
      _AccountSubscriptionViewState();
}

class _AccountSubscriptionViewState extends State<AccountSubscriptionView> {
  bool _isActionLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
  }

  Future<void> _loadData() async {
    final provider = context.read<SubscriptionProvider>();
    await Future.wait([
      provider.fetchPlans(),
      provider.fetchMySubscription(),
    ]);
  }

  /// Upgrade: company basic → premium via Stripe checkout.
  Future<void> _handleUpgrade() async {
    final userType = context.read<GlobalState>().userType;

    // §9 Access Matrix: Private users cannot purchase Premium
    if (userType == UserType.private) {
      if (mounted) {
        AppSnackBar.warning(context, 'Premium is available for company accounts only.');
      }
      return;
    }

    final provider = context.read<SubscriptionProvider>();
    final checkoutUrl = await provider.checkout(SubscriptionPlanId.premium);

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

  /// Downgrade: premium → basic (placeholder until backend endpoint exists).
  Future<void> _handleDowngrade() async {
    final confirmed = await _showConfirmDialog(
      title: 'Downgrade Plan',
      message:
          'Your plan will be downgraded to Basic at the end of the current billing period.',
      confirmLabel: 'Downgrade',
      confirmColor: const Color(0xFFFF9800),
    );
    if (!confirmed) return;

    setState(() => _isActionLoading = true);
    // TODO: Replace with real API call when backend endpoint is ready.
    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) {
      AppSnackBar.info(context, 'Downgrade scheduled for end of billing period.');
      await _loadData();
    }
    if (mounted) setState(() => _isActionLoading = false);
  }

  /// Cancel subscription (placeholder until backend endpoint exists).
  Future<void> _handleCancel() async {
    final confirmed = await _showConfirmDialog(
      title: 'Cancel Subscription',
      message:
          'Are you sure you want to cancel your subscription? You will lose access at the end of the billing period.',
      confirmLabel: 'Cancel Subscription',
      confirmColor: const Color(0xFFE53935),
    );
    if (!confirmed) return;

    setState(() => _isActionLoading = true);
    // TODO: Replace with real API call when backend endpoint is ready.
    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) {
      AppSnackBar.info(context, 'Subscription cancelled successfully.');
      await _loadData();
    }
    if (mounted) setState(() => _isActionLoading = false);
  }

  Future<bool> _showConfirmDialog({
    required String title,
    required String message,
    required String confirmLabel,
    required Color confirmColor,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E2E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        content: Text(
          message,
          style: const TextStyle(
            color: Color(0xFFB0B0C3),
            fontSize: 14,
            height: 1.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text(
              'Go Back',
              style: TextStyle(color: Color(0xFF7C7C9A)),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              confirmLabel,
              style: TextStyle(
                color: confirmColor,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final subProvider = context.watch<SubscriptionProvider>();
    final userType = context.watch<GlobalState>().userType;
    final isLoading = subProvider.isLoading || subProvider.isLoadingSub;
    final hasError =
        subProvider.errorMessage != null || subProvider.subErrorMessage != null;
    final errorMsg = subProvider.errorMessage ?? subProvider.subErrorMessage;

    return CommonBackground(
      child: SafeArea(
        child: isLoading
            ? const _LoadingState()
            : hasError
                ? _ErrorState(message: errorMsg!, onRetry: _loadData)
                : _buildContent(subProvider, userType),
      ),
    );
  }

  Widget _buildContent(SubscriptionProvider subProvider, UserType userType) {
    final sub = subProvider.mySubscription;

    // Guard: no subscription data yet
    if (sub == null) {
      return _ErrorState(
        message: 'No subscription data available.',
        onRetry: _loadData,
      );
    }

    final isBasic = sub.plan == SubscriptionPlanId.basic;

    final currentPlan = subProvider.plans.firstWhere(
      (p) => p.plan == sub.plan,
      orElse: () => SubscriptionPlan(
        plan: sub.plan,
        name: sub.plan,
        price: '0',
        currency: 'chf',
        interval: 'month',
      ),
    );

    // §6: Private → show Basic only | Company → show all
    final visiblePlans = subProvider.plans.where((p) {
      if (userType == UserType.private) {
        return p.plan == SubscriptionPlanId.basic;
      }
      return true; // company sees all
    }).toList();

    return RefreshIndicator(
      onRefresh: _loadData,
      color: const Color(0xFF7C6FF7),
      backgroundColor: const Color(0xFF1E1E2E),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──
            const _PageHeader(),
            const SizedBox(height: 24),

            // ── Current Subscription Card ──
            _CurrentSubscriptionCard(subscription: sub, plan: currentPlan),
            const SizedBox(height: 28),

            // ── All Plans ──
            const _SectionLabel(label: 'Available Plans'),
            const SizedBox(height: 12),
            ...visiblePlans.map(
              (plan) =>
                  _PlanCard(plan: plan, isCurrentPlan: plan.plan == sub.plan),
            ),
            const SizedBox(height: 28),

            // ── Action Buttons ──
            if (sub.hasSubscription && sub.status == 'active') ...[
              const _SectionLabel(label: 'Manage Subscription'),
              const SizedBox(height: 12),

              // §9: Only company users can upgrade to premium
              if (isBasic && userType == UserType.company)
                _ActionButton(
                  label: '⬆  Upgrade to Premium',
                  subtitle: 'Switch to the Premium plan',
                  color: const Color(0xFF4CAF50),
                  isLoading: subProvider.isCheckingOut,
                  onTap: _handleUpgrade,
                )
              else if (!isBasic)
                _ActionButton(
                  label: '⬇  Downgrade to Basic',
                  subtitle: 'Scheduled at end of billing period',
                  color: const Color(0xFFFF9800),
                  isLoading: _isActionLoading,
                  onTap: _handleDowngrade,
                ),

              const SizedBox(height: 12),
              _ActionButton(
                label: '✕  Cancel Subscription',
                subtitle: 'You will lose access at period end',
                color: const Color(0xFFE53935),
                isLoading: _isActionLoading,
                onTap: _handleCancel,
              ),
              const SizedBox(height: 24),
            ],
          ],
        ),
      ),
    );
  }
}

// ─── Sub-Widgets ──────────────────────────────────────────────────────────────

class _LoadingState extends StatelessWidget {
  const _LoadingState();
  @override
  Widget build(BuildContext context) =>
      const Center(child: CircularProgressIndicator(color: Color(0xFF7C6FF7)));
}

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.wifi_off_rounded,
            color: Color(0xFF7C7C9A),
            size: 56.sp,
          ),
          SizedBox(height: 16.h),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Color(0xFFB0B0C3), fontSize: 15),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: onRetry,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF7C6FF7),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Retry'),
          ),
        ],
      ),
    ),
  );
}

class _PageHeader extends StatelessWidget {
  const _PageHeader();
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          GestureDetector(
            onTap: () => context.pop(),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
          const SizedBox(width: 14),
          const Text(
            'Subscription',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
      const SizedBox(height: 4),
      const Padding(
        padding: EdgeInsets.only(left: 46),
        child: Text(
          'Manage your plan & billing',
          style: TextStyle(color: Color(0xFF7C7C9A), fontSize: 13),
        ),
      ),
    ],
  );
}

class _CurrentSubscriptionCard extends StatelessWidget {
  final MySubscription subscription;
  final SubscriptionPlan plan;
  const _CurrentSubscriptionCard({
    required this.subscription,
    required this.plan,
  });

  String _formatDate(DateTime? dt) {
    if (dt == null) return '—';
    return '${dt.day.toString().padLeft(2, '0')} ${_monthName(dt.month)} ${dt.year}';
  }

  String _monthName(int m) => const [
    '',
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ][m];

  @override
  Widget build(BuildContext context) {
    final isPremium = subscription.plan == SubscriptionPlanId.premium;
    final gradientColors = isPremium
        ? [const Color(0xFF7C6FF7), const Color(0xFF4F46E5)]
        : [const Color(0xFF2E9CCA), const Color(0xFF1976D2)];

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: gradientColors[0].withValues(alpha: 0.35),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    plan.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Current Plan',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              _StatusBadge(status: subscription.status),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Text(
                '${plan.currency.toUpperCase()} ${plan.price}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(width: 6),
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  '/ ${plan.interval}',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.65),
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(height: 1, color: Colors.white.withValues(alpha: 0.15)),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _DateInfo(
                  label: 'Started',
                  date: _formatDate(subscription.currentPeriodStart),
                ),
              ),
              Expanded(
                child: _DateInfo(
                  label: subscription.cancelAtPeriodEnd
                      ? 'Cancels On'
                      : 'Renews On',
                  date: _formatDate(subscription.currentPeriodEnd),
                ),
              ),
            ],
          ),
          if (subscription.cancelAtPeriodEnd) ...[
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    color: Colors.white,
                    size: 16.sp,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'Cancellation scheduled at period end',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.85),
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _DateInfo extends StatelessWidget {
  final String label;
  final String date;
  const _DateInfo({required this.label, required this.date});

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: TextStyle(
          color: Colors.white.withValues(alpha: 0.6),
          fontSize: 11.sp,
        ),
      ),
      SizedBox(height: 3.h),
      Text(
        date,
        style: TextStyle(
          color: Colors.white,
          fontSize: 13.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    ],
  );
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final isActive = status == 'active';
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: isActive
            ? const Color(0xFF4CAF50).withValues(alpha: 0.2)
            : const Color(0xFFE53935).withValues(alpha: 0.2),
        border: Border.all(
          color: isActive ? const Color(0xFF4CAF50) : const Color(0xFFE53935),
          width: 1.2.w,
        ),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6.w,
            height: 6.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isActive
                  ? const Color(0xFF4CAF50)
                  : const Color(0xFFE53935),
            ),
          ),
          SizedBox(width: 6.w),
          Text(
            status[0].toUpperCase() + status.substring(1),
            style: TextStyle(
              color: isActive
                  ? const Color(0xFF4CAF50)
                  : const Color(0xFFE53935),
              fontSize: 12.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) => Text(
    label,
    style: TextStyle(
      color: Colors.white,
      fontSize: 16.sp,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.2.sp,
    ),
  );
}

class _PlanCard extends StatelessWidget {
  final SubscriptionPlan plan;
  final bool isCurrentPlan;
  const _PlanCard({required this.plan, required this.isCurrentPlan});

  @override
  Widget build(BuildContext context) {
    final isPremium = plan.plan == SubscriptionPlanId.premium;
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: isCurrentPlan
            ? const Color(0xFF7C6FF7).withValues(alpha: 0.1)
            : const Color(0xFF1E1E2E),
        border: Border.all(
          color: isCurrentPlan
              ? const Color(0xFF7C6FF7)
              : Colors.white.withValues(alpha: 0.08),
          width: isCurrentPlan ? 1.5 : 1,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.all(18),
      child: Row(
        children: [
          Container(
            width: 44.w,
            height: 44.h,
            decoration: BoxDecoration(
              color: isPremium
                  ? const Color(0xFF7C6FF7).withValues(alpha: 0.15)
                  : const Color(0xFF2E9CCA).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isPremium
                  ? Icons.workspace_premium_rounded
                  : Icons.star_outline_rounded,
              color: isPremium
                  ? const Color(0xFF7C6FF7)
                  : const Color(0xFF2E9CCA),
              size: 22.sp,
            ),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      plan.name,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (isCurrentPlan) ...[
                      SizedBox(width: 8.w),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 2.h,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF7C6FF7).withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Text(
                          'Current',
                          style: TextStyle(
                            color: Color(0xFF7C6FF7),
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                SizedBox(height: 3.h),
                Text(
                  '${plan.currency.toUpperCase()} ${plan.price} / ${plan.interval}',
                  style: TextStyle(
                    color: Color(0xFF7C7C9A),
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${plan.currency.toUpperCase()} ${plan.price}',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final String subtitle;
  final Color color;
  final bool isLoading;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.subtitle,
    required this.color,
    required this.isLoading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: isLoading ? null : onTap,
    child: AnimatedOpacity(
      opacity: isLoading ? 0.6 : 1.0,
      duration: const Duration(milliseconds: 200),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          border: Border.all(color: color.withValues(alpha: 0.4), width: 1.2.w),
          borderRadius: BorderRadius.circular(16.r),
        ),
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 16.h),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color: color,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: const Color(0xFF7C7C9A),
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ),
            if (isLoading)
              SizedBox(
                width: 20.w,
                height: 20.h,
                child: CircularProgressIndicator(
                  strokeWidth: 2.w,
                  color: color,
                ),
              )
            else
              Icon(Icons.arrow_forward_ios_rounded, color: color, size: 16.sp),
          ],
        ),
      ),
    ),
  );
}
