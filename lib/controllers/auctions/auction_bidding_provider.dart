import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rionydo/services/socket_service.dart';
import 'package:rionydo/controllers/auctions/auctions_detail_provider.dart';
import 'package:rionydo/models/auctions/my_auctions_response.dart';
import 'package:rionydo/models/auctions/auctions_detail_response.dart';
import 'package:rionydo/models/bid/bid_history_response.dart';
import 'package:rionydo/core/widgets/widget_snackbar.dart';
import 'package:rionydo/views/auctions/presentations/widgets/auction_bidding/bid_confirmation_dialog.dart';

class AuctionBiddingProvider extends ChangeNotifier {
  final AuctionsDetailProvider detailProvider;
  final String auctionId;
  final Function(String) onOutbid;
  final Function(String) onAuctionEnded;
  final Function(String) onAuctionWon;
  final Function() onAuctionWithdrawn;

  bool isAutoBidEnabled = false;
  int currentBid = 0;
  int userBid = 0;
  int minIncrement = 150;
  bool isBidding = false;
  bool isAuctionEnded = false;
  bool isSettingAutoBid = false;
  bool isOwner = false;
  bool isLoading = true;

  DateTime? _endDate;
  int maxAutoBidAmount = 0;

  bool get isLoadingInitial => isLoading;
  bool get isPlacingBid => isBidding;
  List<BidItem> get bidHistory => detailProvider.bidHistory;
  DateTime? get endDate => _endDate ?? detailProvider.auctionDetail?.endsAt;

  StreamSubscription? _socketSubscription;
  final TextEditingController autoBidController = TextEditingController();

  AuctionBiddingProvider({
    required this.detailProvider,
    required this.auctionId,
    required this.onOutbid,
    required this.onAuctionEnded,
    required this.onAuctionWon,
    required this.onAuctionWithdrawn,
  });

  double _parseBid(String value) {
    String cleanValue = value.replaceAll(',', '');
    return double.tryParse(cleanValue) ?? 0.0;
  }

  void initialize(AuctionItem initialData, AuctionDetailResponse? detailData) {
    _endDate = detailData?.endsAt ?? initialData.endsAt;

    final rawIncrement = detailData?.minBidIncrement ?? '150';
    final parsed = _parseBid(rawIncrement).toInt();
    minIncrement = parsed > 0 ? parsed : 150;

    isOwner = detailData?.isOwner ?? false;
    isAutoBidEnabled = detailData?.myAutoBid != null;
    maxAutoBidAmount = detailData?.myAutoBid?.maxAmount ?? 0;

    final bidStr = detailData?.currentHighestBid ??
        initialData.currentHighestBid ??
        initialData.reservePrice;
    currentBid = _parseBid(bidStr).toInt();

    final initialBidders = detailData?.totalBidders ?? initialData.totalBidders;
    if (initialBidders == 0) {
      userBid = currentBid;
    } else {
      userBid = currentBid + minIncrement;
    }
    
    if (isAutoBidEnabled) {
      autoBidController.text = maxAutoBidAmount.toString();
    } else {
      autoBidController.clear();
    }
    
    notifyListeners();

    _fetchInitialData(initialData.totalBidders);

    SocketService.instance.connectToAuction(auctionId);
    _socketSubscription = SocketService.instance.events.listen(_onSocketEvent);
  }

  Future<void> _fetchInitialData(int initialBidders) async {
    await Future.wait([
      detailProvider.fetchAuctionDetail(auctionId),
      detailProvider.fetchBidHistory(auctionId),
    ]);

    final detail = detailProvider.auctionDetail;
    final noBidsYet = detailProvider.bidHistory.isEmpty &&
        (detail?.totalBidders ?? initialBidders) == 0;

    if (detail != null) {
      final inc = _parseBid(detail.minBidIncrement).toInt();
      if (inc > 0) minIncrement = inc;

      final bidStr = detail.currentHighestBid ?? detail.reservePrice;
      currentBid = _parseBid(bidStr).toInt();
      isOwner = detail.isOwner;
      _endDate = detail.endsAt;
      isAutoBidEnabled = detail.myAutoBid != null;
      maxAutoBidAmount = detail.myAutoBid?.maxAmount ?? 0;
      if (isAutoBidEnabled) {
        autoBidController.text = maxAutoBidAmount.toString();
      } else {
        autoBidController.clear();
      }
    }

    if (noBidsYet) {
      userBid = currentBid;
    } else {
      userBid = currentBid + minIncrement;
    }
    
    isLoading = false;
    notifyListeners();
  }

