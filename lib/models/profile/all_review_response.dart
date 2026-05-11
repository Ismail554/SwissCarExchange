class ReviewResponse {
  final int count;
  final String? next;
  final String? previous;
  final List<Review> results;

  ReviewResponse({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  factory ReviewResponse.fromJson(Map<String, dynamic> json) {
    return ReviewResponse(
      count: json['count'] ?? 0,
      next: json['next'] as String?,
      previous: json['previous'] as String?,
      results: (json['results'] as List<dynamic>?)
              ?.map((e) => Review.fromJson(e as Map<String, dynamic>))
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

class Review {
  final int id;
  final int auctionId;
  final int reviewerId;
  final Reviewer reviewer;
  final int dealerId;
  final double overallRating;
  final double communicationRating;
  final double vehicleAccuracyRating;
  final double transactionReliabilityRating;
  final String reviewText;
  final DateTime? createdAt;

  Review({
    required this.id,
    required this.auctionId,
    required this.reviewerId,
    required this.reviewer,
    required this.dealerId,
    required this.overallRating,
    required this.communicationRating,
    required this.vehicleAccuracyRating,
    required this.transactionReliabilityRating,
    required this.reviewText,
    this.createdAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'] ?? 0,
      auctionId: json['auction_id'] ?? 0,
      reviewerId: json['reviewer_id'] ?? 0,
      reviewer: Reviewer.fromJson(json['reviewer'] ?? {}),
      dealerId: json['dealer_id'] ?? 0,
      overallRating: (json['overall_rating'] as num?)?.toDouble() ?? 0.0,
      communicationRating: (json['communication_rating'] as num?)?.toDouble() ?? 0.0,
      vehicleAccuracyRating: (json['vehicle_accuracy_rating'] as num?)?.toDouble() ?? 0.0,
      transactionReliabilityRating: (json['transaction_reliability_rating'] as num?)?.toDouble() ?? 0.0,
      reviewText: json['review_text'] ?? "",
      createdAt: json['created_at'] != null 
          ? DateTime.tryParse(json['created_at']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'auction_id': auctionId,
      'reviewer_id': reviewerId,
      'reviewer': reviewer.toJson(),
      'dealer_id': dealerId,
      'overall_rating': overallRating,
      'communication_rating': communicationRating,
      'vehicle_accuracy_rating': vehicleAccuracyRating,
      'transaction_reliability_rating': transactionReliabilityRating,
      'review_text': reviewText,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}

class Reviewer {
  final String fullName;
  final String company;
  final String photoUrl;

  Reviewer({
    required this.fullName,
    required this.company,
    required this.photoUrl,
  });

  factory Reviewer.fromJson(Map<String, dynamic> json) {
    return Reviewer(
      fullName: json['full_name'] ?? "",
      company: json['company'] ?? "",
      photoUrl: json['photo_url'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'full_name': fullName,
      'company': company,
      'photo_url': photoUrl,
    };
  }
}