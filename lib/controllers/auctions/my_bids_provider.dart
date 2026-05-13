import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:rionydo/app_utils/constants/api_service.dart';
import 'package:rionydo/app_utils/network/dio_manager.dart';
import 'package:rionydo/app_utils/network/enums.dart';
import 'package:rionydo/models/auctions/my_auctions_response.dart';

class MyBidsProvider extends ChangeNotifier {
  MyAuctionResponse? _response;
  bool _isLoading = false;
  String? _errorMessage;
  Map<String, dynamic>? _cachedRawData;

  MyAuctionResponse? get response => _response;
  
  List<AuctionItem> get activeBids => _response?.results
          .where((e) => e.status.toLowerCase() == 'active')
          .toList() ??
      [];
      
  List<AuctionItem> get completedBids => _response?.results
          .where((e) => e.status.toLowerCase() != 'active')
          .toList() ??
      [];

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchMyBids({bool forceRefresh = false}) async {
    if (_response == null || forceRefresh) {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();
    }

    try {
      final result = await DioManager.apiRequest(
        url: ApiService.myBidsAuction,
        method: Methods.get,
      );

      result.fold(
        (error) {
          if (_response == null) {
            _errorMessage = error;
            _response = null;
          }
        },
        (data) {
          final newDataMap = data as Map<String, dynamic>;
          final hasChanges = _cachedRawData == null ||
              jsonEncode(_cachedRawData) != jsonEncode(newDataMap);
          if (hasChanges) {
            _cachedRawData = newDataMap;
            _response = MyAuctionResponse.fromJson(newDataMap);
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
