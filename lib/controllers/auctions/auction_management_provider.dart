import 'package:flutter/material.dart';
import 'package:rionydo/app_utils/constants/api_service.dart';
import 'package:rionydo/app_utils/network/dio_manager.dart';
import 'package:rionydo/app_utils/network/enums.dart';
import 'package:rionydo/models/premium/auction_management_response.dart';

class AuctionManagementProvider extends ChangeNotifier {
  AuctionManagementResponse? _response;
  bool _isLoading = false;
  String? _errorMessage;
  String _selectedStatus = 'active'; // Default tab

  AuctionManagementResponse? get response => _response;
  List<Auction> get auctions => _response?.results ?? [];
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get selectedStatus => _selectedStatus;

  void setStatus(String status) {
    if (_selectedStatus == status) return;
    _selectedStatus = status;
    fetchAuctions();
  }

  Future<void> fetchAuctions() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await DioManager.apiRequest(
        url: ApiService.auctionManagement,
        method: Methods.get,
        queryParameters: {'status': _selectedStatus},
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
    _selectedStatus = 'active';
    notifyListeners();
  }
}
