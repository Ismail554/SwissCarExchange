import 'package:rionydo/models/auctions/my_auctions_response.dart';
import 'package:rionydo/models/auctions/auction_image.dart';

class MyWishListResponse {
  final int count;
  final String? next;
  final String? previous;
  final List<WishListItem> results;

  MyWishListResponse({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  factory MyWishListResponse.fromJson(Map<String, dynamic> json) {
    return MyWishListResponse(
      count: json['count'] ?? 0,
      next: json['next'] as String?,
      previous: json['previous'] as String?,
      results:
          (json['results'] as List<dynamic>?)
              ?.map((e) => WishListItem.fromJson(e as Map<String, dynamic>))
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

class WishListItem {
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
  final List<WishListImage> images;

  WishListItem({
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
  });

  factory WishListItem.fromJson(Map<String, dynamic> json) {
    return WishListItem(
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
      images:
          (json['images'] as List<dynamic>?)
              ?.map((e) => WishListImage.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
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
    };
  }

  AuctionItem toAuctionItem() {
    return AuctionItem(
      id: id,
      title: title,
      vehicleBrand: vehicleBrand,
      sellerName: sellerName,
      currentHighestBid: currentHighestBid,
      reservePrice: reservePrice,
      status: status,
      createdAt: DateTime.now(), // Fallback
      endsAt: endsAt,
      totalBidders: totalBidders,
      totalBids: totalBids,
      images: images
          .map((e) => AuctionImage(url: e.url, position: e.position))
          .toList(),
    );
  }
}

class WishListImage {
  final String url;
  final int position;

  WishListImage({required this.url, required this.position});

  factory WishListImage.fromJson(Map<String, dynamic> json) {
    return WishListImage(
      url: json['url'] ?? "",
      position: json['position'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'url': url, 'position': position};
  }
}
