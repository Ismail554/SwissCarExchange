import 'package:flutter/material.dart';
import 'package:rionydo/app_utils/constants/api_service.dart';
import 'package:rionydo/app_utils/network/dio_manager.dart';
import 'package:rionydo/app_utils/network/enums.dart';
import 'package:rionydo/models/auctions/auctions_detail_response.dart';

class AuctionsDetailProvider extends ChangeNotifier {
  AuctionDetailResponse? _auctionDetail;
  bool _isLoading = false;
  String? _errorMessage;

  AuctionDetailResponse? get auctionDetail => _auctionDetail;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchAuctionDetail(String auctionId) async {
    _isLoading = true;
    _errorMessage = null;
    _auctionDetail = null; 
    notifyListeners();

    final result = await DioManager.apiRequest(
      url: ApiService.auctionDetail(auctionId),
      method: Methods.get,
    );

    result.fold(
      (error) {
        _errorMessage = error;
        _isLoading = false;
        notifyListeners();
      },
      (data) {
        _auctionDetail = AuctionDetailResponse.fromJson(data);
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  void clearData() {
    _auctionDetail = null;
    _errorMessage = null;
    _isLoading = false;
    notifyListeners();
  }
}