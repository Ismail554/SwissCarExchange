import 'package:flutter/material.dart';
import 'package:rionydo/app_utils/constants/api_service.dart';
import 'package:rionydo/app_utils/network/dio_manager.dart';
import 'package:rionydo/app_utils/network/enums.dart';
import 'package:rionydo/models/profile/all_review_response.dart';

class DealerReviewsProvider extends ChangeNotifier {
  ReviewResponse? _reviewResponse;
  ReviewResponse? get reviewResponse => _reviewResponse;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // ─── Computed Getters for Summary Averages ────────────────────────────────
  double get averageOverall {
    final list = _reviewResponse?.results;
    if (list == null || list.isEmpty) return 0.0;
    final total = list.map((e) => e.overallRating).reduce((a, b) => a + b);
    return double.parse((total / list.length).toStringAsFixed(1));
  }

  double get averageCommunication {
    final list = _reviewResponse?.results;
    if (list == null || list.isEmpty) return 0.0;
    final total = list.map((e) => e.communicationRating).reduce((a, b) => a + b);
    return double.parse((total / list.length).toStringAsFixed(1));
  }

  double get averageAccuracy {
    final list = _reviewResponse?.results;
    if (list == null || list.isEmpty) return 0.0;
    final total = list.map((e) => e.vehicleAccuracyRating).reduce((a, b) => a + b);
    return double.parse((total / list.length).toStringAsFixed(1));
  }

  double get averageReliability {
    final list = _reviewResponse?.results;
    if (list == null || list.isEmpty) return 0.0;
    final total = list.map((e) => e.transactionReliabilityRating).reduce((a, b) => a + b);
    return double.parse((total / list.length).toStringAsFixed(1));
  }

  // ─── API Action ───────────────────────────────────────────────────────────
  Future<void> fetchReviews() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await DioManager.apiRequest(
        url: ApiService.allReviews,
        method: Methods.get,
        skipAuth: false,
      );

      response.fold(
        (error) {
          debugPrint('REVIEWS: ❌ fetchReviews error: $error');
          _errorMessage = error;
        },
        (data) {
          debugPrint('REVIEWS: ✅ fetchReviews success');
          _reviewResponse = ReviewResponse.fromJson(data);
        },
      );
    } catch (e) {
      debugPrint('REVIEWS: ❌ Unexpected error: $e');
      _errorMessage = 'Failed to load reviews. Please try again.';
    }

    _isLoading = false;
    notifyListeners();
  }
}
