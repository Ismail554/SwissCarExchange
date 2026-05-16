import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:rionydo/app_utils/constants/font_manager.dart';
import 'package:rionydo/app_utils/utils/app_colors.dart';
import 'package:rionydo/controllers/auctions/auction_management_provider.dart';
import 'package:rionydo/core/widgets/common_background.dart';
import 'package:rionydo/core/widgets/custom_back_button.dart';
import 'package:rionydo/views/premium/widgets/auction_management_card.dart';
import 'package:rionydo/models/auctions/my_auctions_response.dart';
import 'package:rionydo/models/auctions/auction_image.dart';
import 'package:rionydo/models/premium/auction_management_response.dart' as premium;

class AuctionManagement extends StatefulWidget {
  const AuctionManagement({super.key});

  @override
  State<AuctionManagement> createState() => _AuctionManagementState();
}

class _AuctionManagementState extends State<AuctionManagement> {
  static const Map<String, String> _statusTabs = {
    'all': 'All',
    'active': 'Active',
    'sold': 'Sold',
    'unsold': 'Unsold',
    'withdrawn': 'Withdrawn',
    'payment_expired': 'Payment Expired',
    'shipping_expired': 'Shipping Expired',
    'scheduled': 'Scheduled',
    'removed': 'Removed',
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<AuctionManagementProvider>().fetchAuctions();
      }
    });
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
                context.push('/create-auction').then((_) {
                  if (context.mounted) {
                    context.read<AuctionManagementProvider>().fetchAuctions();
                  }
                });
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
          Consumer<AuctionManagementProvider>(
            builder: (context, provider, _) {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: _statusTabs.entries.map((entry) {
                    final isSelected = provider.selectedStatus == entry.key;
                    // We can append the count if it matches the current status
                    final countText = isSelected && provider.response != null
                        ? " (${provider.response!.count})"
                        : "";
                    return Padding(
                      padding: EdgeInsets.only(right: 12.w),
                      child: _buildFilterChip(
                        "${entry.value}$countText",
                        entry.key,
                        provider,
                      ),
                    );
                  }).toList(),
                ),
              );
            },
          ),

          SizedBox(height: 24.h),

          // ── LISTING ──
          Expanded(
            child: Consumer<AuctionManagementProvider>(
              builder: (context, provider, _) {
                if (provider.isLoading && provider.auctions.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.sceTeal),
                  );
                }

                if (provider.errorMessage != null &&
                    provider.auctions.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: AppColors.errorRed,
                            size: 48.sp,
                          ),
                          SizedBox(height: 12.h),
                          Text(
                            provider.errorMessage!,
                            style: FontManager.bodyMedium(
                              color: AppColors.sceGrey99,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 12.h),
                          TextButton(
                            onPressed: () => provider.fetchAuctions(),
                            child: Text(
                              "Retry",
                              style: FontManager.bodyMedium(
                                color: AppColors.sceTeal,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                if (provider.auctions.isEmpty) {
                  return RefreshIndicator(
                    color: AppColors.sceTeal,
                    onRefresh: () => provider.fetchAuctions(),
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.15,
                        ),
                        _buildEmptyState(
                          _statusTabs[provider.selectedStatus] ?? "",
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  color: AppColors.sceTeal,
                  onRefresh: () => provider.fetchAuctions(),
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: provider.auctions.length,
                    itemBuilder: (context, index) {
                      final auction = provider.auctions[index];
                      return _buildAuctionCard(auction);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(
    String label,
    String statusKey,
    AuctionManagementProvider provider,
  ) {
    bool isSelected = provider.selectedStatus == statusKey;
    return GestureDetector(
      onTap: () => provider.setStatus(statusKey),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.sceTeal : Colors.transparent,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: isSelected
                ? Colors.transparent
                : Colors.white.withValues(alpha: 0.1),
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

  Widget _buildAuctionCard(premium.Auction auction) {
    final imageUrl = auction.images.isNotEmpty ? auction.images.first.url : '';
    final currentBid = double.tryParse(auction.currentHighestBid) ?? 0;
    final reserve = double.tryParse(auction.reservePrice) ?? 0;
    final isReserveMet = currentBid >= reserve;

    return AuctionManagementCard(
      imageUrl: imageUrl,
      title: auction.title,
      status: auction.status.toUpperCase(),
      subStatus: _getSubStatus(auction),
      views: auction.viewCount,
      bids: auction.totalBids,
      bidders: auction.totalBidders,
      currentBid: currentBid,
      reservePrice: reserve,
      isReserveMet: isReserveMet,
      timeLeft: _formatTimeLeft(auction.endsAt),
      onViewDetails: () {
        context.push(
          '/auction-details',
            extra: AuctionItem(
              id: auction.id,
              title: auction.title,
              vehicleBrand: auction.vehicleBrand,
              sellerName: auction.sellerName,
              currentHighestBid: auction.currentHighestBid,
              reservePrice: auction.reservePrice,
              status: auction.status,
              createdAt: DateTime.now(),
              endsAt: auction.endsAt,
              images:
                  auction.images
                      .map((img) => AuctionImage(
                        url: img.url,
                        position: img.position,
                      ))
                      .toList(),
              totalBidders: auction.totalBidders,
            ),
        );
      },
      onMenuTap: () {},
    );
  }

  String _getSubStatus(premium.Auction auction) {
    final statusLower = auction.status.toLowerCase();
    if (statusLower == 'active') {
      final now = DateTime.now();
      if (auction.endsAt != null && auction.endsAt!.isBefore(now)) {
        return "ENDED";
      }
      return "LIVE";
    }
    return auction.status.toUpperCase();
  }

  String _formatTimeLeft(DateTime? endsAt) {
    if (endsAt == null) return "No end date";
    final now = DateTime.now();
    if (endsAt.isBefore(now)) {
      final diff = now.difference(endsAt);
      if (diff.inDays > 0) {
        return "Ended ${diff.inDays}d ago";
      } else if (diff.inHours > 0) {
        return "Ended ${diff.inHours}h ago";
      } else {
        return "Ended recently";
      }
    } else {
      final diff = endsAt.difference(now);
      if (diff.inDays > 0) {
        return "${diff.inDays}d ${diff.inHours % 24}h left";
      } else if (diff.inHours > 0) {
        return "${diff.inHours}h ${diff.inMinutes % 60}m left";
      } else {
        return "${diff.inMinutes}m left";
      }
    }
  }

  Widget _buildEmptyState(String status) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 40.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.gavel_rounded, color: AppColors.sceGrey99, size: 64.sp),
            SizedBox(height: 16.h),
            Text(
              "No $status Listings",
              style: FontManager.bodyMedium(
                color: AppColors.sceGrey99,
              ).copyWith(fontWeight: FontWeight.bold, fontSize: 16.sp),
            ),
            SizedBox(height: 8.h),
            Text(
              "You don't have any auctions listed under $status status currently.",
              style: FontManager.bodySmall(color: AppColors.sceGreyA0),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
