class ReviewSubmissionResponse {
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

  ReviewSubmissionResponse({
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

  factory ReviewSubmissionResponse.fromJson(Map<String, dynamic> json) {
    return ReviewSubmissionResponse(
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