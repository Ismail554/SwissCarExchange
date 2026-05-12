import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:rionydo/app_utils/constants/api_service.dart';
import 'package:rionydo/app_utils/network/dio_manager.dart';
import 'package:rionydo/app_utils/network/enums.dart';
import 'package:rionydo/models/won_auction/dealer_contact_response.dart';

class DealerContactProvider extends ChangeNotifier {
  DealerContactResponse? _contactData;
  bool _isLoading = false;
  String? _errorMessage;
  Map<String, dynamic>? _cachedRawData;

  DealerContactResponse? get contactData => _contactData;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchDealerContact(String auctionId, {bool forceRefresh = false}) async {
    if (_contactData == null || forceRefresh) {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();
    }

    try {
      final result = await DioManager.apiRequest(
        url: ApiService.dealerContact(auctionId),
        method: Methods.get,
      );

      result.fold(
        (error) {
          if (_contactData == null) {
            _errorMessage = error;
            _contactData = null;
          }
        },
        (data) {
          final newDataMap = data as Map<String, dynamic>;
          final hasChanges = _cachedRawData == null || jsonEncode(_cachedRawData) != jsonEncode(newDataMap);

          if (hasChanges) {
            _cachedRawData = newDataMap;
            _contactData = DealerContactResponse.fromJson(newDataMap);
            _errorMessage = null;
            notifyListeners();
          }
        },
      );
    } catch (e) {
      if (_contactData == null) {
        _errorMessage = e.toString();
        _contactData = null;
      }
    } finally {
      if (_isLoading) {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  void clear() {
    _contactData = null;
    _isLoading = false;
    _errorMessage = null;
    _cachedRawData = null;
    notifyListeners();
  }
}
