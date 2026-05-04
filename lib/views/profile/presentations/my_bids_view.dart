import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rionydo/app_utils/constants/font_manager.dart';
import 'package:rionydo/app_utils/utils/app_colors.dart';
import 'package:rionydo/core/widgets/common_background.dart';
import 'package:rionydo/core/widgets/custom_back_button.dart';
import 'package:rionydo/models/auctions/my_auctions_response.dart';
import 'package:rionydo/models/auctions/auction_image.dart';
import 'package:rionydo/views/auctions/presentations/auction_bidding.dart';
import 'package:rionydo/views/profile/widgets/my_bid_card.dart';

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
              child: TabBar(
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
                tabs: const [
                  Tab(text: "Active (2)"),
                  Tab(text: "Completed (2)"),
                ],
                dividerColor: Colors.transparent,
                indicatorSize: TabBarIndicatorSize.tab,
              ),
            ),
          ),

          SizedBox(height: 24.h),

          // ── TAB VIEWS ──
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [_buildActiveBids(), _buildCompletedBids()],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveBids() {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      children: [
        MyBidCard(
          imageUrl:
              "https://images.unsplash.com/photo-1503376780353-7e6692767b70?q=80&w=2070&auto=format&fit=crop",
          title: "Porsche 911 GT3 2022",
          status: "WINNING",
          myBid: 185000,
          currentBid: 185000,
          timeLeft: "2h 15m",
        ),
        MyBidCard(
          imageUrl:
              "https://images.unsplash.com/photo-1555215695-3004980ad54e?q=80&w=2070&auto=format&fit=crop",
          title: "BMW M4 Competition",
          status: "OUTBID",
          myBid: 78000,
          currentBid: 82000,
          timeLeft: "5h 42m",
          onBidHigher: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AuctionBidding(
                  initialData: AuctionItem(
                    id: 0,
                    title: "BMW M4 Competition",
                    vehicleBrand: "BMW",
                    sellerName: "Premium Dealer",
                    currentHighestBid: "82000",
                    reservePrice: "75000",
                    status: "active",
                    createdAt: DateTime.now(),
                    endsAt: DateTime.now().add(const Duration(hours: 5, minutes: 42)),
                    totalBidders: 8,
                    images: [
                      const AuctionImage(
                        url: "https://images.unsplash.com/photo-1555215695-3004980ad54e?q=80&w=2070&auto=format&fit=crop",
                        position: 0,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildCompletedBids() {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      children: [
        MyBidCard(
          imageUrl:
              "https://images.unsplash.com/photo-1503376780353-7e6692767b70",
          title: "Audi RS6 Avant 2023",
          status: "WON",
          myBid: 112000,
          currentBid: 112000,
          timeLeft: "Ended",
        ),
        MyBidCard(
          imageUrl:
              "https://images.unsplash.com/photo-1618843479313-40f8afb4b4d8?q=80&w=2070&auto=format&fit=crop",
          title: "Mercedes-AMG GT",
          status: "LOST",
          myBid: 90000,
          currentBid: 95000,
          timeLeft: "Ended",
        ),
      ],
    );
  }
}
