// --- Bidder Stats ---
class BidderStats {
  final int auctionsWon;
  final int auctionsParticipated;
  final String avgBid;
  final double winRate;

  BidderStats({
    required this.auctionsWon,
    required this.auctionsParticipated,
    required this.avgBid,
    required this.winRate,
  });

  factory BidderStats.fromJson(Map<String, dynamic> json) => BidderStats(
        auctionsWon: json["auctions_won"] ?? 0,
        auctionsParticipated: json["auctions_participated"] ?? 0,
        avgBid: json["avg_bid"] ?? "0.00",
        winRate: (json["win_rate"] ?? 0.0).toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "auctions_won": auctionsWon,
        "auctions_participated": auctionsParticipated,
        "avg_bid": avgBid,
        "win_rate": winRate,
      };
}

// --- Bidder Transaction Response ---
class BidderTransactionResponse {
  final int count;
  final String? next;
  final String? previous;
  final List<dynamic> results; 

  BidderTransactionResponse({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  factory BidderTransactionResponse.fromJson(Map<String, dynamic> json) => BidderTransactionResponse(
        count: json["count"] ?? 0,
        next: json["next"],
        previous: json["previous"],
        results: json["results"] == null ? [] : List<dynamic>.from(json["results"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "next": next,
        "previous": previous,
        "results": List<dynamic>.from(results.map((x) => x)),
      };
}

// --- Dealer Transaction Response ---
class DealerTransactionResponse {
  final int count;
  final String? next;
  final String? previous;
  final List<TransactionItem> results; // Updated to use the TransactionItem model
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

  factory DealerTransactionResponse.fromJson(Map<String, dynamic> json) => DealerTransactionResponse(
        count: json["count"] ?? 0,
        next: json["next"],
        previous: json["previous"],
        results: json["results"] == null 
            ? [] 
            : List<TransactionItem>.from(json["results"].map((x) => TransactionItem.fromJson(x))),
        pendingAmount: (json["pending_amount"] ?? 0.0).toDouble(),
        receivedAmount: (json["received_amount"] ?? 0.0).toDouble(),
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

// --- Transaction Item (NEW) ---
class TransactionItem {
  final String auctionTitle;
  final String amount;
  final String status;
  final DateTime soldAt;
  final String buyerCompany;

  TransactionItem({
    required this.auctionTitle,
    required this.amount,
    required this.status,
    required this.soldAt,
    required this.buyerCompany,
  });

  factory TransactionItem.fromJson(Map<String, dynamic> json) => TransactionItem(
        auctionTitle: json["auction_title"] ?? "",
        amount: json["amount"] ?? "0.00",
        status: json["status"] ?? "",
        soldAt: DateTime.parse(json["sold_at"]),
        buyerCompany: json["buyer_company"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "auction_title": auctionTitle,
        "amount": amount,
        "status": status,
        "sold_at": soldAt.toIso8601String(),
        "buyer_company": buyerCompany,
      };
}