  void _onSocketEvent(Map<String, dynamic> data) {
    final type = data['type'];
    final payload = data['payload'] ?? {};

    switch (type) {
      case 'auction.new_bid':
        final newAmountStr = payload['amount']?.toString() ?? "0";
        final newAmount = _parseBid(newAmountStr).toInt();

        final bidItem = BidItem(
          bidderAlias: payload['bidder_alias']?.toString() ?? 'Unknown',
          isMe: false,
          increment: payload['increment']?.toString() ?? '0',
          amountAfter: newAmountStr,
          createdAt: DateTime.tryParse(payload['created_at']?.toString() ?? '') ??
              DateTime.now(),
        );
        detailProvider.addBidToHistory(bidItem);

        currentBid = newAmount;
        if (userBid <= currentBid) {
          userBid = currentBid + minIncrement;
        }
        notifyListeners();
        break;

      case 'user.outbid':
        final newAmt = payload['new_amount']?.toString() ?? '';
        onOutbid(newAmt);
        break;

      case 'auction.completed':
        final status = payload['status']?.toString() ?? 'ended';
        isAuctionEnded = true;
        notifyListeners();
        onAuctionEnded(status);
        break;

      case 'user.won':
        final finalAmt = payload['final_amount']?.toString() ?? '';
        isAuctionEnded = true;
        notifyListeners();
        onAuctionWon(finalAmt);
        break;

      case 'auction.withdrawn':
        isAuctionEnded = true;
        notifyListeners();
        onAuctionWithdrawn();
        break;
    }
  }

  void incrementUserBid() {
    userBid += minIncrement;
    notifyListeners();
  }

  void decrementUserBid(int fallbackTotalBidders) {
    final noBidsYet = (detailProvider.auctionDetail?.totalBidders ?? fallbackTotalBidders) == 0;
    final minAllowed = noBidsYet ? currentBid : currentBid + minIncrement;
    if (userBid - minIncrement >= minAllowed) {
      userBid -= minIncrement;
      notifyListeners();
    }
  }

  void addAmountToUserBid(int amount) {
    userBid += amount;
    notifyListeners();
  }

  Future<bool> executeBid() async {
    isBidding = true;
    notifyListeners();

    final success = await detailProvider.placeBid(auctionId, userBid);

    isBidding = false;
    notifyListeners();

    if (success) {
      detailProvider.fetchBidHistory(auctionId);
    }
    return success;
  }

  void updateUserBid(int amount) {
    userBid = amount;
    notifyListeners();
  }

  void toggleAutoBid() {
    if (isAutoBidEnabled) {
      if (detailProvider.auctionDetail?.myAutoBid == null) {
        isAutoBidEnabled = false;
        maxAutoBidAmount = 0;
        autoBidController.clear();
        notifyListeners();
      } else {
        deleteAutoBidOnBackend();
      }
    } else {
      isAutoBidEnabled = true;
      notifyListeners();
    }
  }

  Future<void> deleteAutoBidOnBackend() async {
    isSettingAutoBid = true;
    notifyListeners();
    final success = await detailProvider.deleteAutoBid(auctionId);
    if (success) {
      isAutoBidEnabled = false;
      maxAutoBidAmount = 0;
      autoBidController.clear();
    }
    isSettingAutoBid = false;
    notifyListeners();
  }

  void setMaxAutoBid(int amount) {
    maxAutoBidAmount = amount;
    notifyListeners();
  }

  Future<void> setAutoBid(BuildContext context) async {
    final amtStr = autoBidController.text.replaceAll(',', '');
    final amount = int.tryParse(amtStr) ?? 0;
    if (amount <= currentBid) {
      AppSnackBar.error(context, "Maximum auto bid must be greater than current bid.");
      return;
    }
    isSettingAutoBid = true;
    notifyListeners();
    final success = await detailProvider.createAutoBid(auctionId, amount);
    if (success) {
      maxAutoBidAmount = amount;
      isAutoBidEnabled = true;
    }
    isSettingAutoBid = false;
    notifyListeners();
    if (success && context.mounted) {
      AppSnackBar.success(context, "Auto bid set successfully!");
    } else if (context.mounted) {
      AppSnackBar.error(context, "Failed to set auto bid.");
    }
  }

  void placeBid(BuildContext context) {
    if (isOwner) {
      AppSnackBar.error(context, "You cannot bid on your own auction");
      return;
    }
    final fallbackTotalBidders = detailProvider.auctionDetail?.totalBidders ?? 0;
    final noBidsYet = detailProvider.bidHistory.isEmpty && fallbackTotalBidders == 0;
    final minAllowed = noBidsYet ? currentBid : currentBid + minIncrement;
    if (userBid < minAllowed) {
      AppSnackBar.error(context, "Bid must be at least CHF ${NumberFormat('#,###').format(minAllowed)}");
      return;
    }
    showDialog(
      context: context,
      builder: (dialogContext) => BidConfirmationDialog(
        bidAmount: userBid,
        formattedAmount: NumberFormat('#,###').format(userBid),
        onConfirm: () async {
          Navigator.of(dialogContext).pop();
          final success = await executeBid();
          if (success && context.mounted) {
            AppSnackBar.success(context, "Bid placed successfully!");
          } else if (context.mounted) {
            AppSnackBar.error(context, "Failed to place bid. Please try again.");
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _socketSubscription?.cancel();
    SocketService.instance.disconnect();
    autoBidController.dispose();
    super.dispose();
  }
}
