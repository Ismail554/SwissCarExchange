class SpendingData {
  final List<SpendingTrend> spendingTrends;

  SpendingData({
    required this.spendingTrends,
  });

  factory SpendingData.fromJson(Map<String, dynamic> json) {
    return SpendingData(
      spendingTrends: (json['spending_trends'] as List<dynamic>?)
              ?.map((e) => SpendingTrend.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'spending_trends': spendingTrends.map((e) => e.toJson()).toList(),
    };
  }
}

class SpendingTrend {
  final String label;
  final String amount;

  SpendingTrend({
    required this.label,
    required this.amount,
  });

  factory SpendingTrend.fromJson(Map<String, dynamic> json) {
    return SpendingTrend(
      label: json['label'] ?? "",
      amount: json['amount'] ?? "0.00",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'amount': amount,
    };
  }
}