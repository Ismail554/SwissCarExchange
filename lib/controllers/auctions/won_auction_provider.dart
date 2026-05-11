import 'package:flutter/material.dart';
import 'package:rionydo/app_utils/constants/api_service.dart';
import 'package:rionydo/app_utils/network/dio_manager.dart';
import 'package:rionydo/app_utils/network/enums.dart';
import 'package:rionydo/models/premium/auction_management_response.dart';

class WonAuctionProvider extends ChangeNotifier {
  AuctionManagementResponse? _response;
  bool _isLoading = false;
  String? _errorMessage;

  AuctionManagementResponse? get response => _response;
  List<Auction> get auctions => _response?.results ?? [];
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchWonAuctions() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await DioManager.apiRequest(
        url: ApiService.wonAuction,
        method: Methods.get,
      );

      result.fold(
        (error) {
          _errorMessage = error;
          _response = null;
        },
        (data) {
          _response = AuctionManagementResponse.fromJson(data as Map<String, dynamic>);
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
