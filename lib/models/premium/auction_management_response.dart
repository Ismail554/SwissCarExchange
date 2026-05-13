class AuctionManagementResponse {
  final int count;
  final String? next;
  final String? previous;
  final List<Auction> results;

  AuctionManagementResponse({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  factory AuctionManagementResponse.fromJson(Map<String, dynamic> json) {
    return AuctionManagementResponse(
      count: json['count'] ?? 0,
      next: json['next'] as String?,
      previous: json['previous'] as String?,
      results: (json['results'] as List<dynamic>?)
              ?.map((e) => Auction.fromJson(e as Map<String, dynamic>))
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

class Auction {
  final int id;
  final String title;
  final String vehicleBrand;
  final String sellerName;
  final String currentHighestBid;
  final String reservePrice;
  final String status;
  final DateTime? endsAt;
  final int totalBidders;
  final int totalBids;
  final List<AuctionImage> images;
  final int viewCount;
  final int watchlistCount;
  final String transactionStatus;
  final bool hasReviewed;

  Auction({
    required this.id,
    required this.title,
    required this.vehicleBrand,
    required this.sellerName,
    required this.currentHighestBid,
    required this.reservePrice,
    required this.status,
    this.endsAt,
    required this.totalBidders,
    required this.totalBids,
    required this.images,
    required this.viewCount,
    required this.watchlistCount,
    required this.transactionStatus,
   this.hasReviewed=false,
  });

  factory Auction.fromJson(Map<String, dynamic> json) {
    return Auction(
      id: json['id'] ?? 0,
      title: json['title'] ?? "",
      vehicleBrand: json['vehicle_brand'] ?? "",
      sellerName: json['seller_name'] ?? "",
      currentHighestBid: json['current_highest_bid'] ?? "0.00",
      reservePrice: json['reserve_price'] ?? "0.00",
      status: json['status'] ?? "",
      endsAt: json['ends_at'] != null 
          ? DateTime.tryParse(json['ends_at']) 
          : null,
      totalBidders: json['total_bidders'] ?? 0,
      totalBids: json['total_bids'] ?? 0,
      images: (json['images'] as List<dynamic>?)
              ?.map((e) => AuctionImage.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      viewCount: json['view_count'] ?? 0,
      watchlistCount: json['watchlist_count'] ?? 0,
      transactionStatus: json['transaction_status'] ?? "",
hasReviewed: json['has_reviewed'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'vehicle_brand': vehicleBrand,
      'seller_name': sellerName,
      'current_highest_bid': currentHighestBid,
      'reserve_price': reservePrice,
      'status': status,
      'ends_at': endsAt?.toIso8601String(),
      'total_bidders': totalBidders,
      'total_bids': totalBids,
      'images': images.map((e) => e.toJson()).toList(),
      'view_count': viewCount,
      'watchlist_count': watchlistCount,
      'transaction_status': transactionStatus,
      'has_reviewed': hasReviewed,
    };
  }
}

class AuctionImage {
  final String url;
  final int position;

  AuctionImage({
    required this.url,
    required this.position,
  });

  factory AuctionImage.fromJson(Map<String, dynamic> json) {
    return AuctionImage(
      url: json['url'] ?? "",
      position: json['position'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'position': position,
    };
  }
}