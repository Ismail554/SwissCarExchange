import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rionydo/core/constants/font_manager.dart';
import 'package:rionydo/core/utils/app_colors.dart';
import 'package:rionydo/core/widgets/common_background.dart';
import 'package:rionydo/core/widgets/custom_back_button.dart';
import 'package:rionydo/views/premium/presentations/create_auction.dart';
import 'package:rionydo/views/auctions/presentations/auction_details.dart';
import '../widgets/auction_management_card.dart';

class AuctionManagement extends StatefulWidget {
  const AuctionManagement({super.key});

  @override
  State<AuctionManagement> createState() => _AuctionManagementState();
}

class _AuctionManagementState extends State<AuctionManagement> {
  int _selectedIndex = 0; // 0 for Active, 1 for Completed

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
                  "Auction Management",
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
            Text("Manage your listings", style: FontManager.hintText()),
          ],
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CreateAuction()),
                );
              },
              child: Container(
                padding: EdgeInsets.all(6.r),
                decoration: BoxDecoration(
                  color: AppColors.sceTeal,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(Icons.add, color: Colors.white, size: 24.sp),
              ),
            ),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16.h),

          // ── TABS / CHIPS ──
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              children: [
                _buildFilterChip("Active (2)", 0),
                SizedBox(width: 12.w),
                _buildFilterChip("Completed (1)", 1),
              ],
            ),
          ),

          SizedBox(height: 24.h),

          // ── LISTING ──
          Expanded(
            child: _selectedIndex == 0
                ? _buildActiveList()
                : _buildCompletedList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, int index) {
    bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.sceTeal : Colors.transparent,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: isSelected
                ? Colors.transparent
                : Colors.white.withOpacity(0.1),
          ),
        ),
        child: Text(
          label,
          style:
              FontManager.labelMedium(
                color: isSelected ? Colors.white : AppColors.sceGreyA0,
              ).copyWith(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
        ),
      ),
    );
  }

  Widget _buildActiveList() {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      physics: const BouncingScrollPhysics(),
      children: [
        AuctionManagementCard(
          imageUrl:
              "https://images.unsplash.com/photo-1503376780353-7e6692767b70",
          title: "Porsche 911 GT3 2022",
          status: "ACTIVE",
          subStatus: "LIVE",
          views: 342,
          bids: 23,
          bidders: 12,
          currentBid: 185000,
          reservePrice: 180000,
          isReserveMet: true,
          timeLeft: "2d 5h",
          onViewDetails: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => AuctionDetails(
                  data: {
                    'image': "https://images.unsplash.com/photo-1503376780353-7e6692767b70",
                    'title': "Porsche 911 GT3 2022",
                    'currentBid': "185,000",
                    'year': "2022",
                  },
                ),
              ),
            );
          },
          onMenuTap: () {},
        ),
        AuctionManagementCard(
          imageUrl:
              "https://images.unsplash.com/photo-1503376780353-7e6692767b70",
          title: "Mercedes-AMG GT 2021",
          status: "ACTIVE",
          subStatus: "SCHEDULED",
          views: 189,
          bids: 15,
          bidders: 8,
          currentBid: 95000,
          reservePrice: 90000,
          isReserveMet: true,
          timeLeft: "5d 12h",
          onViewDetails: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => AuctionDetails(
                  data: {
                    'image': "https://images.unsplash.com/photo-1503376780353-7e6692767b70",
                    'title': "Mercedes-AMG GT 2021",
                    'currentBid': "95,000",
                    'year': "2021",
                  },
                ),
              ),
            );
          },
          onMenuTap: () {},
        ),
      ],
    );
  }

  Widget _buildCompletedList() {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      physics: const BouncingScrollPhysics(),
      children: [
        AuctionManagementCard(
          imageUrl: "https://images.unsplash.com/photo-1542281286-9e0a16bb7366",
          title: "Audi R8 V10 Plus 2018",
          status: "COMPLETED",
          subStatus: "FINISHED",
          views: 654,
          bids: 42,
          bidders: 28,
          currentBid: 125000,
          reservePrice: 120000,
          isReserveMet: true,
          timeLeft: "Ended 2 days ago",
          onViewDetails: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => AuctionDetails(
                  data: {
                    'image': "https://images.unsplash.com/photo-1542281286-9e0a16bb7366",
                    'title': "Audi R8 V10 Plus 2018",
                    'currentBid': "125,000",
                    'year': "2018",
                  },
                ),
              ),
            );
          },
          onMenuTap: () {},
        ),
      ],
    );
  }
}
