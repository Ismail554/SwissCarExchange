import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:rionydo/app_utils/constants/font_manager.dart';
import 'package:rionydo/app_utils/utils/app_colors.dart';
import 'package:rionydo/core/widgets/common_background.dart';
import 'package:rionydo/core/widgets/custom_back_button.dart';
import 'package:rionydo/models/auctions/my_auctions_response.dart';
import 'package:rionydo/views/profile/widgets/my_bid_card.dart';
import 'package:provider/provider.dart';
import 'package:rionydo/controllers/auctions/my_bids_provider.dart';

class MyBidsView extends StatefulWidget {
  const MyBidsView({super.key});

  @override
  State<MyBidsView> createState() => _MyBidsViewState();
}

class _MyBidsViewState extends State<MyBidsView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MyBidsProvider>().fetchMyBids();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CommonBackground(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const CustomBackButton(),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "My Bids",
                  style: FontManager.titleText(
                    color: Colors.white,
                  ).copyWith(fontSize: 18.sp),
                ),
                SizedBox(width: 4.w),
                Icon(
                  Icons.workspace_premium_rounded,
                  color: AppColors.sceGold,
                  size: 18.sp,
                ),
              ],
            ),
            Text("Manage your bids", style: FontManager.hintText()),
          ],
        ),
      ),
      child: Column(
        children: [
          SizedBox(height: 16.h),
          // ── TAB BAR ──
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Container(
              height: 48.h,
              decoration: BoxDecoration(
                color: AppColors.sceCardBg,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Consumer<MyBidsProvider>(
                builder: (context, provider, _) {
                  return TabBar(
                    controller: _tabController,
                    indicator: BoxDecoration(
                      color: AppColors.sceTeal,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    labelColor: Colors.white,
                    unselectedLabelColor: AppColors.sceGreyA0,
                    labelStyle: FontManager.labelMedium(
                      color: Colors.white,
                    ).copyWith(fontWeight: FontWeight.bold),
                    tabs: [
                      Tab(text: "Active (${provider.activeBids.length})"),
                      Tab(text: "Completed (${provider.completedBids.length})"),
                    ],
                    dividerColor: Colors.transparent,
                    indicatorSize: TabBarIndicatorSize.tab,
                  );
                },
              ),
            ),
          ),

          SizedBox(height: 24.h),

          // ── TAB VIEWS ──
          Expanded(
            child: Consumer<MyBidsProvider>(
              builder: (context, provider, _) {
                if (provider.isLoading) {
                  return _buildShimmerSkeleton();
                }
                if (provider.errorMessage != null) {
                  return Center(
                    child: Text(
                      provider.errorMessage!,
                      style: FontManager.bodyMedium(color: AppColors.error),
                    ),
                  );
                }
                return TabBarView(
                  controller: _tabController,
                  children: [
                    _buildActiveBids(provider.activeBids, provider),
                    _buildCompletedBids(provider.completedBids, provider),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _calculateTimeLeft(DateTime? endsAt) {
    if (endsAt == null) return "Unknown";
    final now = DateTime.now();
    final diff = endsAt.difference(now);
    if (diff.isNegative) return "Ended";
    final hours = diff.inHours;
    final minutes = diff.inMinutes.remainder(60);
    return "${hours}h ${minutes}m";
  }

  Widget _buildShimmerSkeleton() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      itemCount: 3,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.only(bottom: 20.h),
          decoration: BoxDecoration(
            color: AppColors.sceCardBg,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),
          child: Shimmer.fromColors(
            baseColor: Colors.white.withValues(alpha: 0.05),
            highlightColor: Colors.white.withValues(alpha: 0.1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image Placeholder
                Container(
                  height: 180.h,
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(16.r),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title Placeholder
                      Container(
                        height: 18.h,
                        width: 200.w,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      // Bids Row Placeholder
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 12.h,
                                width: 50.w,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(3.r),
                                ),
                              ),
                              SizedBox(height: 6.h),
                              Container(
                                height: 18.h,
                                width: 80.w,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(4.r),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 12.h,
                                width: 70.w,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(3.r),
                                ),
                              ),
                              SizedBox(height: 6.h),
                              Container(
                                height: 18.h,
                                width: 80.w,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(4.r),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      // Time Left / Action Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                height: 14.h,
                                width: 14.w,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              SizedBox(width: 6.w),
                              Container(
                                height: 12.h,
                                width: 60.w,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(3.r),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            height: 32.h,
                            width: 90.w,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildActiveBids(List<AuctionItem> bids, MyBidsProvider provider) {
    return RefreshIndicator(
      color: AppColors.sceTeal,
      backgroundColor: AppColors.sceCardBg,
      onRefresh: () => provider.fetchMyBids(forceRefresh: true),
      child: bids.isEmpty
          ? ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(height: 150.h),
                Center(
                  child: Text(
                    "No active bids.",
                    style: FontManager.bodyMedium(color: AppColors.sceGreyA0),
                  ),
                ),
              ],
            )
          : ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
              itemCount: bids.length,
              itemBuilder: (context, index) {
                final auction = bids[index];
                final currentBid =
                    double.tryParse(auction.currentHighestBid ?? '0') ?? 0.0;
                return MyBidCard(
                  imageUrl: auction.images.isNotEmpty
                      ? auction.images.first.url
                      : "",
                  title: auction.title,
                  status: auction.status.toUpperCase(),
                  currentBid: currentBid,
                  timeLeft: _calculateTimeLeft(auction.endsAt),
                  totalBids: auction.totalBids,
                  onBidHigher: () {
                    context.push('/auction-bidding', extra: auction);
                  },
                  totalBidders: auction.totalBidders,
                );
              },
            ),
    );
  }

  Widget _buildCompletedBids(List<AuctionItem> bids, MyBidsProvider provider) {
    return RefreshIndicator(
      color: AppColors.sceTeal,
      backgroundColor: AppColors.sceCardBg,
      onRefresh: () => provider.fetchMyBids(forceRefresh: true),
      child: bids.isEmpty
          ? ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(height: 150.h),
                Center(
                  child: Text(
                    "No completed bids.",
                    style: FontManager.bodyMedium(color: AppColors.sceGreyA0),
                  ),
                ),
              ],
            )
          : ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
              itemCount: bids.length,
              itemBuilder: (context, index) {
                final auction = bids[index];
                final currentBid =
                    double.tryParse(auction.currentHighestBid ?? '0') ?? 0.0;
                return MyBidCard(
                  imageUrl: auction.images.isNotEmpty
                      ? auction.images.first.url
                      : "",
                  title: auction.title,
                  status: auction.status.toUpperCase(),
                  currentBid: currentBid,
                  timeLeft: "Ended",
                  totalBids: auction.totalBids,
                  totalBidders: auction.totalBidders,
                );
              },
            ),
    );
  }
}
