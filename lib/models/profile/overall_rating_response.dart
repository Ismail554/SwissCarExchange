class OverallRatingResponse {
  final double overallRating;
  final int totalReviewCount;

  OverallRatingResponse({
    required this.overallRating,
    required this.totalReviewCount,
  });

  factory OverallRatingResponse.fromJson(Map<String, dynamic> json) {
    return OverallRatingResponse(
      overallRating: (json['overall_rating'] as num?)?.toDouble() ?? 0.0,
      totalReviewCount: json['total_review_count'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'overall_rating': overallRating,
      'total_review_count': totalReviewCount,
    };
  }
}
