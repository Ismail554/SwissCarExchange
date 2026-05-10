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

  factory SubscriptionPlan.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlan(
      plan: json['plan'] as String? ?? '',
      name: json['name'] as String? ?? '',
      price: json['price'] as String? ?? '0.00',
      currency: json['currency'] as String? ?? 'chf',
      interval: json['interval'] as String? ?? 'month',
    );
  }

  /// Formatted display price, e.g. "CHF 150.00"
  String get displayPrice => '${currency.toUpperCase()} $price';
}

abstract final class SubscriptionPlanId {
  static const basic = 'basic';
  static const premium = 'premium';
}

/// Represents the user's active subscription from GET /api/subscriptions/me/
class MySubscription {
  final bool hasSubscription;
  final String plan;
  final String status;
  final DateTime? currentPeriodStart;
  final DateTime? currentPeriodEnd;
  final bool cancelAtPeriodEnd;

  const MySubscription({
    required this.hasSubscription,
    required this.plan,
    required this.status,
    this.currentPeriodStart,
    this.currentPeriodEnd,
    this.cancelAtPeriodEnd = false,
  });

  factory MySubscription.fromJson(Map<String, dynamic> json) {
    return MySubscription(
      hasSubscription: json['has_subscription'] as bool? ?? false,
      plan: json['plan'] as String? ?? '',
      status: json['status'] as String? ?? 'inactive',
      currentPeriodStart: json['current_period_start'] != null
          ? DateTime.tryParse(json['current_period_start'] as String)
          : null,
      currentPeriodEnd: json['current_period_end'] != null
          ? DateTime.tryParse(json['current_period_end'] as String)
          : null,
      cancelAtPeriodEnd: json['cancel_at_period_end'] as bool? ?? false,
    );
  }
}
