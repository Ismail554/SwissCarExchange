import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rionydo/app_utils/constants/font_manager.dart';
import 'package:rionydo/app_utils/utils/app_colors.dart';

import 'package:rionydo/core/widgets/custom_button.dart';
import 'package:rionydo/controllers/auctions/auction_bidding_provider.dart';
import 'package:rionydo/controllers/auctions/auctions_detail_provider.dart';
import 'package:rionydo/views/auctions/presentations/widgets/auction_bidding/shimmer_bid_tile.dart';

import 'widgets/auction_bidding/auction_bidding_header.dart';
import 'widgets/auction_bidding/bid_tile.dart';
import 'widgets/auction_bidding/quick_bid_button.dart';

import 'package:rionydo/models/auctions/my_auctions_response.dart';
import 'package:rionydo/models/auctions/auctions_detail_response.dart';

class AuctionBidding extends StatefulWidget {
  final AuctionItem initialData;
  final AuctionDetailResponse? detailData;

  const AuctionBidding({super.key, required this.initialData, this.detailData});

  @override
  State<AuctionBidding> createState() => _AuctionBiddingState();
}

class _AuctionBiddingState extends State<AuctionBidding> {
  late String _auctionId;
  late AuctionsDetailProvider _detailProvider;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _auctionId = widget.initialData.id.toString();
    _detailProvider = context.read<AuctionsDetailProvider>();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuctionBiddingProvider(
        auctionId: _auctionId,
        detailProvider: _detailProvider,
        onOutbid: (amount) {},
        onAuctionEnded: (status) {},
        onAuctionWon: (amount) {},
        onAuctionWithdrawn: () {},
      )..initialize(widget.initialData, widget.detailData),
      child: Scaffold(
        backgroundColor: AppColors.sceDarkBg,
        body: Consumer<AuctionBiddingProvider>(
          builder: (context, provider, child) {
            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // Use extracted Header
                AuctionBiddingHeader(
                  initialData: widget.initialData,
                  detailData:
                      provider.detailProvider.auctionDetail ??
                      widget.detailData,
                  isAutoBidEnabled: provider.isAutoBidEnabled,
                ),

                // Auction Info & Bidding Area
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 16.h,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Status and Time Remaining
                        _buildAuctionStatus(provider),
                        SizedBox(height: 16.h),

                        // Current Bid
                        Text(
                          "CURRENT BID",
                          style: FontManager.labelMedium(
                            color: AppColors.textHint,
                          ).copyWith(letterSpacing: 1.0),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          "CHF ${NumberFormat('#,###').format(provider.currentBid)}",
                          style: FontManager.displayMedium(
                            color: Colors.white,
                            fontSize: 32,
                          ).copyWith(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 24.h),

                        // Bid History Container
                        Container(
                          padding: EdgeInsets.all(16.w),
                          decoration: BoxDecoration(
                            color: AppColors.sceCardBg,
                            borderRadius: BorderRadius.circular(16.r),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.05),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "BID HISTORY",
                                    style: FontManager.labelSmall(
                                      color: AppColors.textHint,
                                    ).copyWith(letterSpacing: 1.0),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8.w,
                                      vertical: 4.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.sceTeal.withValues(
                                        alpha: 0.1,
                                      ),
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                    child: Text(
                                      "${provider.bidHistory.length} Bids",
                                      style: FontManager.labelSmall(
                                        color: AppColors.sceTeal,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 16.h),

                              if (provider.isLoadingInitial)
                                Column(
                                  children: List.generate(
                                    3,
                                    (index) => const ShimmerBidTile(),
                                  ),
                                )
                              else if (provider.bidHistory.isEmpty)
                                Center(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 20.h,
                                    ),
                                    child: Text(
                                      "No bids yet. Be the first!",
                                      style: FontManager.bodyMedium(
                                        color: AppColors.textHint,
                                      ),
                                    ),
                                  ),
                                )
                              else
                                ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: provider.bidHistory.length,
                                  separatorBuilder: (_, _) => Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 8.h,
                                    ),
                                    child: Divider(
                                      color: Colors.white.withValues(
                                        alpha: 0.05,
                                      ),
                                      height: 1,
                                    ),
                                  ),
                                  itemBuilder: (context, index) {
                                    final bid = provider.bidHistory[index];
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

                                    final cleanValue = bid.amountAfter
                                        .replaceAll(',', '');
                                    final doubleAmt =
                                        double.tryParse(cleanValue) ?? 0.0;
                                    final formattedAmount =
                                        "CHF ${NumberFormat('#,###').format(doubleAmt.toInt())}";

                                    final diff = DateTime.now().difference(
                                      bid.createdAt,
                                    );
                                    String timeAgo;
                                    if (diff.inSeconds < 60) {
                                      timeAgo = '${diff.inSeconds}s ago';
                                    } else if (diff.inMinutes < 60) {
                                      timeAgo = '${diff.inMinutes}m ago';
                                    } else if (diff.inHours < 24) {
                                      timeAgo = '${diff.inHours}h ago';
                                    } else {
                                      timeAgo = '${diff.inDays}d ago';
                                    }

                                    return BidTile(
                                      name: bid.isMe ? "You" : bid.bidderAlias,
                                      time: timeAgo,
                                      amount: formattedAmount,
                                      gradient: gradient,
                                    );
                                  },
                                ),
                            ],
                          ),
                        ),
                        SizedBox(height: 32.h),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),

        // Bottom Bidding Action Area
        bottomNavigationBar: Consumer<AuctionBiddingProvider>(
          builder: (context, provider, child) {
            return Container(
              padding: EdgeInsets.fromLTRB(
                20.w,
                16.h,
                20.w,
                MediaQuery.of(context).padding.bottom + 16.h,
              ),
              decoration: BoxDecoration(
                color: AppColors.sceCardBg,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 20,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: SafeArea(
                child: provider.isLoadingInitial
                    ? const Center(child: CircularProgressIndicator())
                    : provider.isOwner
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Owner badge
                          Container(
                            margin: EdgeInsets.only(bottom: 12.h),
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 6.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.sceGold.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(20.r),
                              border: Border.all(
                                color: AppColors.sceGold.withValues(alpha: 0.4),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.workspace_premium_rounded,
                                  color: AppColors.sceGold,
                                  size: 14.sp,
                                ),
                                SizedBox(width: 6.w),
                                Text(
                                  "You are the auction owner",
                                  style: FontManager.labelSmall(
                                    color: AppColors.sceGold,
                                  ).copyWith(fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                          // Back to details button
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(vertical: 16.h),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.sceTeal.withValues(alpha: 0.2),
                                    AppColors.sceTeal.withValues(alpha: 0.05),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(14.r),
                                border: Border.all(
                                  color: AppColors.sceTeal.withValues(
                                    alpha: 0.5,
                                  ),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  "BACK TO DETAILS",
                                  style:
                                      FontManager.labelMedium(
                                        color: AppColors.sceTeal,
                                      ).copyWith(
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.2,
                                      ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Quick Increment Buttons
                          Row(
                            children: [
                              Expanded(
                                child: QuickBidButton(
                                  label: "+CHF 1,000",
                                  onTap: () {
                                    final fallbackTotalBidders =
                                        provider
                                            .detailProvider
                                            .auctionDetail
                                            ?.totalBidders ??
                                        0;
                                    final noBidsYet =
                                        provider.bidHistory.isEmpty &&
                                        fallbackTotalBidders == 0;
                                    final minAllowed = noBidsYet
                                        ? provider.currentBid
                                        : provider.currentBid +
                                              provider.minIncrement;
                                    final base = provider.userBid < minAllowed
                                        ? minAllowed
                                        : provider.userBid;
                                    provider.updateUserBid(base + 1000);
                                  },
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: QuickBidButton(
                                  label: "+CHF 2,000",
                                  onTap: () {
                                    final fallbackTotalBidders =
                                        provider
                                            .detailProvider
                                            .auctionDetail
                                            ?.totalBidders ??
                                        0;
                                    final noBidsYet =
                                        provider.bidHistory.isEmpty &&
                                        fallbackTotalBidders == 0;
                                    final minAllowed = noBidsYet
                                        ? provider.currentBid
                                        : provider.currentBid +
                                              provider.minIncrement;
                                    final base = provider.userBid < minAllowed
                                        ? minAllowed
                                        : provider.userBid;
                                    provider.updateUserBid(base + 2000);
                                  },
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: QuickBidButton(
                                  label: "+CHF 5,000",
                                  onTap: () {
                                    final fallbackTotalBidders =
                                        provider
                                            .detailProvider
                                            .auctionDetail
                                            ?.totalBidders ??
                                        0;
                                    final noBidsYet =
                                        provider.bidHistory.isEmpty &&
                                        fallbackTotalBidders == 0;
                                    final minAllowed = noBidsYet
                                        ? provider.currentBid
                                        : provider.currentBid +
                                              provider.minIncrement;
                                    final base = provider.userBid < minAllowed
                                        ? minAllowed
                                        : provider.userBid;
                                    provider.updateUserBid(base + 5000);
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16.h),

                          // Custom Amount Slider/Input
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 12.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    final fallbackTotalBidders =
                                        provider
                                            .detailProvider
                                            .auctionDetail
                                            ?.totalBidders ??
                                        0;
                                    final noBidsYet =
                                        provider.bidHistory.isEmpty &&
                                        fallbackTotalBidders == 0;
                                    final minAllowed = noBidsYet
                                        ? provider.currentBid
                                        : provider.currentBid +
                                              provider.minIncrement;
                                    if (provider.userBid > minAllowed) {
                                      provider.updateUserBid(
                                        provider.userBid -
                                            provider.minIncrement,
                                      );
                                    }
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(8.w),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(
                                        alpha: 0.1,
                                      ),
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                    child: Icon(
                                      Icons.remove,
                                      color: Colors.white,
                                      size: 20.sp,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "YOUR BID",
                                        style: FontManager.labelSmall(
                                          color: AppColors.textHint,
                                        ),
                                      ),
                                      SizedBox(height: 4.h),
                                      Text(
                                        "CHF ${NumberFormat('#,###').format(provider.userBid)}",
                                        style: FontManager.heading3(
                                          color: Colors.white,
                                        ).copyWith(fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    final fallbackTotalBidders =
                                        provider
                                            .detailProvider
                                            .auctionDetail
                                            ?.totalBidders ??
                                        0;
                                    final noBidsYet =
                                        provider.bidHistory.isEmpty &&
                                        fallbackTotalBidders == 0;
                                    final minAllowed = noBidsYet
                                        ? provider.currentBid
                                        : provider.currentBid +
                                              provider.minIncrement;
                                    final base = provider.userBid < minAllowed
                                        ? minAllowed
                                        : provider.userBid;
                                    provider.updateUserBid(
                                      base + provider.minIncrement,
                                    );
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(8.w),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(
                                        alpha: 0.1,
                                      ),
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                    child: Icon(
                                      Icons.add,
                                      color: Colors.white,
                                      size: 20.sp,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 16.h),

                          // Place Bid Button
                          CustomButton(
                            text: "PLACE BID",
                            isLoading: provider.isPlacingBid,
                            onPressed: () => provider.placeBid(context),
                          ),

                          // Auto Bid Toggle & Section
                          SizedBox(height: 16.h),
                          GestureDetector(
                            onTap: () => provider.toggleAutoBid(),
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 8.h),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 20.w,
                                    height: 20.w,
                                    decoration: BoxDecoration(
                                      color: provider.isAutoBidEnabled
                                          ? AppColors.sceTeal
                                          : Colors.transparent,
                                      border: Border.all(
                                        color: provider.isAutoBidEnabled
                                            ? AppColors.sceTeal
                                            : AppColors.textHint,
                                        width: 1.5,
                                      ),
                                      borderRadius: BorderRadius.circular(4.r),
                                    ),
                                    child: provider.isAutoBidEnabled
                                        ? Icon(
                                            Icons.check,
                                            size: 14.sp,
                                            color: AppColors.sceDarkBg,
                                          )
                                        : null,
                                  ),
                                  SizedBox(width: 12.w),
                                  Text(
                                    "Enable Auto Bidding",
                                    style: FontManager.labelMedium(
                                      color: provider.isAutoBidEnabled
                                          ? AppColors.sceTeal
                                          : AppColors.textHint,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Auto Bid Settings
                          if (provider.isAutoBidEnabled) ...[
                            SizedBox(height: 12.h),
                            Container(
                              padding: EdgeInsets.all(16.w),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.05),
                                borderRadius: BorderRadius.circular(12.r),
                                border: Border.all(
                                  color: AppColors.sceTeal.withValues(
                                    alpha: 0.3,
                                  ),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "MAXIMUM AMOUNT",
                                    style: FontManager.labelSmall(
                                      color: AppColors.sceTeal,
                                    ),
                                  ),
                                  SizedBox(height: 12.h),
                                  TextField(
                                    controller: provider.autoBidController,
                                    keyboardType: TextInputType.number,
                                    style: FontManager.bodyMedium(
                                      color: Colors.white,
                                    ),
                                    onChanged: (val) {
                                      final amt = int.tryParse(
                                        val.replaceAll(',', ''),
                                      );
                                      if (amt != null) {
                                        provider.setMaxAutoBid(amt);
                                      }
                                    },
                                    decoration: InputDecoration(
                                      hintText:
                                          "e.g. ${NumberFormat('#,###').format(provider.currentBid + 5000)}",
                                      hintStyle: FontManager.bodyMedium(
                                        color: AppColors.textHint,
                                      ),
                                      filled: true,
                                      fillColor: AppColors.sceCardBg,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                          8.r,
                                        ),
                                        borderSide: BorderSide.none,
                                      ),
                                      prefixText: "CHF ",
                                      prefixStyle: FontManager.bodyMedium(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 12.h),
                                  CustomButton(
                                    text: "SET AUTO BID",
                                    isPrimary: false,
                                    isLoading: provider.isSettingAutoBid,
                                    onPressed: () =>
                                        provider.setAutoBid(context),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildAuctionStatus(AuctionBiddingProvider provider) {
    if (provider.isLoadingInitial || provider.endDate == null) {
      return Container(
        height: 40.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(8.r),
        ),
      );
    }

    final now = DateTime.now();
    final isLive = provider.endDate!.isAfter(now);
    final duration = provider.endDate!.difference(now);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: isLive
                ? AppColors.errorRed.withValues(alpha: 0.1)
                : Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: isLive
                  ? AppColors.errorRed.withValues(alpha: 0.3)
                  : Colors.transparent,
            ),
          ),
          child: Row(
            children: [
              if (isLive) ...[
                Container(
                  width: 8.w,
                  height: 8.w,
                  decoration: const BoxDecoration(
                    color: AppColors.errorRed,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 6.w),
              ],
              Text(
                isLive ? "LIVE" : "ENDED",
                style: FontManager.labelMedium(
                  color: isLive ? AppColors.errorRed : AppColors.textHint,
                ).copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        if (isLive)
          Row(
            children: [
              Icon(
                Icons.timer_outlined,
                color: AppColors.textHint,
                size: 16.sp,
              ),
              SizedBox(width: 4.w),
              Text(
                "${duration.inDays}d ${duration.inHours % 24}h ${duration.inMinutes % 60}m ${duration.inSeconds % 60}s",
                style: FontManager.bodyMedium(color: Colors.white),
              ),
            ],
          ),
      ],
    );
  }
}
