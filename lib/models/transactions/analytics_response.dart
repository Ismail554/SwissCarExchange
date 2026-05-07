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
  final List<dynamic> results; // Replace 'dynamic' with your Item model later

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
  final List<dynamic> results; // Replace 'dynamic' with your Item model later
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
        results: json["results"] == null ? [] : List<dynamic>.from(json["results"].map((x) => x)),
        pendingAmount: (json["pending_amount"] ?? 0.0).toDouble(),
        receivedAmount: (json["received_amount"] ?? 0.0).toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "next": next,
        "previous": previous,
        "results": List<dynamic>.from(results.map((x) => x)),
        "pending_amount": pendingAmount,
        "received_amount": receivedAmount,
      };
}