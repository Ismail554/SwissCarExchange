import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rionydo/app_utils/constants/font_manager.dart';
import 'package:rionydo/app_utils/utils/app_colors.dart';
import 'package:rionydo/core/widgets/custom_button.dart';
import 'package:rionydo/core/widgets/custom_back_button.dart';
import 'package:rionydo/core/widgets/widget_snackbar.dart';

import 'package:rionydo/views/auctions/widgets/auction_countdown.dart';
import 'package:rionydo/models/auctions/my_auctions_response.dart';
import 'package:rionydo/models/auctions/auctions_detail_response.dart';
import 'package:rionydo/models/bid/bid_history_response.dart';
import 'package:rionydo/controllers/auctions/auctions_detail_provider.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:rionydo/services/socket_service.dart';
import 'package:rionydo/views/auctions/widgets/video_player_widget.dart';

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
  int _minIncrement = 150;
  StreamSubscription? _socketSubscription;
  bool _isBidding = false;
  bool _isAuctionEnded = false;
  bool _isSettingAutoBid = false;
  bool _isOwner = false;
  final TextEditingController _maxBidController = TextEditingController();

  String get _auctionId => widget.initialData.id.toString();

  double _parseBid(String value) {
    String cleanValue = value.replaceAll(',', '');
    return double.tryParse(cleanValue) ?? 0.0;
  }

  @override
  void initState() {
    super.initState();
    // Initialise increment from pre-fetched detail if available, else 150
    final rawIncrement = widget.detailData?.minBidIncrement ?? '150';
    final parsed = _parseBid(rawIncrement).toInt();
    _minIncrement = parsed > 0 ? parsed : 150;

    // Determine owner status from pre-fetched detail
    _isOwner = widget.detailData?.isOwner ?? false;

    final bidStr =
        widget.detailData?.currentHighestBid ??
        widget.initialData.currentHighestBid ??
        widget.initialData.reservePrice;

    _currentBid = _parseBid(bidStr).toInt();

    final initialBidders =
        widget.detailData?.totalBidders ?? widget.initialData.totalBidders;
    if (initialBidders == 0) {
      _userBid = _currentBid;
    } else {
      _userBid = _currentBid + _minIncrement;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = context.read<AuctionsDetailProvider>();
      await provider.fetchAuctionDetail(_auctionId);
      await provider.fetchBidHistory(_auctionId);
      if (!mounted) return;

      final detail = provider.auctionDetail;
      final noBidsYet =
          provider.bidHistory.isEmpty &&
          (detail?.totalBidders ?? initialBidders) == 0;

      setState(() {
        if (detail != null) {
          final inc = _parseBid(detail.minBidIncrement).toInt();
          if (inc > 0) _minIncrement = inc;

          final bidStr = detail.currentHighestBid ?? detail.reservePrice;
          _currentBid = _parseBid(bidStr).toInt();

          // Refresh owner status from fresh API response
          _isOwner = detail.isOwner;
        }

        if (noBidsYet) {
          _userBid = _currentBid;
        } else {
          _userBid = _currentBid + _minIncrement;
        }
      });
    });

    // Connect to WebSocket and listen for events
    SocketService.instance.connectToAuction(_auctionId);
    _socketSubscription = SocketService.instance.events.listen(_onSocketEvent);
  }

  void _onSocketEvent(Map<String, dynamic> data) {
    if (!mounted) return;

    // Check if the screen is currently active (not pushed under another route)
    final bool isCurrentRoute = ModalRoute.of(context)?.isCurrent ?? false;

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
          createdAt:
              DateTime.tryParse(payload['created_at']?.toString() ?? '') ??
              DateTime.now(),
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
        if (isCurrentRoute) {
          AppSnackBar.warning(
            context,
            "You've been outbid! New highest: CHF $newAmt",
          );
        }
        break;

      case 'auction.completed':
        final status = payload['status']?.toString() ?? 'ended';
        setState(() => _isAuctionEnded = true);
        if (isCurrentRoute) {
          AppSnackBar.info(context, "This auction has ended ($status).");
        }
        break;

      case 'user.won':
        final finalAmt = payload['final_amount']?.toString() ?? '';
        setState(() => _isAuctionEnded = true);
        if (isCurrentRoute) {
          AppSnackBar.success(
            context,
            "Congratulations! You won for CHF $finalAmt!",
          );
        }
        break;

      case 'auction.withdrawn':
        setState(() => _isAuctionEnded = true);
        if (isCurrentRoute) {
          AppSnackBar.error(context, "This auction has been withdrawn.");
        }
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

  Future<void> _executeBid() async {
    setState(() => _isBidding = true);
    final provider = context.read<AuctionsDetailProvider>();
    final localContext = context;
    final success = await provider.placeBid(_auctionId, _userBid);

    if (!localContext.mounted) return;
    setState(() => _isBidding = false);
    if (success) {
      AppSnackBar.success(localContext, "Bid placed successfully!");
      provider.fetchBidHistory(_auctionId);
    } else {
      AppSnackBar.error(localContext, "Failed to place bid.");
    }
  }

  void _showBidConfirmation() {
    final provider = context.read<AuctionsDetailProvider>();
    final noBidsYet =
        provider.bidHistory.isEmpty &&
        (provider.auctionDetail?.totalBidders ??
                widget.detailData?.totalBidders ??
                widget.initialData.totalBidders) ==
            0;
    final minAllowed = noBidsYet ? _currentBid : _currentBid + _minIncrement;

    if (_userBid < minAllowed) {
      final msg = noBidsYet
          ? "Be the first one to bid! Minimum is CHF ${_formatCurrency(minAllowed)}"
          : "Bid must be at least CHF ${_formatCurrency(minAllowed)}";
      AppSnackBar.warning(context, msg);
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => _BidConfirmationDialog(
        bidAmount: _userBid,
        formattedAmount: _formatCurrency(_userBid),
        onConfirm: () {
          Navigator.of(dialogContext).pop();
          _executeBid();
        },
      ),
    );
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
                color: AppColors.sceCardBg.withValues(alpha: 0.8),
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
                  backgroundColor: AppColors.sceCardBg.withValues(alpha: 0.8),
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
                      color: Colors.white.withValues(alpha: 0.1),
                    ),
                    child:
                        (widget.detailData?.images ?? widget.initialData.images)
                            .isNotEmpty
                        ? Image.network(
                            (widget.detailData?.images ??
                                    widget.initialData.images)
                                .first
                                .url,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                                  color: Colors.white10,
                                  child: const Icon(
                                    Icons.image_not_supported_outlined,
                                    color: Colors.white24,
                                  ),
                                ),
                          )
                        : Container(
                            color: Colors.white10,
                            child: const Icon(
                              Icons.image_not_supported_outlined,
                              color: Colors.white24,
                            ),
                          ),
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
                  // Video play button (centered)
                  if ((widget.detailData?.videoUrl ?? '').isNotEmpty)
                    Positioned.fill(
                      child: Center(
                        child: VideoPlayButton(
                          videoUrl: widget.detailData!.videoUrl!,
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
                  SizedBox(height: 16.h),

                  Consumer<AuctionsDetailProvider>(
                    builder: (context, provider, _) {
                      final noBidsYet =
                          provider.bidHistory.isEmpty &&
                          (provider.auctionDetail?.totalBidders ??
                                  widget.detailData?.totalBidders ??
                                  widget.initialData.totalBidders) ==
                              0;

                      return Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: AppColors.sceTealStatBg,
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: AppColors.sceTeal.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              noBidsYet
                                  ? "BIDS START FROM"
                                  : "CURRENT HIGHEST BID",
                              style: FontManager.labelSmall(
                                color: AppColors.sceTeal,
                              ).copyWith(letterSpacing: 1.2),
                            ),
                            SizedBox(height: 4.h),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                Text(
                                  "CHF ",
                                  style: FontManager.heading1(
                                    color: Colors.white,
                                  ),
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
                            Text(
                              "TIME REMAINING",
                              style: FontManager.labelSmall(
                                color: AppColors.textHint,
                              ).copyWith(letterSpacing: 1.2),
                            ),
                            SizedBox(height: 8.h),
                            AuctionCountdown(
                              endTime:
                                  widget.detailData?.endsAt ??
                                  widget.initialData.endsAt,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 24.h),

                  // Recent Bids (Header & List combined in a Consumer for dynamic "See All")
                  Consumer<AuctionsDetailProvider>(
                    builder: (context, provider, _) {
                      final hasBids = provider.bidHistory.isNotEmpty;
                      final showSeeAll =
                          hasBids && provider.bidHistory.length > 4;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
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
                            ],
                          ),
                          SizedBox(height: 12.h),
                          if (provider.isBidHistoryLoading &&
                              provider.bidHistory.isEmpty)
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 16.h),
                              child: const Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.sceTeal,
                                ),
                              ),
                            )
                          else if (provider.bidHistory.isEmpty)
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 16.h),
                              child: Center(
                                child: Text(
                                  "No bids yet. Be the first!",
                                  style: FontManager.bodySmall(
                                    color: AppColors.textHint,
                                  ),
                                ),
                              ),
                            )
                          else
                            Column(
                              children: [
                                ...provider.bidHistory.take(4).map((bid) {
                                  final gradient = bid.isMe
                                      ? const LinearGradient(
                                          colors: [
                                            Colors.grey,
                                            Colors.blueGrey,
                                          ],
                                        )
                                      : LinearGradient(
                                          colors: [
                                            Colors.primaries[bid
                                                    .bidderAlias
                                                    .hashCode
                                                    .abs() %
                                                Colors.primaries.length],
                                            Colors.primaries[(bid
                                                        .bidderAlias
                                                        .hashCode
                                                        .abs() +
                                                    3) %
                                                Colors.primaries.length],
                                          ],
                                        );
                                  final amount = _formatCurrency(
                                    _parseBid(bid.amountAfter).toInt(),
                                  );
                                  return _buildBidTile(
                                    bid.isMe ? "You" : bid.bidderAlias,
                                    _timeAgo(bid.createdAt),
                                    amount,
                                    gradient,
                                  );
                                }),
                                if (showSeeAll) ...[
                                  Align(
                                    alignment: Alignment.center,
                                    child: GestureDetector(
                                      onTap: () {
                                        context.push('/all-bids/$_auctionId');
                                      },
                                      child: Text(
                                        "View more...",
                                        style:
                                            FontManager.bodyMedium(
                                              color: AppColors.sceTeal,
                                            ).copyWith(
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: 0.5,
                                            ),
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                        ],
                      );
                    },
                  ),
                  SizedBox(height: 24.h),

                  if (!_isOwner) ...[
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
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.05),
                      ),
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
                                color: AppColors.sceGold,
                              ),
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
                              color: AppColors.sceTeal.withValues(alpha: 0.2),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Minimum bid increment: CHF ${_formatCurrency(_minIncrement)}",
                                    style: FontManager.bodySmall(
                                      color: AppColors.sceTeal,
                                    ).copyWith(fontSize: 11.sp),
                                  ),
                                  SizedBox(height: 2.h),
                                  Consumer<AuctionsDetailProvider>(
                                    builder: (context, provider, _) {
                                      final noBidsYet =
                                          provider.bidHistory.isEmpty &&
                                          (provider
                                                      .auctionDetail
                                                      ?.totalBidders ??
                                                  widget
                                                      .detailData
                                                      ?.totalBidders ??
                                                  widget
                                                      .initialData
                                                      .totalBidders) ==
                                              0;
                                      return Text(
                                        noBidsYet
                                            ? "Next minimum bid: CHF ${_formatCurrency(_currentBid)}"
                                            : "Next minimum bid: CHF ${_formatCurrency(_currentBid + _minIncrement)}",
                                        style: FontManager.bodySmall(
                                          color: AppColors.textHint,
                                        ).copyWith(fontSize: 11.sp),
                                      );
                                    },
                                  ),
                                ],
                              ),
                              GestureDetector(
                                onTap: () {
                                  final provider = context
                                      .read<AuctionsDetailProvider>();
                                  final noBidsYet =
                                      (provider.auctionDetail?.totalBidders ??
                                          widget.detailData?.totalBidders ??
                                          widget.initialData.totalBidders) ==
                                      0;
                                  final minAllowed = noBidsYet
                                      ? _currentBid
                                      : _currentBid + _minIncrement;
                                  if (_userBid - _minIncrement >= minAllowed) {
                                    setState(() {
                                      _userBid -= _minIncrement;
                                    });
                                  }
                                },
                                child: Container(
                                  padding: EdgeInsets.all(8.w),
                                  decoration: BoxDecoration(
                                    color: (() {
                                      final provider = context
                                          .read<AuctionsDetailProvider>();
                                      final noBidsYet =
                                          (provider
                                                  .auctionDetail
                                                  ?.totalBidders ??
                                              widget.detailData?.totalBidders ??
                                              widget
                                                  .initialData
                                                  .totalBidders) ==
                                          0;
                                      final minAllowed = noBidsYet
                                          ? _currentBid
                                          : _currentBid + _minIncrement;
                                      return _userBid - _minIncrement >=
                                              minAllowed
                                          ? AppColors.sceTeal
                                          : AppColors.sceTeal.withValues(
                                              alpha: 0.3,
                                            );
                                    })(),
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
                      Expanded(child: _buildQuickBidButton(_minIncrement)),
                      SizedBox(width: 12.w),
                      Expanded(child: _buildQuickBidButton(_minIncrement * 2)),
                      SizedBox(width: 12.w),
                      Expanded(child: _buildQuickBidButton(_minIncrement * 3)),
                    ],
                  ),
                  SizedBox(height: 24.h),

                  // Place Bid Button
                  if (_isOwner)
                    GestureDetector(
                      onTap: () {
                        AppSnackBar.warning(
                          context,
                          "You cannot bid on your own auction.",
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        decoration: BoxDecoration(
                          color: AppColors.sceGold.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(14.r),
                          border: Border.all(
                            color: AppColors.sceGold.withValues(alpha: 0.35),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.workspace_premium_rounded,
                              color: AppColors.sceGold,
                              size: 16.sp,
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              "YOUR AUCTION — BIDS LOCKED",
                              style: FontManager.labelMedium(
                                color: AppColors.sceGold,
                              ).copyWith(
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    CustomButton(
                      text: _isAuctionEnded ? "AUCTION ENDED" : "PLACE BID",
                      isLoading: _isBidding,
                      isActive: !_isAuctionEnded,
                      onPressed: _showBidConfirmation,
                    ),
                  SizedBox(height: 24.h),

                  // Auto Bid Section
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _isAuctionEnded
                          ? null
                          : () async {
                              final newVal = !_isAutoBidEnabled;
                              if (!newVal) {
                                // Disable auto bid
                                final provider = context
                                    .read<AuctionsDetailProvider>();
                                await provider.deleteAutoBid(_auctionId);
                                if (!context.mounted) return;
                                setState(() => _isAutoBidEnabled = false);
                                AppSnackBar.info(context, "Auto bid disabled.");
                              } else {
                                setState(() => _isAutoBidEnabled = true);
                              }
                            },
                      borderRadius: BorderRadius.circular(12.r),
                      child: Ink(
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: AppColors.sceTealStatBg.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: AppColors.sceTeal.withValues(alpha: 0.2),
                          ),
                        ),
                        child: Row(
                          children: [
                            IgnorePointer(
                              child: SizedBox(
                                height: 24.w,
                                width: 24.w,
                                child: Checkbox(
                                  value: _isAutoBidEnabled,
                                  onChanged: _isAuctionEnded ? null : (_) {},
                                  activeColor: AppColors.sceTeal,
                                  checkColor: Colors.white,
                                  side: BorderSide(
                                    color: AppColors.sceTeal.withValues(
                                      alpha: 0.5,
                                    ),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4.r),
                                  ),
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
                    ),
                  ),

                  // Max Bid Amount Container
                  if (_isAutoBidEnabled) ...[
                    SizedBox(height: 16.h),
                    Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: AppColors.sceCardBg.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.05),
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
                                  style: FontManager.bodyMedium(
                                    color: Colors.white,
                                  ),
                                  decoration: InputDecoration(
                                    hintText:
                                        "e.g. ${_formatCurrency(_currentBid + 1000)}",
                                    hintStyle: FontManager.bodyMedium(
                                      color: AppColors.textHint,
                                    ),
                                    filled: true,
                                    fillColor: Colors.white.withValues(
                                      alpha: 0.05,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.r),
                                      borderSide: BorderSide.none,
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 16.w,
                                      vertical: 12.h,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12.h),
                          Text(
                            "System will automatically bid up to this amount in CHF ${_formatCurrency(_minIncrement)} increments",
                            style: FontManager.bodySmall(
                              color: AppColors.textHint,
                            ).copyWith(fontSize: 12.sp),
                          ),
                          SizedBox(height: 12.h),
                          CustomButton(
                            text: "SET AUTO BID",
                            isLoading: _isSettingAutoBid,
                            onPressed: () async {
                              final maxStr = _maxBidController.text
                                  .replaceAll(',', '')
                                  .trim();
                              final maxAmount = int.tryParse(maxStr);
                              if (maxAmount == null ||
                                  maxAmount <= _currentBid) {
                                AppSnackBar.error(
                                  context,
                                  "Enter a valid amount above CHF ${_formatCurrency(_currentBid)}",
                                );
                                return;
                              }
                              setState(() => _isSettingAutoBid = true);
                              final localContext = context;
                              final provider = localContext
                                  .read<AuctionsDetailProvider>();
                              final success = await provider.createAutoBid(
                                _auctionId,
                                maxAmount,
                              );
                              if (!localContext.mounted) return;
                              setState(() => _isSettingAutoBid = false);
                              if (success) {
                                AppSnackBar.success(
                                  localContext,
                                  "Auto bid set up to CHF ${_formatCurrency(maxAmount)}",
                                );
                              } else {
                                AppSnackBar.error(
                                  localContext,
                                  "Failed to set auto bid.", // message from the api
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                  // end if (!_isOwner)
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
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
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
          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
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

class _BidConfirmationDialog extends StatefulWidget {
  final int bidAmount;
  final String formattedAmount;
  final VoidCallback onConfirm;

  const _BidConfirmationDialog({
    required this.bidAmount,
    required this.formattedAmount,
    required this.onConfirm,
  });

  @override
  State<_BidConfirmationDialog> createState() => _BidConfirmationDialogState();
}

class _BidConfirmationDialogState extends State<_BidConfirmationDialog>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  Timer? _autoCloseTimer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..forward();

    _autoCloseTimer = Timer(const Duration(seconds: 5), () {
      if (mounted) Navigator.of(context).pop();
    });
  }

  @override
  void dispose() {
    _autoCloseTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.sceCardBg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
        side: BorderSide(color: AppColors.sceTeal.withValues(alpha: 0.2)),
      ),
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Countdown indicator
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 56.w,
                      height: 56.w,
                      child: CircularProgressIndicator(
                        value: 1.0 - _controller.value,
                        strokeWidth: 3,
                        backgroundColor: Colors.white.withValues(alpha: 0.1),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.sceTeal,
                        ),
                      ),
                    ),
                    Text(
                      '${(5 - (_controller.value * 5)).ceil()}',
                      style: FontManager.heading3(color: AppColors.sceTeal),
                    ),
                  ],
                );
              },
            ),
            SizedBox(height: 20.h),

            Text(
              'Confirm Your Bid',
              style: FontManager.heading3(color: Colors.white),
            ),
            SizedBox(height: 8.h),

            Text(
              'You are about to place a bid of',
              style: FontManager.bodyMedium(color: AppColors.sceGreyA0),
            ),
            SizedBox(height: 12.h),

            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: AppColors.sceTeal.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: AppColors.sceTeal.withValues(alpha: 0.3),
                ),
              ),
              child: Text(
                'CHF ${widget.formattedAmount}',
                style: FontManager.heading2(color: AppColors.sceTeal),
              ),
            ),
            SizedBox(height: 8.h),

            Text(
              'This action cannot be undone.',
              style: FontManager.bodySmall(color: AppColors.errorRed),
            ),
            SizedBox(height: 24.h),

            // Buttons
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    text: 'Cancel',
                    isPrimary: false,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: CustomButton(
                    text: 'Confirm',
                    onPressed: widget.onConfirm,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
