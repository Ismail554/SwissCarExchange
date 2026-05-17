import 'package:flutter/material.dart';
import 'package:rionydo/app_utils/constants/api_service.dart';
import 'package:rionydo/app_utils/network/dio_manager.dart';
import 'package:rionydo/app_utils/network/enums.dart';
import 'package:rionydo/models/auctions/auctions_detail_response.dart';
import 'package:rionydo/models/bid/bid_history_response.dart';
import 'package:rionydo/models/notification%20&%20wishlist/my_wishlist_response.dart';

class AuctionsDetailProvider extends ChangeNotifier {
  AuctionDetailResponse? _auctionDetail;
  bool _isLoading = false;
  String? _errorMessage;

  // Bid history
  List<BidItem> _bidHistory = [];
  bool _isBidHistoryLoading = false;

  // Wishlist
  List<WishListItem> _wishlist = [];
  bool _isWishlistLoading = false;

  AuctionDetailResponse? get auctionDetail => _auctionDetail;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<BidItem> get bidHistory => _bidHistory;
  bool get isBidHistoryLoading => _isBidHistoryLoading;
  List<WishListItem> get wishlist => _wishlist;
  bool get isWishlistLoading => _isWishlistLoading;

  Future<void> fetchAuctionDetail(String auctionId) async {
    final isSameAuction = _auctionDetail?.id.toString() == auctionId;
    
    if (!isSameAuction) {
      _isLoading = true;
      _errorMessage = null;
      _auctionDetail = null;
      _bidHistory = []; // Clear old bid history to prevent cross-auction leakage
      notifyListeners();
    } else {
      _errorMessage = null;
    }

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

  /// Optimistically removes an item from the wishlist without a full re-fetch.
  /// Removes the item from the local list immediately for instant UI feedback,
  /// then confirms the removal via the API. Rolls back if the API call fails.
  Future<bool> removeFromWishlist(String auctionId) async {
    final removedIndex = _wishlist.indexWhere((e) => e.id.toString() == auctionId);
    if (removedIndex == -1) return false;

    // Optimistic removal — update UI instantly, no loading flash.
    final removedItem = _wishlist[removedIndex];
    _wishlist = List.from(_wishlist)..removeAt(removedIndex);
    notifyListeners();

    final result = await DioManager.apiRequest(
      url: ApiService.createWishlist(auctionId),
      method: Methods.post,
    );

    return result.fold(
      (error) {
        // Roll back the optimistic removal on failure.
        debugPrint("Remove wishlist error: $error");
        _wishlist = List.from(_wishlist)..insert(removedIndex, removedItem);
        notifyListeners();
        return false;
      },
      (_) => true,
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

  Future<void> fetchWishlist() async {
    _isWishlistLoading = true;
    notifyListeners();

    final result = await DioManager.apiRequest(
      url: ApiService.myWishlists,
      method: Methods.get,
    );

    result.fold(
      (error) {
        debugPrint("Wishlist error: $error");
        _isWishlistLoading = false;
        notifyListeners();
      },
      (data) {
        final response = MyWishListResponse.fromJson(data);
        _wishlist = response.results;
        _isWishlistLoading = false;
        notifyListeners();
      },
    );
  }

  void clearData() {
    _auctionDetail = null;
    _errorMessage = null;
    _isLoading = false;
    _bidHistory = [];
    _wishlist = [];
    notifyListeners();
  }
}
