class AdvanceStatisticsResponse {
  final int activeAuctions;
  final int soldCount;
  final double sellThroughRate;
  final String avgSellPrice;
  final String totalRevenue;
  final double winRate;

  AdvanceStatisticsResponse({
    required this.activeAuctions,
    required this.soldCount,
    required this.sellThroughRate,
    required this.avgSellPrice,
    required this.totalRevenue,
    required this.winRate,
  });

  factory AdvanceStatisticsResponse.fromJson(Map<String, dynamic> json) {
    return AdvanceStatisticsResponse(
      activeAuctions: json['active_auctions'] ?? 0,
      soldCount: json['sold_count'] ?? 0,
      sellThroughRate: (json['sell_through_rate'] as num?)?.toDouble() ?? 0.0,
      avgSellPrice: json['avg_sell_price'] ?? "0.00",
      totalRevenue: json['total_revenue'] ?? "0.00",
      winRate: (json['win_rate'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'active_auctions': activeAuctions,
      'sold_count': soldCount,
      'sell_through_rate': sellThroughRate,
      'avg_sell_price': avgSellPrice,
      'total_revenue': totalRevenue,
      'win_rate': winRate,
    };
  }
}