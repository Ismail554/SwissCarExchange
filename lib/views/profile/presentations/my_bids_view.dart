import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:rionydo/app_utils/constants/font_manager.dart';
import 'package:rionydo/app_utils/utils/app_colors.dart';
import 'package:rionydo/core/widgets/common_background.dart';
import 'package:rionydo/core/widgets/custom_back_button.dart';
import 'package:rionydo/models/auctions/my_auctions_response.dart';
import 'package:rionydo/views/auctions/presentations/auction_bidding.dart';
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
                  return const Center(child: CircularProgressIndicator(color: AppColors.sceTeal));
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
                    _buildActiveBids(provider.activeBids),
                    _buildCompletedBids(provider.completedBids),
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

  Widget _buildActiveBids(List<AuctionItem> bids) {
    if (bids.isEmpty) {
      return Center(
        child: Text("No active bids.", style: FontManager.bodyMedium(color: AppColors.sceGreyA0)),
      );
    }
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      itemCount: bids.length,
      itemBuilder: (context, index) {
        final auction = bids[index];
        final currentBid = double.tryParse(auction.currentHighestBid ?? '0') ?? 0.0;
        return MyBidCard(
          imageUrl: auction.images.isNotEmpty ? auction.images.first.url : "",
          title: auction.title,
          status: auction.status.toUpperCase(),
          myBid: currentBid, // fallback since myBid is not available
          currentBid: currentBid,
          timeLeft: _calculateTimeLeft(auction.endsAt),
          onBidHigher: () {
            context.push('/auction-bidding', extra: auction);
          },
        );
      },
    );
  }

  Widget _buildCompletedBids(List<AuctionItem> bids) {
    if (bids.isEmpty) {
      return Center(
        child: Text("No completed bids.", style: FontManager.bodyMedium(color: AppColors.sceGreyA0)),
      );
    }
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      itemCount: bids.length,
      itemBuilder: (context, index) {
        final auction = bids[index];
        final currentBid = double.tryParse(auction.currentHighestBid ?? '0') ?? 0.0;
        return MyBidCard(
          imageUrl: auction.images.isNotEmpty ? auction.images.first.url : "",
          title: auction.title,
          status: auction.status.toUpperCase(),
          myBid: currentBid,
          currentBid: currentBid,
          timeLeft: "Ended",
        );
      },
    );
  }
}
