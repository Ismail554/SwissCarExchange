// ------------------------------------------------------------------
// AUCTION DETAIL RESPONSE
// ------------------------------------------------------------------
class AuctionDetailResponse {
  final int id;
  final String title;
  final String description;
  final String vehicleBrand;
  final String vehicleModel;
  final String vehicleCategory;
  final int vehicleYear;
  final int vehicleMileage;
  final String vehicleVinNumber;
  final String vehicleFuelType;
  final String vehicleLocation;
  final String reservePrice;
  final String? buyNowPrice;
  final String status;
  final DateTime startsAt;
  final DateTime endsAt;
  final int? winnerId;
  final DateTime? soldAt;
  final List<AuctionImage> images;
  final String? videoUrl;
  final String? documentUrl;
  final DateTime createdAt;
  final String sellerName;
  final String? currentHighestBid;
  final int totalBidders;
  final bool isFlagged;
  final String adminNote;
  final bool isWatchlisted;

  const AuctionDetailResponse({
    required this.id,
    required this.title,
    required this.description,
    required this.vehicleBrand,
    required this.vehicleModel,
    required this.vehicleCategory,
    required this.vehicleYear,
    required this.vehicleMileage,
    required this.vehicleVinNumber,
    required this.vehicleFuelType,
    required this.vehicleLocation,
    required this.reservePrice,
    this.buyNowPrice,
    required this.status,
    required this.startsAt,
    required this.endsAt,
    this.winnerId,
    this.soldAt,
    required this.images,
    this.videoUrl,
    this.documentUrl,
    required this.createdAt,
    required this.sellerName,
    this.currentHighestBid,
    required this.totalBidders,
    required this.isFlagged,
    required this.adminNote,
    required this.isWatchlisted,
  });

