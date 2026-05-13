import 'package:flutter/material.dart';
import 'package:rionydo/app_utils/constants/api_service.dart';
import 'package:rionydo/app_utils/network/dio_manager.dart';
import 'package:rionydo/app_utils/network/enums.dart';
import 'package:rionydo/models/profile/my_shipping_request_response.dart';

class MyShippingProvider extends ChangeNotifier {
  List<ShippingResult> _requests = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<ShippingResult> get requests => _requests;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchShippingRequests() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await DioManager.apiRequest(
      url: ApiService.myShippingRequests,
      method: Methods.get,
    );

    result.fold(
      (error) {
        _errorMessage = error;
        _isLoading = false;
        notifyListeners();
      },
      (data) {
        final response = MyShippingRequest.fromJson(data);
        _requests = response.results;
        _isLoading = false;
        notifyListeners();
      },
    );
  }
}
