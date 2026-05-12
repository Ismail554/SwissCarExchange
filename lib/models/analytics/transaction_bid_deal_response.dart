// --- Dealer Transaction Models ---

class DealerTransactionResponse {
  final int count;
  final String? next;
  final String? previous;
  final List<DealerTransactionItem> results;
  final double pendingAmount;
  final double receivedAmount;

  DealerTransactionResponse({
    required this.count,
    this.next,
    this.previous,
    required this.results,
    required this.pendingAmount,
    required this.receivedAmount,
  });

  factory DealerTransactionResponse.fromJson(Map<String, dynamic> json) {
    return DealerTransactionResponse(
      count: json['count'] ?? 0,
      next: json['next'] as String?,
      previous: json['previous'] as String?,
      results: (json['results'] as List<dynamic>?)
              ?.map((e) => DealerTransactionItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      pendingAmount: (json['pending_amount'] as num?)?.toDouble() ?? 0.0,
      receivedAmount: (json['received_amount'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'count': count,
      'next': next,
      'previous': previous,
      'results': results.map((e) => e.toJson()).toList(),
      'pending_amount': pendingAmount,
      'received_amount': receivedAmount,
    };
  }
}

class DealerTransactionItem {
  final int auctionId;
  final String auctionTitle;
  final String amount;
  final String status;
  final DateTime? soldAt;
  final String buyerCompany;

  DealerTransactionItem({
    required this.auctionId,
    required this.auctionTitle,
    required this.amount,
    required this.status,
    this.soldAt,
    required this.buyerCompany,
  });

  factory DealerTransactionItem.fromJson(Map<String, dynamic> json) {
    return DealerTransactionItem(
      auctionId: json['auction_id'] ?? 0,
      auctionTitle: json['auction_title'] ?? "",
      amount: json['amount'] ?? "0.00",
      status: json['status'] ?? "",
      soldAt: json['sold_at'] != null ? DateTime.tryParse(json['sold_at']) : null,
      buyerCompany: json['buyer_company'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'auction_id': auctionId,
      'auction_title': auctionTitle,
      'amount': amount,
      'status': status,
      'sold_at': soldAt?.toIso8601String(),
      'buyer_company': buyerCompany,
    };
  }
}

// --- Bidder Transaction Models ---

class BidderTransactionResponse {
  final int count;
  final String? next;
  final String? previous;
  final List<BidderTransactionItem> results;

  BidderTransactionResponse({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  factory BidderTransactionResponse.fromJson(Map<String, dynamic> json) {
    return BidderTransactionResponse(
      count: json['count'] ?? 0,
      next: json['next'] as String?,
      previous: json['previous'] as String?,
      results: (json['results'] as List<dynamic>?)
              ?.map((e) => BidderTransactionItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'count': count,
      'next': next,
      'previous': previous,
      'results': results.map((e) => e.toJson()).toList(),
    };
  }
}

class BidderTransactionItem {
  final int auctionId;
  final String auctionTitle;
  final String amount;
  final String status;
  final DateTime? auctionDate;

  BidderTransactionItem({
    required this.auctionId,
    required this.auctionTitle,
    required this.amount,
    required this.status,
    this.auctionDate,
  });

  factory BidderTransactionItem.fromJson(Map<String, dynamic> json) {
    return BidderTransactionItem(
      auctionId: json['auction_id'] ?? 0,
      auctionTitle: json['auction_title'] ?? "",
      amount: json['amount'] ?? "0.00",
      status: json['status'] ?? "",
      auctionDate: json['auction_date'] != null
          ? DateTime.tryParse(json['auction_date'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'auction_id': auctionId,
      'auction_title': auctionTitle,
      'amount': amount,
      'status': status,
      'auction_date': auctionDate?.toIso8601String(),
    };
  }
}