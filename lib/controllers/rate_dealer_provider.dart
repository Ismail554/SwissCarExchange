import 'package:flutter/material.dart';
import 'package:rionydo/app_utils/constants/api_service.dart';
import 'package:rionydo/app_utils/network/dio_manager.dart';
import 'package:rionydo/app_utils/network/enums.dart';
import 'package:rionydo/models/payment/review_submission_response.dart';

class RateDealerProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  ReviewSubmissionResponse? _reviewResponse;
  ReviewSubmissionResponse? get reviewResponse => _reviewResponse;

  Future<bool> submitReview({
    required String auctionId,
    required int overallRating,
    required int communicationRating,
    required int accuracyRating,
    required int reliabilityRating,
    required String reviewText,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await DioManager.apiRequest(
        url: ApiService.reviewAndRating(auctionId),
        method: Methods.post,
        skipAuth: false,
        body: {
          "overall_rating": overallRating,
          "communication_rating": communicationRating,
          "vehicle_accuracy_rating": accuracyRating,
          "transaction_reliability_rating": reliabilityRating,
          "review_text": reviewText,
        },
      );

      bool success = false;
      response.fold(
        (error) {
          debugPrint('RATE_DEALER: ❌ submitReview error: $error');
          _errorMessage = error;
        },
        (data) {
          debugPrint('RATE_DEALER: ✅ submitReview success');
          _reviewResponse = ReviewSubmissionResponse.fromJson(data);
          success = true;
        },
      );

      _isLoading = false;
      notifyListeners();
      return success;
    } catch (e) {
      debugPrint('RATE_DEALER: ❌ Unexpected error: $e');
      _errorMessage = 'Failed to submit review. Please try again.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
