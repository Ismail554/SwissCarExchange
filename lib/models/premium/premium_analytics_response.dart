class PremiumAnalytics {
  final Stats stats;
  final SalesTrends salesTrends;
  final SalesByCategory salesByCategory;

  PremiumAnalytics({
    required this.stats,
    required this.salesTrends,
    required this.salesByCategory,
  });

  factory PremiumAnalytics.fromJson(Map<String, dynamic> json) {
    return PremiumAnalytics(
      stats: Stats.fromJson(json['stats'] ?? {}),
      salesTrends: SalesTrends.fromJson(json['sales_trends'] ?? {}),
      salesByCategory: SalesByCategory.fromJson(json['sales_by_category'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'stats': stats.toJson(),
      'sales_trends': salesTrends.toJson(),
      'sales_by_category': salesByCategory.toJson(),
    };
  }
}

class Stats {
  final int activeAuctions;
  final int soldCount;
  final double sellThroughRate;
  final String avgSellPrice;
  final String totalRevenue;
  final double winRate;

  Stats({
    required this.activeAuctions,
    required this.soldCount,
    required this.sellThroughRate,
    required this.avgSellPrice,
    required this.totalRevenue,
    required this.winRate,
  });

  factory Stats.fromJson(Map<String, dynamic> json) {
    return Stats(
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

class SalesTrends {
  final List<MonthlySale> salesTrends;
  final List<MonthlyRevenue> revenueTrends;

  SalesTrends({
    required this.salesTrends,
    required this.revenueTrends,
  });

  factory SalesTrends.fromJson(Map<String, dynamic> json) {
    return SalesTrends(
      salesTrends: (json['sales_trends'] as List<dynamic>?)
              ?.map((e) => MonthlySale.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      revenueTrends: (json['revenue_trends'] as List<dynamic>?)
              ?.map((e) => MonthlyRevenue.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sales_trends': salesTrends.map((e) => e.toJson()).toList(),
      'revenue_trends': revenueTrends.map((e) => e.toJson()).toList(),
    };
  }
}

class MonthlySale {
  final int monthNumber;
  final String monthLabel;
  final int soldCount;

  MonthlySale({
    required this.monthNumber,
    required this.monthLabel,
    required this.soldCount,
  });

  factory MonthlySale.fromJson(Map<String, dynamic> json) {
    return MonthlySale(
      monthNumber: json['month_number'] ?? 0,
      monthLabel: json['month_label'] ?? "",
      soldCount: json['sold_count'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'month_number': monthNumber,
      'month_label': monthLabel,
      'sold_count': soldCount,
    };
  }
}

class MonthlyRevenue {
  final int monthNumber;
  final String monthLabel;
  final String revenue;

  MonthlyRevenue({
    required this.monthNumber,
    required this.monthLabel,
    required this.revenue,
  });

  factory MonthlyRevenue.fromJson(Map<String, dynamic> json) {
    return MonthlyRevenue(
      monthNumber: json['month_number'] ?? 0,
      monthLabel: json['month_label'] ?? "",
      revenue: json['revenue'] ?? "0.00",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'month_number': monthNumber,
      'month_label': monthLabel,
      'revenue': revenue,
    };
  }
}

class SalesByCategory {
  final List<CategoryResult> results;

  SalesByCategory({
    required this.results,
  });

  factory SalesByCategory.fromJson(Map<String, dynamic> json) {
    return SalesByCategory(
      results: (json['results'] as List<dynamic>?)
              ?.map((e) => CategoryResult.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'results': results.map((e) => e.toJson()).toList(),
    };
  }
}

class CategoryResult {
  final String categoryCode;
  final String categoryLabel;
  final int count;
  final double percentage;

  CategoryResult({
    required this.categoryCode,
    required this.categoryLabel,
    required this.count,
    required this.percentage,
  });

  factory CategoryResult.fromJson(Map<String, dynamic> json) {
    return CategoryResult(
      categoryCode: json['category_code'] ?? "",
      categoryLabel: json['category_label'] ?? "",
      count: json['count'] ?? 0,
      percentage: (json['percentage'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category_code': categoryCode,
      'category_label': categoryLabel,
      'count': count,
      'percentage': percentage,
    };
  }
}