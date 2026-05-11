import 'package:flutter/material.dart';
import 'package:rionydo/app_utils/constants/api_service.dart';
import 'package:rionydo/app_utils/network/dio_manager.dart';
import 'package:rionydo/app_utils/network/enums.dart';
import 'package:rionydo/models/analytics/advance_statistics_response.dart';

class AdvanceStatisticsProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _error;
  AdvanceStatisticsResponse? _statistics;

  bool get isLoading => _isLoading;
  String? get error => _error;
  AdvanceStatisticsResponse? get statistics => _statistics;

  Future<void> fetchAdvanceStatistics() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await DioManager.apiRequest(
        url: ApiService.advanceStatistics,
        method: Methods.get,
      );

      response.fold(
        (err) {
          debugPrint('ADVANCE_STATISTICS: ❌ fetchAdvanceStatistics error: $err');
          _error = err;
        },
        (data) {
          debugPrint('ADVANCE_STATISTICS: ✅ fetchAdvanceStatistics success');
          _statistics = AdvanceStatisticsResponse.fromJson(
            data is Map<String, dynamic> ? data : {},
          );
        },
      );
    } catch (e) {
      debugPrint('ADVANCE_STATISTICS: ❌ Unexpected error: $e');
      _error = 'Failed to load advanced statistics';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
