import 'package:flutter/material.dart';
import 'package:rionydo/app_utils/constants/api_service.dart';
import 'package:rionydo/app_utils/network/dio_manager.dart';
import 'package:rionydo/app_utils/network/enums.dart';
import 'package:rionydo/models/analytics/advance_statistics_response.dart';
import 'package:rionydo/models/transactions/analytics_response.dart';

class HomeStatsProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _error;

  // Dealer stats (from /api/analytics/stats/)
  AdvanceStatisticsResponse? _dealerStats;

  // Bidder stats (from /api/analytics/bidder-stats/)
  BidderStats? _bidderStats;

  bool get isLoading => _isLoading;
  String? get error => _error;
  AdvanceStatisticsResponse? get dealerStats => _dealerStats;
  BidderStats? get bidderStats => _bidderStats;

  Future<void> fetchDealerStats() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await DioManager.apiRequest(
        url: ApiService.advanceStatistics,
        method: Methods.get,
      );

      response.fold(
        (err) => _error = err,
        (data) {
          _dealerStats = AdvanceStatisticsResponse.fromJson(
            data is Map<String, dynamic> ? data : {},
          );
        },
      );
    } catch (e) {
      _error = 'Failed to load dealer stats';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchBidderStats() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await DioManager.apiRequest(
        url: ApiService.bidderStats,
        method: Methods.get,
      );

      response.fold(
        (err) => _error = err,
        (data) {
          if (data is Map<String, dynamic>) {
            _bidderStats = BidderStats.fromJson(data);
          }
        },
      );
    } catch (e) {
      _error = 'Failed to load bidder stats';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
