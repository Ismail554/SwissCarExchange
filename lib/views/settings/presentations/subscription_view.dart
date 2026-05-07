import 'package:flutter/material.dart';
import 'package:rionydo/core/widgets/common_background.dart';

// ─── Models ───────────────────────────────────────────────────────────────────

class SubscriptionPlan {
  final String plan;
  final String name;
  final String price;
  final String currency;
  final String interval;

  const SubscriptionPlan({
    required this.plan,
    required this.name,
    required this.price,
    required this.currency,
    required this.interval,
  });

  factory SubscriptionPlan.fromJson(Map<String, dynamic> json) =>
      SubscriptionPlan(
        plan: json['plan'],
        name: json['name'],
        price: json['price'],
        currency: json['currency'],
        interval: json['interval'],
      );
}

class MySubscription {
  final bool hasSubscription;
  final String plan;
  final String status;
  final DateTime currentPeriodStart;
  final DateTime currentPeriodEnd;
  final bool cancelAtPeriodEnd;

  const MySubscription({
    required this.hasSubscription,
    required this.plan,
    required this.status,
    required this.currentPeriodStart,
    required this.currentPeriodEnd,
    required this.cancelAtPeriodEnd,
  });

  factory MySubscription.fromJson(Map<String, dynamic> json) => MySubscription(
    hasSubscription: json['has_subscription'],
    plan: json['plan'],
    status: json['status'],
    currentPeriodStart: DateTime.parse(json['current_period_start']),
    currentPeriodEnd: DateTime.parse(json['current_period_end']),
    cancelAtPeriodEnd: json['cancel_at_period_end'],
  );
}

// ─── Mock API ─────────────────────────────────────────────────────────────────

class SubscriptionApi {
  static Future<List<SubscriptionPlan>> fetchPlans() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return [
      SubscriptionPlan.fromJson({
        'plan': 'basic',
        'name': 'Basic',
        'price': '150.00',
        'currency': 'chf',
        'interval': 'month',
      }),
      SubscriptionPlan.fromJson({
        'plan': 'premium',
        'name': 'Premium',
        'price': '350.00',
        'currency': 'chf',
        'interval': 'month',
      }),
    ];
  }

  static Future<MySubscription> fetchMySubscription() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return MySubscription.fromJson({
      'has_subscription': true,
      'plan': 'premium',
      'status': 'active',
      'current_period_start': '2026-05-04T00:43:30Z',
      'current_period_end': '2026-06-04T00:43:30Z',
      'cancel_at_period_end': false,
    });
  }

  static Future<String> downgradePlan(String plan) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return 'Downgrade scheduled for end of billing period.';
  }

  static Future<String> cancelSubscription(String plan) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return 'Subscription cancelled successfully.';
  }
}

// ─── View ─────────────────────────────────────────────────────────────────────

class AccountSubscriptionView extends StatefulWidget {
  const AccountSubscriptionView({super.key});

  @override
  State<AccountSubscriptionView> createState() =>
      _AccountSubscriptionViewState();
}

