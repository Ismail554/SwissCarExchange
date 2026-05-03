import 'package:flutter/material.dart';
import 'package:rionydo/app_utils/constants/api_service.dart';
import 'package:rionydo/app_utils/network/dio_manager.dart';
import 'package:rionydo/app_utils/network/enums.dart';
import 'package:rionydo/models/subscription/subscription_plan.dart';

class SubscriptionProvider extends ChangeNotifier {
  List<SubscriptionPlan> _plans = [];
  List<SubscriptionPlan> get plans => _plans;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isCheckingOut = false;
  bool get isCheckingOut => _isCheckingOut;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // ----------------------------------------------------------------
  // FETCH PLANS — GET /api/subscriptions/plans/
  // ----------------------------------------------------------------
  Future<void> fetchPlans() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await DioManager.apiRequest(
        url: ApiService.subscriptionPlans,
        method: Methods.get,
      );

      response.fold(
        (error) {
          debugPrint('SUBS: ❌ fetchPlans error: $error');
          _errorMessage = error;
        },
        (data) {
          debugPrint('SUBS: ✅ fetchPlans success');
          if (data is List) {
            _plans = data
                .map((e) => SubscriptionPlan.fromJson(e as Map<String, dynamic>))
                .toList();
          }
        },
      );
    } catch (e) {
      debugPrint('SUBS: ❌ Unexpected error: $e');
      _errorMessage = 'Failed to load plans. Please try again.';
    }

    _isLoading = false;
    notifyListeners();
  }

  // ----------------------------------------------------------------
  // CHECKOUT — POST /api/subscriptions/checkout/
  // Returns the checkout_url on success, null on failure.
  // ----------------------------------------------------------------
  Future<String?> checkout(String planId) async {
    _isCheckingOut = true;
    _errorMessage = null;
    notifyListeners();

    String? checkoutUrl;

    try {
      final response = await DioManager.apiRequest(
        url: ApiService.subscriptionCheckout,
        method: Methods.post,
        body: {'plan': planId},
      );

      response.fold(
        (error) {
          debugPrint('SUBS: ❌ checkout error: $error');
          _errorMessage = error;
        },
        (data) {
          debugPrint('SUBS: ✅ checkout success: $data');
          checkoutUrl = data['checkout_url'] as String?;
        },
      );
    } catch (e) {
      debugPrint('SUBS: ❌ Unexpected checkout error: $e');
      _errorMessage = 'Checkout failed. Please try again.';
    }

    _isCheckingOut = false;
    notifyListeners();
    return checkoutUrl;
  }
}
