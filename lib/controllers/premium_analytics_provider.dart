import 'package:flutter/material.dart';
import 'package:rionydo/app_utils/constants/api_service.dart';
import 'package:rionydo/app_utils/network/dio_manager.dart';
import 'package:rionydo/app_utils/network/enums.dart';
import 'package:rionydo/models/premium/premium_analytics_response.dart';

class PremiumAnalyticsProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _error;
  SalesByCategory? _salesByCategory;

  bool get isLoading => _isLoading;
  String? get error => _error;
  SalesByCategory? get salesByCategory => _salesByCategory;

  Future<void> fetchSalesByCategory() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await DioManager.apiRequest(
        url: ApiService.salesByCategory,
        method: Methods.get,
      );

      response.fold(
        (err) {
          debugPrint('PREMIUM_ANALYTICS: ❌ salesByCategory error: $err');
          _error = err;
        },
        (data) {
          debugPrint('PREMIUM_ANALYTICS: ✅ salesByCategory success');
          _salesByCategory = SalesByCategory.fromJson(
            data is Map<String, dynamic> ? data : {},
          );
        },
      );
    } catch (e) {
      debugPrint('PREMIUM_ANALYTICS: ❌ Unexpected error: $e');
      _error = 'Failed to load category sales data';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
