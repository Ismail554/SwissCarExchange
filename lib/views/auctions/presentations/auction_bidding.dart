import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rionydo/app_utils/constants/font_manager.dart';
import 'package:rionydo/app_utils/utils/app_colors.dart';
import 'package:rionydo/core/widgets/custom_button.dart';
import 'package:rionydo/core/widgets/custom_back_button.dart';
import 'package:rionydo/core/widgets/widget_snackbar.dart';

import 'package:rionydo/views/auctions/widgets/auction_countdown.dart';
import 'package:rionydo/models/auctions/my_auctions_response.dart';
import 'package:rionydo/models/auctions/auctions_detail_response.dart';
import 'package:rionydo/models/auctions/auction_image.dart';
import 'package:rionydo/models/bid/bid_history_response.dart';
import 'package:rionydo/controllers/auctions/auctions_detail_provider.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:rionydo/app_utils/socket_service.dart';

class AuctionBidding extends StatefulWidget {
  final AuctionItem initialData;
  final AuctionDetailResponse? detailData;

  const AuctionBidding({super.key, required this.initialData, this.detailData});

  @override
  State<AuctionBidding> createState() => _AuctionBiddingState();
}

class _AuctionBiddingState extends State<AuctionBidding> {
  bool _isAutoBidEnabled = false;
  late int _currentBid;
  late int _userBid;
  final int _minIncrement = 150;
  StreamSubscription? _socketSubscription;
  bool _isBidding = false;
  bool _isAuctionEnded = false;
  bool _isSettingAutoBid = false;
  final TextEditingController _maxBidController = TextEditingController();

  String get _auctionId => widget.initialData.id.toString();

  double _parseBid(String value) {
    String cleanValue = value.replaceAll(',', '');
    return double.tryParse(cleanValue) ?? 0.0;
  }