  factory AuctionDetailResponse.fromJson(Map<String, dynamic> json) {
    return AuctionDetailResponse(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      vehicleBrand: json['vehicle_brand'] as String? ?? '',
      vehicleModel: json['vehicle_model'] as String? ?? '',
      vehicleCategory: json['vehicle_category'] as String? ?? '',
      vehicleYear: json['vehicle_year'] as int? ?? 0,
      vehicleMileage: json['vehicle_mileage'] as int? ?? 0,
      vehicleVinNumber: json['vehicle_vin_number'] as String? ?? '',
      vehicleFuelType: json['vehicle_fuel_type'] as String? ?? '',
      vehicleLocation: json['vehicle_location'] as String? ?? '',
      reservePrice: json['reserve_price'] as String? ?? '0.00',
      buyNowPrice: json['buy_now_price'] as String?,
      status: json['status'] as String? ?? 'unknown',
      startsAt: json['starts_at'] != null
          ? DateTime.tryParse(json['starts_at'] as String) ?? DateTime.now()
          : DateTime.now(),
      endsAt: json['ends_at'] != null
          ? DateTime.tryParse(json['ends_at'] as String) ?? DateTime.now()
          : DateTime.now(),
      winnerId: json['winner_id'] as int?,
      soldAt: json['sold_at'] != null
          ? DateTime.tryParse(json['sold_at'] as String)
          : null,
      images: (json['images'] as List<dynamic>?)
              ?.map((e) => AuctionImage.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      videoUrl: json['video_url'] as String?,
      documentUrl: json['document_url'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String) ?? DateTime.now()
          : DateTime.now(),
      sellerName: json['seller_name'] as String? ?? '',
      currentHighestBid: json['current_highest_bid']?.toString(),
      totalBidders: json['total_bidders'] as int? ?? 0,
      isFlagged: json['is_flagged'] as bool? ?? false,
      adminNote: json['admin_note'] as String? ?? '',
      isWatchlisted: json['is_watchlisted'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'vehicle_brand': vehicleBrand,
        'vehicle_model': vehicleModel,
        'vehicle_category': vehicleCategory,
        'vehicle_year': vehicleYear,
        'vehicle_mileage': vehicleMileage,
        'vehicle_vin_number': vehicleVinNumber,
        'vehicle_fuel_type': vehicleFuelType,
        'vehicle_location': vehicleLocation,
        'reserve_price': reservePrice,
        'buy_now_price': buyNowPrice,
        'status': status,
        'starts_at': startsAt.toIso8601String(),
        'ends_at': endsAt.toIso8601String(),
        'winner_id': winnerId,
        'sold_at': soldAt?.toIso8601String(),
        'images': images.map((e) => e.toJson()).toList(),
        'video_url': videoUrl,
        'document_url': documentUrl,
        'created_at': createdAt.toIso8601String(),
        'seller_name': sellerName,
        'current_highest_bid': currentHighestBid,
        'total_bidders': totalBidders,
        'is_flagged': isFlagged,
        'admin_note': adminNote,
        'is_watchlisted': isWatchlisted,
      };

  AuctionDetailResponse copyWith({
    int? id,
    String? title,
    String? description,
    String? vehicleBrand,
    String? vehicleModel,
    String? vehicleCategory,
    int? vehicleYear,
    int? vehicleMileage,
    String? vehicleVinNumber,
    String? vehicleFuelType,
    String? vehicleLocation,
    String? reservePrice,
    String? buyNowPrice,
    String? status,
    DateTime? startsAt,
    DateTime? endsAt,
    int? winnerId,
    DateTime? soldAt,
    List<AuctionImage>? images,
    String? videoUrl,
    String? documentUrl,
    DateTime? createdAt,
    String? sellerName,
    String? currentHighestBid,
    int? totalBidders,
    bool? isFlagged,
    String? adminNote,
    bool? isWatchlisted,
  }) {
    return AuctionDetailResponse(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      vehicleBrand: vehicleBrand ?? this.vehicleBrand,
      vehicleModel: vehicleModel ?? this.vehicleModel,
      vehicleCategory: vehicleCategory ?? this.vehicleCategory,
      vehicleYear: vehicleYear ?? this.vehicleYear,
      vehicleMileage: vehicleMileage ?? this.vehicleMileage,
      vehicleVinNumber: vehicleVinNumber ?? this.vehicleVinNumber,
      vehicleFuelType: vehicleFuelType ?? this.vehicleFuelType,
      vehicleLocation: vehicleLocation ?? this.vehicleLocation,
      reservePrice: reservePrice ?? this.reservePrice,
      buyNowPrice: buyNowPrice ?? this.buyNowPrice,
      status: status ?? this.status,
      startsAt: startsAt ?? this.startsAt,
      endsAt: endsAt ?? this.endsAt,
      winnerId: winnerId ?? this.winnerId,
      soldAt: soldAt ?? this.soldAt,
      images: images ?? this.images,
      videoUrl: videoUrl ?? this.videoUrl,
      documentUrl: documentUrl ?? this.documentUrl,
      createdAt: createdAt ?? this.createdAt,
      sellerName: sellerName ?? this.sellerName,
      currentHighestBid: currentHighestBid ?? this.currentHighestBid,
      totalBidders: totalBidders ?? this.totalBidders,
      isFlagged: isFlagged ?? this.isFlagged,
      adminNote: adminNote ?? this.adminNote,
      isWatchlisted: isWatchlisted ?? this.isWatchlisted,
    );
  }
}

// ------------------------------------------------------------------
// AUCTION IMAGE (Included here for completeness)
// ------------------------------------------------------------------
class AuctionImage {
  final String url;
  final int position;

  const AuctionImage({
    required this.url,
    required this.position,
  });

  factory AuctionImage.fromJson(Map<String, dynamic> json) {
    return AuctionImage(
      url: json['url'] as String? ?? '',
      position: json['position'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'url': url,
        'position': position,
      };

  AuctionImage copyWith({
    String? url,
    int? position,
  }) {
    return AuctionImage(
      url: url ?? this.url,
      position: position ?? this.position,
    );
  }
}