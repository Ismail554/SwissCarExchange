import 'auction_image.dart';

// ------------------------------------------------------------------
// MY AUCTION RESPONSE (Paginated Wrapper)
// ------------------------------------------------------------------
class MyAuctionResponse {
  final int count;
  final String? next;
  final String? previous;
  final List<AuctionItem> results;

  const MyAuctionResponse({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  factory MyAuctionResponse.fromJson(Map<String, dynamic> json) {
    return MyAuctionResponse(
      count: json['count'] as int? ?? 0,
      next: json['next'] as String?,
      previous: json['previous'] as String?,
      results: (json['results'] as List<dynamic>?)
              ?.map((e) => AuctionItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toJson() => {
        'count': count,
        'next': next,
        'previous': previous,
        'results': results.map((e) => e.toJson()).toList(),
      };

  MyAuctionResponse copyWith({
    int? count,
    String? next,
    String? previous,
    List<AuctionItem>? results,
  }) {
    return MyAuctionResponse(
      count: count ?? this.count,
      next: next ?? this.next,
      previous: previous ?? this.previous,
      results: results ?? this.results,
    );
  }
}

// ------------------------------------------------------------------
// AUCTION ITEM
// ------------------------------------------------------------------
class AuctionItem {
  final int id;
  final String title;
  final String vehicleBrand;
  final String sellerName;
  final String? currentHighestBid; 
  final String reservePrice;
  final String status;
  final DateTime createdAt;
  final DateTime? endsAt;
  final int totalBidders;
  final List<AuctionImage> images;

  const AuctionItem({
    required this.id,
    required this.title,
    required this.vehicleBrand,
    required this.sellerName,
    this.currentHighestBid,
    required this.reservePrice,
    required this.status,
    required this.createdAt,
    this.endsAt,
    required this.totalBidders,
    required this.images,
  });

  factory AuctionItem.fromJson(Map<String, dynamic> json) {
    return AuctionItem(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      vehicleBrand: json['vehicle_brand'] as String? ?? '',
      sellerName: json['seller_name'] as String? ?? '',
      currentHighestBid: json['current_highest_bid']?.toString(),
      reservePrice: json['reserve_price'] as String? ?? '0.00',
      status: json['status'] as String? ?? 'unknown',
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String) ?? DateTime.now()
          : DateTime.now(),
      endsAt: json['ends_at'] != null
          ? DateTime.tryParse(json['ends_at'] as String)
          : null,
      totalBidders: json['total_bidders'] as int? ?? 0,
      images: (json['images'] as List<dynamic>?)
              ?.map((e) => AuctionImage.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'vehicle_brand': vehicleBrand,
        'seller_name': sellerName,
        'current_highest_bid': currentHighestBid,
        'reserve_price': reservePrice,
        'status': status,
        'created_at': createdAt.toIso8601String(),
        'ends_at': endsAt?.toIso8601String(),
        'total_bidders': totalBidders,
        'images': images.map((e) => e.toJson()).toList(),
      };

  AuctionItem copyWith({
    int? id,
    String? title,
    String? vehicleBrand,
    String? sellerName,
    String? currentHighestBid,
    String? reservePrice,
    String? status,
    DateTime? createdAt,
    int? totalBidders,
    List<AuctionImage>? images,
  }) {
    return AuctionItem(
      id: id ?? this.id,
      title: title ?? this.title,
      vehicleBrand: vehicleBrand ?? this.vehicleBrand,
      sellerName: sellerName ?? this.sellerName,
      currentHighestBid: currentHighestBid ?? this.currentHighestBid,
      reservePrice: reservePrice ?? this.reservePrice,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      totalBidders: totalBidders ?? this.totalBidders,
      images: images ?? this.images,
    );
  }
}


