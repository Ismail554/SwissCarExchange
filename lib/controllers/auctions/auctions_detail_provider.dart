import 'package:flutter/material.dart';
import 'package:rionydo/app_utils/constants/api_service.dart';
import 'package:rionydo/app_utils/network/dio_manager.dart';
import 'package:rionydo/app_utils/network/enums.dart';
import 'package:rionydo/models/auctions/auctions_detail_response.dart';
import 'package:rionydo/models/bid/bid_history_response.dart';

class AuctionsDetailProvider extends ChangeNotifier {
  AuctionDetailResponse? _auctionDetail;
  bool _isLoading = false;
  String? _errorMessage;

  // Bid history
  List<BidItem> _bidHistory = [];
  bool _isBidHistoryLoading = false;

  AuctionDetailResponse? get auctionDetail => _auctionDetail;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<BidItem> get bidHistory => _bidHistory;
  bool get isBidHistoryLoading => _isBidHistoryLoading;

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

  Future<void> fetchBidHistory(String auctionId) async {
    _isBidHistoryLoading = true;
    notifyListeners();

    final result = await DioManager.apiRequest(
      url: ApiService.bidHistory(auctionId),
      method: Methods.get,
    );

    result.fold(
      (error) {
        debugPrint("Bid history error: $error");
        _isBidHistoryLoading = false;
        notifyListeners();
      },
      (data) {
        final response = BidHistoryResponse.fromJson(data);
        _bidHistory = response.results;
        _isBidHistoryLoading = false;
        notifyListeners();
      },
    );
  }

  /// Adds a new bid item to the top of the local bid history list (from socket).
  void addBidToHistory(BidItem bid) {
    _bidHistory.insert(0, bid);
    notifyListeners();
  }

  Future<bool> toggleWatchlist(String auctionId) async {
    final result = await DioManager.apiRequest(
      url: ApiService.createWishlist(auctionId),
      method: Methods.post,
    );

    return result.fold(
      (error) {
        debugPrint("Watchlist error: $error");
        return false;
      },
      (data) {
        if (_auctionDetail != null) {
          _auctionDetail = _auctionDetail!.copyWith(
            isWatchlisted: !(_auctionDetail!.isWatchlisted),
          );
          notifyListeners();
        }
        return true;
      },
    );
  }

  Future<bool> placeBid(String auctionId, int amount) async {
    final result = await DioManager.apiRequest(
      url: ApiService.placeBid(auctionId),
      method: Methods.post,
      body: {"amount": amount.toString()},
      successCode: 201,
    );

    return result.fold(
      (error) {
        debugPrint("Place bid error: $error");
        return false;
      },
      (data) {
        return true;
      },
    );
  }

  Future<bool> createAutoBid(String auctionId, int maxAmount) async {
    final result = await DioManager.apiRequest(
      url: ApiService.autoBidCreate(auctionId),
      method: Methods.post,
      body: {"max_amount": maxAmount.toString()},
      successCode: 201,
    );

    return result.fold((error) {
      debugPrint("Auto bid create error: $error");
      return false;
    }, (data) => true);
  }

  Future<bool> deleteAutoBid(String auctionId) async {
    final result = await DioManager.apiRequest(
      url: ApiService.autoBidDelete(auctionId),
      method: Methods.delete,
    );

    return result.fold((error) {
      debugPrint("Auto bid delete error: $error");
      return false;
    }, (data) => true);
  }

  void clearData() {
    _auctionDetail = null;
    _errorMessage = null;
    _isLoading = false;
    _bidHistory = [];
    notifyListeners();
  }
}
