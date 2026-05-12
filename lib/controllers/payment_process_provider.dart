import 'package:flutter/material.dart';
import 'package:rionydo/app_utils/constants/api_service.dart';
import 'package:rionydo/app_utils/network/dio_manager.dart';
import 'package:rionydo/app_utils/network/enums.dart';
import 'package:rionydo/models/payment/payment_info_response.dart';

class PaymentProcessProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _error;

  PaymentInfoResponse? _paymentInfo;

  bool _paymentAlreadyProcessed = false;
  
  bool get isLoading => _isLoading;
  String? get error => _error;
  PaymentInfoResponse? get paymentInfo => _paymentInfo;
  bool get paymentAlreadyProcessed => _paymentAlreadyProcessed;

  Future<void> fetchPaymentInfo(String auctionId) async {
    _isLoading = true;
    _error = null;
    _paymentAlreadyProcessed = false;
    notifyListeners();

    try {
      final response = await DioManager.apiRequest(
        url: ApiService.paymentInfo(auctionId),
        method: Methods.get,
      );

      response.fold((err) {
        if (err.toString().contains('Payment has already been processed')) {
          _paymentAlreadyProcessed = true;
        } else {
          _error = err;
        }
      }, (data) {
        if (data is Map<String, dynamic>) {
          _paymentInfo = PaymentInfoResponse.fromJson(data);
        } else {
          _error = "Invalid response format";
        }
      });
    } catch (e) {
      _error = 'Failed to load payment info';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> markPayment(String auctionId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    bool success = false;
    try {
      final response = await DioManager.apiRequest(
        url: ApiService.markPayment(auctionId),
        method: Methods.post,
      );

      response.fold((err) {
        if (err.toString().contains('Payment has already been processed')) {
          _paymentAlreadyProcessed = true;
          success = true;
        } else {
          _error = err;
        }
      }, (data) {
        success = true;
      });
    } catch (e) {
      _error = 'Failed to mark payment';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    return success;
  }

  Future<bool> chooseShipping(String auctionId, String shippingMethod) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    bool success = false;
    try {
      final response = await DioManager.apiRequest(
        url: ApiService.chooseShipping(auctionId),
        method: Methods.post,
        body: {'shipping_method': shippingMethod},
      );

      response.fold((err) => _error = err, (data) {
        success = true;
      });
    } catch (e) {
      _error = 'Failed to choose shipping';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    return success;
  }

  Future<bool> markShipping(String auctionId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    bool success = false;
    try {
      final response = await DioManager.apiRequest(
        url: ApiService.markShipping(auctionId),
        method: Methods.post,
      );

      response.fold((err) => _error = err, (data) {
        success = true;
      });
    } catch (e) {
      _error = 'Failed to mark shipping';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    return success;
  }
}