  @override
  void initState() {
    super.initState();
    final bidStr =
        widget.detailData?.currentHighestBid ??
        widget.initialData.currentHighestBid ??
        widget.initialData.reservePrice;

    _currentBid = _parseBid(bidStr).toInt();
    _userBid = _currentBid + _minIncrement;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<AuctionsDetailProvider>();
      provider.fetchAuctionDetail(_auctionId);
      provider.fetchBidHistory(_auctionId);
    });

    // Connect to WebSocket and listen for events
    SocketService.instance.connectToAuction(_auctionId);
    _socketSubscription = SocketService.instance.events.listen(_onSocketEvent);
  }

  void _onSocketEvent(Map<String, dynamic> data) {
    if (!mounted) return;

    final type = data['type'];
    final payload = data['payload'] ?? {};

    switch (type) {
      case 'auction.new_bid':
        final newAmountStr = payload['amount']?.toString() ?? "0";
        final newAmount = _parseBid(newAmountStr).toInt();

        // Add to local bid history
        final bidItem = BidItem(
          bidderAlias: payload['bidder_alias']?.toString() ?? 'Unknown',
          isMe: false,
          increment: payload['increment']?.toString() ?? '0',
          amountAfter: newAmountStr,
          createdAt: DateTime.tryParse(payload['created_at']?.toString() ?? '') ?? DateTime.now(),
        );
        context.read<AuctionsDetailProvider>().addBidToHistory(bidItem);

        setState(() {
          _currentBid = newAmount;
          if (_userBid <= _currentBid) {
            _userBid = _currentBid + _minIncrement;
          }
        });
        break;

      case 'user.outbid':
        final newAmt = payload['new_amount']?.toString() ?? '';
        AppSnackBar.warning(context, "You've been outbid! New highest: CHF $newAmt");
        break;

      case 'auction.completed':
        final status = payload['status']?.toString() ?? 'ended';
        setState(() => _isAuctionEnded = true);
        AppSnackBar.info(context, "This auction has ended ($status).");
        break;

      case 'user.won':
        final finalAmt = payload['final_amount']?.toString() ?? '';
        setState(() => _isAuctionEnded = true);
        AppSnackBar.success(context, "Congratulations! You won for CHF $finalAmt!");
        break;

      case 'auction.withdrawn':
        setState(() => _isAuctionEnded = true);
        AppSnackBar.error(context, "This auction has been withdrawn.");
        break;
    }
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inSeconds < 60) return '${diff.inSeconds}s ago';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  @override
  void dispose() {
    _socketSubscription?.cancel();
    _maxBidController.dispose();
    SocketService.instance.disconnect();
    super.dispose();
  }

  String _formatCurrency(int amount) {
    final str = amount.toString();
    if (str.length > 3) {
      return "${str.substring(0, str.length - 3)},${str.substring(str.length - 3)}";
    }
    return str;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: CustomScrollView(
        slivers: [
          // Header image and app bar
          SliverAppBar(
            backgroundColor: AppColors.primaryColor,
            expandedHeight: 300.h,
            pinned: true,
            leading: Padding(
              padding: EdgeInsets.only(left: 6.w),
              child: Align(
                alignment: Alignment.centerLeft,
                child: CustomBackButton(),
              ),
            ),
            leadingWidth: 64.w,
            title: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.sceGold, width: 1),
                borderRadius: BorderRadius.circular(20.r),
                color: AppColors.sceCardBg.withOpacity(0.8),
              ),
              child: Text(
                "3. LIVE BIDDING",
                style: FontManager.labelSmall(color: AppColors.sceGold),
              ),
            ),
            centerTitle: true,
            actions: [
              Padding(
                padding: EdgeInsets.only(right: 16.w, top: 8.h, bottom: 8.h),
                child: CircleAvatar(
                  backgroundColor: AppColors.sceCardBg.withOpacity(0.8),
                  child: Consumer<AuctionsDetailProvider>(
                    builder: (context, provider, child) {
                      final detail = provider.auctionDetail;
                      final isWatchlisted = detail?.isWatchlisted ?? false;

                      return IconButton(
                        icon: Icon(
                          isWatchlisted
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: isWatchlisted
                              ? AppColors.errorRed
                              : Colors.white,
                          size: 20,
                        ),
                        onPressed: () async {
                          final success = await provider.toggleWatchlist(
                            widget.initialData.id.toString(),
                          );

                          if (success && context.mounted) {
                            AppSnackBar.success(
                              context,
                              isWatchlisted
                                  ? "Removed from watchlist"
                                  : "Added to watchlist",
                            );
                          }
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 20.h),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                    ),
                    child: () {
                      final images =
                          widget.detailData?.images ??
                          widget.initialData.images;
                      return Image.network(
                        images.isNotEmpty
                            ? images.first.url
                            : "https://images.unsplash.com/photo-1620314764415-195d63e1c2a7",
                        fit: BoxFit.cover,
                      );
                    }(),
                  ),
                  if (_isAutoBidEnabled)
                    Positioned(
                      top: 100.h,
                      left: 16.w,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.sceTeal,
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.trending_up,
                              color: Colors.white,
                              size: 14.sp,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              "Auto Bid Enabled",
                              style: FontManager.labelSmall(
                                color: Colors.white,
                              ).copyWith(fontSize: 10.sp),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Lot Info
                  Text(
                    widget.detailData?.title ?? widget.initialData.title,
                    style: FontManager.heading2(color: Colors.white),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    "Lot €4557",
                    style: FontManager.bodySmall(color: AppColors.textHint),
                  ),
                  SizedBox(height: 16.h),

                  // Current Bid
                  Text(
                    "CURRENT BID",
                    style: FontManager.labelSmall(
                      color: AppColors.textHint,
                    ).copyWith(letterSpacing: 0.5),
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        "CHF ",
                        style: FontManager.heading2(color: Colors.white),
                      ),
                      Text(
                        _formatCurrency(_currentBid),
                        style: FontManager.heading1(
                          color: AppColors.sceTeal,
                        ).copyWith(fontSize: 32.sp),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),

                  // Time Remaining
                  Text(
                    "TIME REMAINING",
                    style: FontManager.labelSmall(
                      color: AppColors.textHint,
                    ).copyWith(letterSpacing: 0.5),
                  ),
                  SizedBox(height: 8.h),
                  AuctionCountdown(
                    endTime:
                        widget.detailData?.endsAt ?? widget.initialData.endsAt,
                  ),
                  SizedBox(height: 24.h),

                  // Recent Bids Header
                  Row(
                    children: [
                      Container(
                        width: 3.w,
                        height: 16.h,
                        color: AppColors.sceTeal,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        "RECENT BIDS",
                        style: FontManager.labelMedium(
                          color: Colors.white,
                        ).copyWith(letterSpacing: 0.5),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),

                  // Recent Bids List (from API + live socket)
                  Consumer<AuctionsDetailProvider>(
                    builder: (context, provider, _) {
                      if (provider.isBidHistoryLoading && provider.bidHistory.isEmpty) {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          child: const Center(
                            child: CircularProgressIndicator(color: AppColors.sceTeal),
                          ),
                        );
                      }
                      if (provider.bidHistory.isEmpty) {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          child: Center(
                            child: Text(
                              "No bids yet. Be the first!",
                              style: FontManager.bodySmall(color: AppColors.textHint),
                            ),
                          ),
                        );
                      }
                      final bids = provider.bidHistory.take(5).toList();
                      return Column(
                        children: bids.map((bid) {
                          final gradient = bid.isMe
                              ? const LinearGradient(colors: [Colors.grey, Colors.blueGrey])
                              : LinearGradient(colors: [
                                  Colors.primaries[bid.bidderAlias.hashCode.abs() % Colors.primaries.length],
                                  Colors.primaries[(bid.bidderAlias.hashCode.abs() + 3) % Colors.primaries.length],
                                ]);
                          final amount = _formatCurrency(_parseBid(bid.amountAfter).toInt());
                          return _buildBidTile(
                            bid.isMe ? "You" : bid.bidderAlias,
                            _timeAgo(bid.createdAt),
                            amount,
                            gradient,
                          );
                        }).toList(),
                      );
                    },
                  ),
                  SizedBox(height: 24.h),

                  // Your Bid Header
                  Text(
                    "Your Bid",
                    style: FontManager.labelMedium(color: Colors.white),
                  ),
                  SizedBox(height: 12.h),

                  // Bid Input Container
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 12.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.sceCardBg,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: Colors.white.withOpacity(0.05)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "CHF",
                          style: FontManager.labelSmall(
                            color: AppColors.textHint,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _formatCurrency(_userBid),
                              style: FontManager.heading1(
                                color: Colors.white,
                              ).copyWith(color: Colors.white.withOpacity(0.4)),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _userBid += _minIncrement;
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.all(8.w),
                                decoration: BoxDecoration(
                                  color: AppColors.sceTeal,
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12.h),
                        Container(
                          padding: EdgeInsets.all(12.w),
                          decoration: BoxDecoration(
                            color: AppColors.sceTealStatBg,
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(
                              color: AppColors.sceTeal.withOpacity(0.2),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Minimum bid increment: CHF 150",
                                    style: FontManager.bodySmall(
                                      color: AppColors.sceTeal,
                                    ).copyWith(fontSize: 11.sp),
                                  ),
                                  SizedBox(height: 2.h),
                                  Text(
                                    "Next minimum bid: CHF ${_formatCurrency(_currentBid + _minIncrement)}",
                                    style: FontManager.bodySmall(
                                      color: AppColors.textHint,
                                    ).copyWith(fontSize: 11.sp),
                                  ),
                                ],
                              ),
                              GestureDetector(
                                onTap: () {
                                  final minAllowed = _currentBid + _minIncrement;
                                  if (_userBid - _minIncrement >= minAllowed) {
                                    setState(() {
                                      _userBid -= _minIncrement;
                                    });
                                  }
                                },
                                child: Container(
                                  padding: EdgeInsets.all(8.w),
                                  decoration: BoxDecoration(
                                    color: (_userBid - _minIncrement >= _currentBid + _minIncrement)
                                        ? AppColors.sceTeal
                                        : AppColors.sceTeal.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  child: Icon(
                                    Icons.remove,
                                    color: Colors.white,
                                    size: 20.sp,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.h),

                  // Quick Bids Header
                  Text(
                    "Quick Bids",
                    style: FontManager.labelSmall(color: AppColors.textHint),
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      Expanded(child: _buildQuickBidButton(150)),
                      SizedBox(width: 12.w),
                      Expanded(child: _buildQuickBidButton(300)),
                      SizedBox(width: 12.w),
                      Expanded(child: _buildQuickBidButton(500)),
                    ],
                  ),
                  SizedBox(height: 24.h),

                  // Place Bid Button
                  CustomButton(
                    text: _isAuctionEnded ? "AUCTION ENDED" : "PLACE BID",
                    isLoading: _isBidding,
                    isActive: !_isAuctionEnded,
                    onPressed: () async {
                      setState(() => _isBidding = true);
                      final provider = context.read<AuctionsDetailProvider>();
                      final success = await provider.placeBid(_auctionId, _userBid);

                      if (mounted) {
                        setState(() => _isBidding = false);
                        if (success) {
                          AppSnackBar.success(context, "Bid placed successfully!");
                          provider.fetchBidHistory(_auctionId);
                        } else {
                          AppSnackBar.error(context, "Failed to place bid.");
                        }
                      }
                    },
                  ),
                  SizedBox(height: 24.h),

                  // Auto Bid Section
                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: AppColors.sceTealStatBg.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: AppColors.sceTeal.withOpacity(0.2),
                      ),
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          height: 24.w,
                          width: 24.w,
                          child: Checkbox(
                            value: _isAutoBidEnabled,
                            onChanged: _isAuctionEnded
                                ? null
                                : (bool? value) async {
                                    final newVal = value ?? false;
                                    if (!newVal) {
                                      // Disable auto bid
                                      final provider = context.read<AuctionsDetailProvider>();
                                      await provider.deleteAutoBid(_auctionId);
                                      if (mounted) {
                                        setState(() => _isAutoBidEnabled = false);
                                        AppSnackBar.info(context, "Auto bid disabled.");
                                      }
                                    } else {
                                      setState(() => _isAutoBidEnabled = true);
                                    }
                                  },
                            activeColor: AppColors.sceTeal,
                            checkColor: Colors.white,
                            side: BorderSide(
                              color: AppColors.sceTeal.withOpacity(0.5),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Text(
                          "Enable Auto Bidding",
                          style: FontManager.labelMedium(
                            color: AppColors.sceTeal,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Max Bid Amount Container
                  if (_isAutoBidEnabled) ...[
                    SizedBox(height: 16.h),
                    Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: AppColors.sceCardBg.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.05),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "MAXIMUM BID AMOUNT",
                            style: FontManager.labelSmall(
                              color: AppColors.sceTeal,
                            ).copyWith(letterSpacing: 0.5),
                          ),
                          SizedBox(height: 12.h),
                          Row(
                            children: [
                              Text(
                                "CHF",
                                style: FontManager.labelLarge(
                                  color: AppColors.textHint,
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: TextField(
                                  controller: _maxBidController,
                                  keyboardType: TextInputType.number,
                                  style: FontManager.bodyMedium(color: Colors.white),
                                  decoration: InputDecoration(
                                    hintText: "e.g. ${_formatCurrency(_currentBid + 1000)}",
                                    hintStyle: FontManager.bodyMedium(color: AppColors.textHint),
                                    filled: true,
                                    fillColor: Colors.white.withOpacity(0.05),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.r),
                                      borderSide: BorderSide.none,
                                    ),
                                    contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12.h),
                          Text(
                            "System will automatically bid up to this amount in CHF 150 increments",
                            style: FontManager.bodySmall(
                              color: AppColors.textHint,
                            ).copyWith(fontSize: 12.sp),
                          ),
                          SizedBox(height: 12.h),
                          CustomButton(
                            text: "SET AUTO BID",
                            isLoading: _isSettingAutoBid,
                            onPressed: () async {
                              final maxStr = _maxBidController.text.replaceAll(',', '').trim();
                              final maxAmount = int.tryParse(maxStr);
                              if (maxAmount == null || maxAmount <= _currentBid) {
                                AppSnackBar.error(context, "Enter a valid amount above CHF ${_formatCurrency(_currentBid)}");
                                return;
                              }
                              setState(() => _isSettingAutoBid = true);
                              final provider = context.read<AuctionsDetailProvider>();
                              final success = await provider.createAutoBid(_auctionId, maxAmount);
                              if (mounted) {
                                setState(() => _isSettingAutoBid = false);
                                if (success) {
                                  AppSnackBar.success(context, "Auto bid set up to CHF ${_formatCurrency(maxAmount)}");
                                } else {
                                  AppSnackBar.error(context, "Failed to set auto bid.");
                                }
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                  SizedBox(height: 48.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBidTile(
    String name,
    String time,
    String amount,
    Gradient gradient,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.sceCardBg,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          Container(
            width: 32.w,
            height: 32.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: gradient,
            ),
          ),
          SizedBox(width: 12.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: FontManager.labelMedium(color: Colors.white)),
              SizedBox(height: 2.h),
              Text(
                time,
                style: FontManager.bodySmall(
                  color: AppColors.textHint,
                ).copyWith(fontSize: 11.sp),
              ),
            ],
          ),
          const Spacer(),
          Text(amount, style: FontManager.heading3(color: AppColors.sceTeal)),
        ],
      ),
    );
  }

  Widget _buildQuickBidButton(int increment) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _userBid += increment;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        alignment: Alignment.center,
        child: Text(
          "+$increment",
          style: FontManager.labelMedium(color: Colors.white),
        ),
      ),
    );
  }
}
