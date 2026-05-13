import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:rionydo/app_utils/utils/app_colors.dart';
import 'package:rionydo/app_utils/utils/app_spacing.dart';
import 'package:rionydo/app_utils/utils/assets_manager.dart';
import 'package:rionydo/app_utils/constants/global_state.dart';
import 'package:rionydo/core/widgets/common_background.dart';
import 'package:rionydo/app_utils/constants/font_manager.dart';
import 'package:rionydo/core/widgets/custom_button.dart';
import 'package:rionydo/controllers/auctions/my_auctions_provider.dart';
import 'package:rionydo/controllers/home_stats_provider.dart';
import 'package:rionydo/models/auctions/my_auctions_response.dart';
import 'package:rionydo/models/profile/user_profile_response.dart';
import 'package:rionydo/views/auctions/presentations/auction_details.dart';
import 'package:rionydo/views/auctions/widgets/auction_countdown.dart';
import 'package:rionydo/views/home/widgets/notification_badge.dart';
import 'package:rionydo/views/home/widgets/premium_dealer_card.dart';
import 'package:rionydo/views/home/widgets/section_header.dart';
import 'package:rionydo/views/home/widgets/stat_card.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auctionsProvider = context.read<MyAuctionsProvider>();
      if (auctionsProvider.auctions.isEmpty) {
        auctionsProvider.fetchAuctions();
      }
      // Fetch home stats based on user role if not already loaded
      final isDealer = context.read<GlobalState>().userType == UserType.company;
      final statsProvider = context.read<HomeStatsProvider>();
      if (isDealer) {
        if (statsProvider.dealerStats == null) {
          statsProvider.fetchDealerStats();
        }
      } else {
        if (statsProvider.bidderStats == null) {
          statsProvider.fetchBidderStats();
        }
      }
    });
  }

  Future<void> _refreshData() async {
    final isDealer = context.read<GlobalState>().userType == UserType.company;
    final statsProvider = context.read<HomeStatsProvider>();
    final myAuctionsProvider = context.read<MyAuctionsProvider>();
    if (isDealer) {
      await statsProvider.fetchDealerStats();
    } else {
      await statsProvider.fetchBidderStats();
    }
    await myAuctionsProvider.fetchAuctions();
  }

  @override
  Widget build(BuildContext context) {
    return CommonBackground(
      child: RefreshIndicator(
        onRefresh: _refreshData,
        color: AppColors.sceTeal,
        backgroundColor: AppColors.sceDarkBg,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          slivers: [
            // ── Top Header (Logo) - Scrolls Away ──────────────────────────
            SliverToBoxAdapter(
              child: Center(
                child: Image.asset(IconAssets.appLogo, height: 70.h),
              ),
            ),

            // ── Welcome Row - Pinned AppBar ─────────────────────────────
            SliverAppBar(
              pinned: true,
              toolbarHeight: 70.h,
              backgroundColor: Colors.transparent,
              elevation: 0,
              automaticallyImplyLeading: false,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  color: AppColors.sceDarkBg.withValues(alpha: 0.95),
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 2.h,
                  ),
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Welcome back',
                            style: FontManager.bodySmall(
                              color: Colors.white60,
                              fontSize: 14.sp,
                            ),
                          ),
                          Text(
                            context.watch<GlobalState>().userName,
                            style: FontManager.heading3(
                              color: Colors.white,
                              fontSize: 20.sp,
                            ).copyWith(fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          // Text(
                          //   isPremium ? "Premium" : "Basic",
                          //   style: TextStyle(color: AppColors.sceGold, fontSize: 12.sp, fontWeight: FontWeight.bold),
                          // ),
                          // Switch(
                          //   value: isPremium,
                          //   activeColor: AppColors.sceGold,
                          //   onChanged: (val) {
                          //     context.read<GlobalState>().isPremium = val;
                          //   },
                          // ),
                          SizedBox(width: 8.w),
                          const NotificationBadge(),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ── Content Sections ──────────────────────────────────────────
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  AppSpacing.h24,
                  // ── Stats Row ───────────────────────────────────────────
                  Consumer2<HomeStatsProvider, GlobalState>(
                    builder: (context, statsProvider, globalState, _) {
                      final isDealer = globalState.userType == UserType.company;

                      // ── Card 1: Revenue (dealer) / Won Auctions (bidder) ──
                      String card1Label;
                      String card1Value;
                      String? card1Sub;

                      if (statsProvider.isLoading) {
                        card1Label = isDealer
                            ? 'TOTAL REVENUE'
                            : 'WON AUCTIONS';
                        card1Value = '00';
                      } else if (isDealer &&
                          statsProvider.dealerStats != null) {
                        card1Label = 'TOTAL REVENUE';
                        card1Value =
                            'CHF ${statsProvider.dealerStats!.totalRevenue}';
                      } else if (!isDealer &&
                          statsProvider.bidderStats != null) {
                        card1Label = 'WON AUCTIONS';
                        card1Value =
                            '${statsProvider.bidderStats!.auctionsWon}';
                        card1Sub =
                            'Win rate: ${statsProvider.bidderStats!.winRate.toStringAsFixed(0)}%';
                      } else {
                        card1Label = isDealer
                            ? 'TOTAL REVENUE'
                            : 'WON AUCTIONS';
                        card1Value = '0';
                      }

                      // ── Card 2: Active Auctions (dealer) / Participated (bidder) ──
                      String card2Label;
                      String card2Value;
                      String? card2Desc;

                      if (statsProvider.isLoading) {
                        card2Label = isDealer
                            ? 'ACTIVE AUCTIONS'
                            : 'PARTICIPATED';
                        card2Value = '0';
                      } else if (isDealer &&
                          statsProvider.dealerStats != null) {
                        card2Label = 'ACTIVE AUCTIONS';
                        card2Value =
                            '${statsProvider.dealerStats!.activeAuctions}';
                        card2Desc =
                            'Sold: ${statsProvider.dealerStats!.soldCount}';
                      } else if (!isDealer &&
                          statsProvider.bidderStats != null) {
                        card2Label = 'PARTICIPATED';
                        card2Value =
                            '${statsProvider.bidderStats!.auctionsParticipated}';
                        card2Desc =
                            'Avg bid: CHF ${statsProvider.bidderStats!.avgBid}';
                      } else {
                        card2Label = isDealer
                            ? 'ACTIVE AUCTIONS'
                            : 'PARTICIPATED';
                        card2Value = '—';
                      }

                      return Row(
                        children: [
                          Expanded(
                            child: StatCard(
                              label: card1Label,
                              value: card1Value,
                              subValue: card1Sub,
                              accentColor: AppColors.sceTeal,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: StatCard(
                              label: card2Label,
                              value: card2Value,
                              labelDesc: card2Desc,
                              accentColor: AppColors.sceGold,
                              isWatchlist: isDealer,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  AppSpacing.h20,

                  // ── Premium Card ────────────────────────────────────────
                  const PremiumDealerCard(),
                  AppSpacing.h20,

                  // // ── Search Button ───────────────────────────────────────
                  // CustomButton(
                  //   text: 'SEARCH VEHICLE',
                  //   onPressed: () {},
                  //   isPrimary: true,
                  // ),
                  AppSpacing.h32,

                  // ── Auction Sections (dynamic from provider) ─────────────
                  Consumer<MyAuctionsProvider>(
                    builder: (context, provider, child) {
                      if (provider.isLoading && provider.auctions.isEmpty) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SectionHeader(title: 'LIVE AUCTIONS'),
                            AppSpacing.h16,
                            _buildShimmerCard(),
                            _buildShimmerCard(),
                            AppSpacing.h32,
                            const SectionHeader(title: 'UPCOMING AUCTIONS'),
                            AppSpacing.h16,
                            _buildShimmerCard(),
                          ],
                        );
                      }

                      if (provider.errorMessage != null &&
                          provider.auctions.isEmpty) {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 40.h),
                          child: Center(
                            child: Column(
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  color: AppColors.errorRed,
                                  size: 32.sp,
                                ),
                                SizedBox(height: 8.h),
                                Text(
                                  provider.errorMessage!,
                                  style: FontManager.bodyMedium(
                                    color: AppColors.errorRed,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 12.h),
                                GestureDetector(
                                  onTap: () => provider.fetchAuctions(),
                                  child: Text(
                                    "Tap to retry",
                                    style: FontManager.bodySmall(
                                      color: AppColors.sceTeal,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      final allAuctions = provider.auctions;
                      final liveAuctions = allAuctions
                          .where((a) => a.status == 'active')
                          .toList();
                      final upcomingAuctions = allAuctions
                          .where((a) => a.status != 'active')
                          .toList();

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ── Live Auctions Section ────────────────────────
                          const SectionHeader(title: 'LIVE AUCTIONS'),
                          AppSpacing.h16,
                          if (liveAuctions.isEmpty)
                            _buildEmptyState('No live auctions right now')
                          else
                            ...liveAuctions.map(
                              (auction) => Padding(
                                padding: EdgeInsets.only(bottom: 20.h),
                                child: _buildAuctionCard(auction, isLive: true),
                              ),
                            ),
                          AppSpacing.h32,

                          // ── Upcoming Auctions Section ────────────────────
                          const SectionHeader(title: 'UPCOMING AUCTIONS'),
                          AppSpacing.h16,
                          if (upcomingAuctions.isEmpty)
                            _buildEmptyState('No upcoming auctions')
                          else
                            ...upcomingAuctions.map(
                              (auction) => Padding(
                                padding: EdgeInsets.only(bottom: 20.h),
                                child: _buildAuctionCard(
                                  auction,
                                  isLive: false,
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                  AppSpacing.h40,
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Build a single auction card from AuctionItem data ─────────────────
  Widget _buildAuctionCard(AuctionItem auction, {required bool isLive}) {
    final displayBid = auction.currentHighestBid ?? auction.reservePrice;
    final imageUrl = auction.images.isNotEmpty ? auction.images.first.url : '';

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AuctionDetails(data: auction),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.sceCardBg,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: Colors.white12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Product Image ─────────────────────────────────────────
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20.r),
                  ),
                  child: imageUrl.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: imageUrl,
                          height: 180.h,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Shimmer.fromColors(
                            baseColor: Colors.white10,
                            highlightColor: Colors.white24,
                            child: Container(
                              height: 180.h,
                              width: double.infinity,
                              color: Colors.white,
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            height: 180.h,
                            width: double.infinity,
                            color: Colors.white.withValues(alpha: 0.07),
                            child: Icon(
                              Icons.directions_car_outlined,
                              color: AppColors.textHint.withValues(alpha: 0.4),
                              size: 40.sp,
                            ),
                          ),
                        )
                      : Container(
                          height: 180.h,
                          width: double.infinity,
                          color: Colors.white.withValues(alpha: 0.07),
                          child: Icon(
                            Icons.directions_car_outlined,
                            color: AppColors.textHint.withValues(alpha: 0.4),
                            size: 40.sp,
                          ),
                        ),
                ),
                // Lot number badge
                Positioned(
                  top: 12.h,
                  right: 12.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(color: Colors.white12),
                    ),
                    child: Text(
                      '${auction.totalBidders} Bidders',
                      style: FontManager.labelSmall(
                        color: Colors.white,
                        fontSize: 10.sp,
                      ),
                    ),
                  ),
                ),
                // Live badge
                if (isLive)
                  Positioned(
                    top: 12.h,
                    left: 12.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.85),
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 6.w,
                            height: 6.h,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            'LIVE',
                            style: FontManager.labelSmall(
                              color: Colors.white,
                              fontSize: 10.sp,
                            ).copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),

            // ── Card Body ─────────────────────────────────────────────
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title + Brand
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          auction.title,
                          style: FontManager.heading4(
                            color: Colors.white,
                            fontSize: 16.sp,
                          ).copyWith(fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Icon(
                        Icons.info_outline,
                        color: Colors.white60,
                        size: 18.sp,
                      ),
                    ],
                  ),
                  if (auction.vehicleBrand.isNotEmpty)
                    Text(
                      auction.vehicleBrand,
                      style: FontManager.bodySmall(
                        color: Colors.white38,
                        fontSize: 12.sp,
                      ),
                    ),

                  // ── Bid Section (matching auction_details pattern) ────
                  SizedBox(height: 12.h),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(12.w),
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
                          "CURRENT HIGHEST BID",
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
                              style: FontManager.heading2(color: Colors.white),
                            ),
                            Expanded(
                              child: Text(
                                displayBid,
                                style:
                                    FontManager.heading2(
                                      color: AppColors.sceTeal,
                                    ).copyWith(
                                      fontSize: 24.sp,
                                      fontWeight: FontWeight.w800,
                                    ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          "TIME REMAINING",
                          style: FontManager.labelSmall(
                            color: AppColors.textHint,
                          ).copyWith(letterSpacing: 1.2),
                        ),
                        SizedBox(height: 8.h),
                        AuctionCountdown(
                          endTime: auction.endsAt,
                          showDays: false,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 12.h),

                  // ── Bidders count ──────────────────────────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.people_alt_outlined,
                            color: Colors.white38,
                            size: 14.sp,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            '${auction.totalBidders} Bids',
                            style: FontManager.bodySmall(
                              color: Colors.white38,
                              fontSize: 11.sp,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        auction.sellerName,
                        style: FontManager.bodySmall(
                          color: Colors.white38,
                          fontSize: 11.sp,
                        ),
                      ),
                    ],
                  ),

                  AppSpacing.h16,

                  // ── Place Bid Button ────────────────────────────────────
                  CustomButton(
                    text: 'PLACE BID',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AuctionDetails(data: auction),
                        ),
                      );
                    },
                    isPrimary: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 32.h),
      decoration: BoxDecoration(
        color: AppColors.sceCardBg,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        children: [
          Icon(
            Icons.gavel_outlined,
            color: AppColors.textHint.withValues(alpha: 0.4),
            size: 32.sp,
          ),
          SizedBox(height: 8.h),
          Text(
            message,
            style: FontManager.bodyMedium(color: AppColors.textHint),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerCard() {
    return Padding(
      padding: EdgeInsets.only(bottom: 20.h),
      child: Shimmer.fromColors(
        baseColor: Colors.white10,
        highlightColor: Colors.white24,
        child: Container(
          height: 320.h,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
          ),
        ),
      ),
    );
  }
}
