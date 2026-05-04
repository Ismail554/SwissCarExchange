import 'package:flutter/material.dart';
import 'package:rionydo/app_utils/constants/api_service.dart';
import 'package:rionydo/app_utils/network/dio_manager.dart';
import 'package:rionydo/app_utils/network/enums.dart';
import 'package:rionydo/models/auctions/my_auctions_response.dart';

class MyAuctionsProvider extends ChangeNotifier {
  MyAuctionResponse? _response;
  bool _isLoading = false;
  String? _errorMessage;

  MyAuctionResponse? get response => _response;
  List<AuctionItem> get auctions => _response?.results ?? [];
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchAuctions({String? statusFilter}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final Map<String, dynamic>? queryParameters =
          (statusFilter != null && statusFilter != 'all')
              ? {'status': statusFilter}
              : null;

      final result = await DioManager.apiRequest(
        url: ApiService.myAuctions,
        method: Methods.get,
        queryParameters: queryParameters,
      );

      result.fold(
        (error) {
          _errorMessage = error;
          _response = null;
        },
        (data) {
          _response = MyAuctionResponse.fromJson(data as Map<String, dynamic>);
        },
      );
    } catch (e) {
      _errorMessage = e.toString();
      _response = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clear() {
    _response = null;
    _isLoading = false;
    _errorMessage = null;
    notifyListeners();
  }
}