class _AccountSubscriptionViewState extends State<AccountSubscriptionView> {
  List<SubscriptionPlan> _plans = [];
  MySubscription? _mySubscription;
  bool _isLoading = true;
  bool _isActionLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final results = await Future.wait([
        SubscriptionApi.fetchPlans(),
        SubscriptionApi.fetchMySubscription(),
      ]);
      setState(() {
        _plans = results[0] as List<SubscriptionPlan>;
        _mySubscription = results[1] as MySubscription;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load subscription data.';
        _isLoading = false;
      });
    }
  }

  Future<void> _handleUpgradeOrDowngrade() async {
    final sub = _mySubscription!;
    final isBasic = sub.plan == 'basic';
    final actionLabel = isBasic ? 'Upgrade' : 'Downgrade';
    final targetPlan = isBasic ? 'premium' : 'basic';

    final confirmed = await _showConfirmDialog(
      title: '$actionLabel Plan',
      message: isBasic
          ? 'You will be upgraded to the Premium plan immediately.'
          : 'Your plan will be downgraded to Basic at the end of the current billing period.',
      confirmLabel: actionLabel,
      confirmColor: isBasic ? const Color(0xFF4CAF50) : const Color(0xFFFF9800),
    );
    if (!confirmed) return;

    setState(() => _isActionLoading = true);
    try {
      final msg = isBasic
          ? await SubscriptionApi.downgradePlan(targetPlan) // reuse endpoint
          : await SubscriptionApi.downgradePlan(targetPlan);
      if (mounted) {
        _showSnackBar(msg, isError: false);
        await _loadData();
      }
    } catch (e) {
      if (mounted)
        _showSnackBar('Action failed. Please try again.', isError: true);
    } finally {
      if (mounted) setState(() => _isActionLoading = false);
    }
  }

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
    try {
      await SubscriptionApi.cancelSubscription(_mySubscription!.plan);
      if (mounted) {
        _showSnackBar('Subscription cancelled successfully.', isError: false);
        await _loadData();
      }
    } catch (e) {
      if (mounted)
        _showSnackBar('Cancellation failed. Please try again.', isError: true);
    } finally {
      if (mounted) setState(() => _isActionLoading = false);
    }
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

  void _showSnackBar(String message, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError
            ? const Color(0xFFE53935)
            : const Color(0xFF4CAF50),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  String _formatDate(DateTime dt) =>
      '${dt.day.toString().padLeft(2, '0')} ${_monthName(dt.month)} ${dt.year}';

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
    return CommonBackground(
      child: SafeArea(
        child: _isLoading
            ? const _LoadingState()
            : _errorMessage != null
            ? _ErrorState(message: _errorMessage!, onRetry: _loadData)
            : _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    final sub = _mySubscription!;
    final isBasic = sub.plan == 'basic';
    final currentPlan = _plans.firstWhere(
      (p) => p.plan == sub.plan,
      orElse: () => SubscriptionPlan(
        plan: sub.plan,
        name: sub.plan,
        price: '0',
        currency: 'chf',
        interval: 'month',
      ),
    );

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
            ..._plans.map(
              (plan) =>
                  _PlanCard(plan: plan, isCurrentPlan: plan.plan == sub.plan),
            ),
            const SizedBox(height: 28),

            // ── Action Buttons ──
            if (sub.hasSubscription && sub.status == 'active') ...[
              const _SectionLabel(label: 'Manage Subscription'),
              const SizedBox(height: 12),
              _ActionButton(
                label: isBasic
                    ? '⬆  Upgrade to Premium'
                    : '⬇  Downgrade to Basic',
                subtitle: isBasic
                    ? 'Switch to the Premium plan'
                    : 'Scheduled at end of billing period',
                color: isBasic
                    ? const Color(0xFF4CAF50)
                    : const Color(0xFFFF9800),
                isLoading: _isActionLoading,
                onTap: _handleUpgradeOrDowngrade,
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
          const Icon(
            Icons.wifi_off_rounded,
            color: Color(0xFF7C7C9A),
            size: 56,
          ),
          const SizedBox(height: 16),
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
            onTap: () => Navigator.of(context).maybePop(),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
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

  String _formatDate(DateTime dt) =>
      '${dt.day.toString().padLeft(2, '0')} ${_monthName(dt.month)} ${dt.year}';

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
    final isPremium = subscription.plan == 'premium';
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
            color: gradientColors[0].withOpacity(0.35),
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
                      color: Colors.white.withOpacity(0.7),
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
                'CHF ${plan.price}',
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
                    color: Colors.white.withOpacity(0.65),
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(height: 1, color: Colors.white.withOpacity(0.15)),
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
                color: Colors.white.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.info_outline_rounded,
                    color: Colors.white,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Cancellation scheduled at period end',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.85),
                      fontSize: 12,
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
        style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 11),
      ),
      const SizedBox(height: 3),
      Text(
        date,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 13,
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isActive
            ? const Color(0xFF4CAF50).withOpacity(0.2)
            : const Color(0xFFE53935).withOpacity(0.2),
        border: Border.all(
          color: isActive ? const Color(0xFF4CAF50) : const Color(0xFFE53935),
          width: 1.2,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isActive
                  ? const Color(0xFF4CAF50)
                  : const Color(0xFFE53935),
            ),
          ),
          const SizedBox(width: 6),
          Text(
            status[0].toUpperCase() + status.substring(1),
            style: TextStyle(
              color: isActive
                  ? const Color(0xFF4CAF50)
                  : const Color(0xFFE53935),
              fontSize: 12,
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
    style: const TextStyle(
      color: Colors.white,
      fontSize: 16,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.2,
    ),
  );
}

class _PlanCard extends StatelessWidget {
  final SubscriptionPlan plan;
  final bool isCurrentPlan;
  const _PlanCard({required this.plan, required this.isCurrentPlan});

  @override
  Widget build(BuildContext context) {
    final isPremium = plan.plan == 'premium';
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isCurrentPlan
            ? const Color(0xFF7C6FF7).withOpacity(0.1)
            : const Color(0xFF1E1E2E),
        border: Border.all(
          color: isCurrentPlan
              ? const Color(0xFF7C6FF7)
              : Colors.white.withOpacity(0.08),
          width: isCurrentPlan ? 1.5 : 1,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.all(18),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: isPremium
                  ? const Color(0xFF7C6FF7).withOpacity(0.15)
                  : const Color(0xFF2E9CCA).withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isPremium
                  ? Icons.workspace_premium_rounded
                  : Icons.star_outline_rounded,
              color: isPremium
                  ? const Color(0xFF7C6FF7)
                  : const Color(0xFF2E9CCA),
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      plan.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (isCurrentPlan) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF7C6FF7).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'Current',
                          style: TextStyle(
                            color: Color(0xFF7C6FF7),
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  '${plan.currency.toUpperCase()} ${plan.price} / ${plan.interval}',
                  style: const TextStyle(
                    color: Color(0xFF7C7C9A),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Text(
            'CHF ${plan.price}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w800,
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
          color: color.withOpacity(0.08),
          border: Border.all(color: color.withOpacity(0.4), width: 1.2),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
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
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Color(0xFF7C7C9A),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            if (isLoading)
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2, color: color),
              )
            else
              Icon(Icons.arrow_forward_ios_rounded, color: color, size: 16),
          ],
        ),
      ),
    ),
  );
}
