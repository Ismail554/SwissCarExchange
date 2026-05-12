// --- Bidder Transaction Response ---
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

  factory BidderTransactionResponse.fromJson(Map<String, dynamic> json) =>
      BidderTransactionResponse(
        count: json["count"] ?? 0,
        next: json["next"] as String?,
        previous: json["previous"] as String?,
        results: json["results"] == null
            ? []
            : List<BidderTransactionItem>.from(json["results"]
                .map((x) => BidderTransactionItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "next": next,
        "previous": previous,
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
      };
}

// --- Bidder Transaction Item ---
class BidderTransactionItem {
  final int? auctionId;
  final String auctionTitle;
  final String amount;
  final String status;
  final DateTime? auctionDate;

  BidderTransactionItem({
    this.auctionId,
    required this.auctionTitle,
    required this.amount,
    required this.status,
    this.auctionDate,
  });

  factory BidderTransactionItem.fromJson(Map<String, dynamic> json) =>
      BidderTransactionItem(
        auctionId: json["auction_id"] as int?,
        auctionTitle: json["auction_title"] ?? "",
        amount: json["amount"] ?? "0.00",
        status: json["status"] ?? "",
        auctionDate: json["auction_date"] != null
            ? DateTime.tryParse(json["auction_date"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "auction_id": auctionId,
        "auction_title": auctionTitle,
        "amount": amount,
        "status": status,
        "auction_date": auctionDate?.toIso8601String(),
      };
}

// --- Dealer Transaction Response ---
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

  factory DealerTransactionResponse.fromJson(Map<String, dynamic> json) =>
      DealerTransactionResponse(
        count: json["count"] ?? 0,
        next: json["next"] as String?,
        previous: json["previous"] as String?,
        results: json["results"] == null
            ? []
            : List<DealerTransactionItem>.from(json["results"]
                .map((x) => DealerTransactionItem.fromJson(x))),
        pendingAmount: (json["pending_amount"] as num?)?.toDouble() ?? 0.0,
        receivedAmount: (json["received_amount"] as num?)?.toDouble() ?? 0.0,
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "next": next,
        "previous": previous,
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
        "pending_amount": pendingAmount,
        "received_amount": receivedAmount,
      };
}

// --- Dealer Transaction Item ---
class DealerTransactionItem {
  final String auctionTitle;
  final String amount;
  final String status;
  final DateTime? soldAt;
  final String buyerCompany;

  DealerTransactionItem({
    required this.auctionTitle,
    required this.amount,
    required this.status,
    this.soldAt,
    required this.buyerCompany,
  });

  factory DealerTransactionItem.fromJson(Map<String, dynamic> json) =>
      DealerTransactionItem(
        auctionTitle: json["auction_title"] ?? "",
        amount: json["amount"] ?? "0.00",
        status: json["status"] ?? "",
        soldAt: json["sold_at"] != null ? DateTime.tryParse(json["sold_at"]) : null,
        buyerCompany: json["buyer_company"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "auction_title": auctionTitle,
        "amount": amount,
        "status": status,
        "sold_at": soldAt?.toIso8601String(),
        "buyer_company": buyerCompany,
      };
}