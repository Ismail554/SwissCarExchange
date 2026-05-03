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
