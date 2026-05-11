import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:rionydo/app_utils/constants/api_service.dart';
import 'package:rionydo/app_utils/network/dio_manager.dart';
import 'package:rionydo/app_utils/network/enums.dart';
import 'package:rionydo/models/premium/auction_management_response.dart';

class WonAuctionProvider extends ChangeNotifier {
  AuctionManagementResponse? _response;
  bool _isLoading = false;
  String? _errorMessage;
  Map<String, dynamic>? _cachedRawData;

  AuctionManagementResponse? get response => _response;
  List<Auction> get auctions => _response?.results ?? [];
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchWonAuctions({bool forceRefresh = false}) async {
    // Only set loading to true and trigger shimmer if we don't have any cached data,
    // or if a force refresh is explicitly requested.
    if (_response == null || forceRefresh) {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();
    }

    try {
      final result = await DioManager.apiRequest(
        url: ApiService.wonAuction,
        method: Methods.get,
      );

      result.fold(
        (error) {
          // If we have cached data, we keep showing it rather than replacing with an error screen,
          // but if we have no cached data, we must show the error.
          if (_response == null) {
            _errorMessage = error;
            _response = null;
          }
        },
        (data) {
          final newDataMap = data as Map<String, dynamic>;
          
          // Deep compare the incoming data map with our cached raw data using JSON serialization
          final hasChanges = _cachedRawData == null || jsonEncode(_cachedRawData) != jsonEncode(newDataMap);
          
          if (hasChanges) {
            _cachedRawData = newDataMap;
            _response = AuctionManagementResponse.fromJson(newDataMap);
            _errorMessage = null;
            notifyListeners();
          }
        },
      );
    } catch (e) {
      if (_response == null) {
        _errorMessage = e.toString();
        _response = null;
      }
    } finally {
      if (_isLoading) {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  void clear() {
    _response = null;
    _isLoading = false;
    _errorMessage = null;
    _cachedRawData = null;
    notifyListeners();
  }
}
