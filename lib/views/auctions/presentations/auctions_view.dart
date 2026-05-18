import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:rionydo/app_utils/constants/font_manager.dart';
import 'package:rionydo/app_utils/utils/app_spacing.dart';
import 'package:rionydo/core/widgets/common_background.dart';
import 'package:rionydo/core/widgets/custom_text_field.dart';
import 'package:rionydo/app_utils/utils/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:rionydo/controllers/auctions/my_auctions_provider.dart';
import 'package:rionydo/views/auctions/widgets/auction_card.dart';
import 'package:shimmer/shimmer.dart';

class AuctionsView extends StatefulWidget {
  const AuctionsView({super.key});

  @override
  State<AuctionsView> createState() => _AuctionsViewState();
}

class _AuctionsViewState extends State<AuctionsView> {
  int _selectedFilterIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  final List<String> _filters = [
    "All",
    "Active",
    "Sold",
    "Unsold",
    // "Withdrawn",
    // "Payment Expired",
    // "Shipping Expired",
    "Scheduled",
    // "Removed",
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MyAuctionsProvider>().fetchAuctions();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _mapFilterToStatus(String filter) {
    switch (filter) {
      case "Active":
        return "active";
      case "Sold":
        return "sold";
      case "Unsold":
        return "unsold";
      // case "Withdrawn":
      //   return "withdrawn";
      // case "Payment Expired":
      //   return "payment_expired";
      // case "Shipping Expired":
      //   return "shipping_expired";
      case "Scheduled":
        return "scheduled";
      // case "Removed":
      //   return "removed";
      default:
        return "all";
    }
  }

  @override
  Widget build(BuildContext context) {
    return CommonBackground(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmarks_rounded),
            onPressed: () {
              context.push('/wishlist');
            },
          ),
        ],
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        title: Text(
          "Auction",
          style: FontManager.heading1(color: Colors.white),
        ),

        centerTitle: false,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.h),
            // Custom search bar
            CustomTextField(
              controller: _searchController,
              hintText: "Search make, model...",
              prefixIcon: const Icon(Icons.search, color: AppColors.textHint),
              onChanged: (value) {
                context.read<MyAuctionsProvider>().setSearchQuery(value);
              },
            ),
            SizedBox(height: 20.h),
            // Filter chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(_filters.length, (index) {
                  final isSelected = _selectedFilterIndex == index;
                  return Padding(
                    padding: EdgeInsets.only(right: 12.w),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedFilterIndex = index;
                        });
                        _searchController.clear();
                        context.read<MyAuctionsProvider>()
                          ..setSearchQuery('')
                          ..fetchAuctions(
                            statusFilter: _mapFilterToStatus(_filters[index]),
                          );
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 8.h,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.sceTeal
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.sceTeal
                                : Colors.white.withValues(alpha: 0.1),
                          ),
                        ),
                        child: Row(
                          children: [
                            if (_filters[index] == "Watched") ...[
                              Icon(
                                Icons.star_border,
                                color: AppColors.textHint,
                                size: 16.sp,
                              ),
                              SizedBox(width: 4.w),
                            ],
                            Text(
                              _filters[index],
                              style: FontManager.bodyMedium(
                                color: isSelected
                                    ? Colors.white
                                    : AppColors.textHint,
                              ).copyWith(fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            Consumer<MyAuctionsProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return _buildShimmerLoading();
                }

                if (provider.errorMessage != null) {
                  return Expanded(
                    child: Center(
                      child: Text(
                        provider.errorMessage!,
                        style: FontManager.bodyMedium(
                          color: AppColors.errorRed,
                        ),
                      ),
                    ),
                  );
                }

                final auctions = provider.filteredAuctions;

                return Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppSpacing.h10,
                      Text(
                        "${auctions.length} Auctions found",
                        style: FontManager.bodyMedium(
                          color: AppColors.textHint,
                        ),
                      ),
                      AppSpacing.h10,
                      Expanded(
                        child: RefreshIndicator(
                          color: AppColors.sceTeal,
                          backgroundColor: AppColors.sceCardBg,
                          onRefresh: () async {
                            _searchController.clear();
                            context.read<MyAuctionsProvider>().setSearchQuery(
                              '',
                            );
                            await context
                                .read<MyAuctionsProvider>()
                                .fetchAuctions(
                                  statusFilter: _mapFilterToStatus(
                                    _filters[_selectedFilterIndex],
                                  ),
                                );
                          },
                          child: auctions.isEmpty
                              ? ListView(
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  children: [
                                    SizedBox(
                                      height: 300.h,
                                      child: Center(
                                        child: Text(
                                          "No auctions found",
                                          style: FontManager.bodyMedium(
                                            color: AppColors.textHint,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : GridView.builder(
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  padding: EdgeInsets.only(bottom: 20.h),
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 16.w,
                                        mainAxisSpacing: 16.h,
                                        childAspectRatio: 0.54,
                                      ),
                                  itemCount: auctions.length,
                                  itemBuilder: (context, index) {
                                    final auction = auctions[index];
                                    return AuctionCard(
                                      title: auction.title,
                                      vehicleBrand: auction.vehicleBrand,
                                      currentHighestBid:
                                          auction.currentHighestBid,
                                      reservePrice: auction.reservePrice,
                                      status: auction.status,
                                      endsAt: auction.endsAt,
                                      startsAt: auction.startsAt,
                                      imageUrl: auction.images.isNotEmpty
                                          ? auction.images.first.url
                                          : null,
                                      onTap: () {
                                        context.push(
                                          '/auction-details',
                                          extra: auction,
                                        );
                                      },
                                    );
                                  },
                                ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // ── Helpers ─────────────────────────────────────────────────────────────────

  Widget _buildShimmerLoading() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSpacing.h10,
          _buildShimmerBox(width: 120.w, height: 16.h),
          AppSpacing.h10,
          Expanded(
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.only(bottom: 20.h),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16.w,
                mainAxisSpacing: 16.h,
                childAspectRatio: 0.54,
              ),
              itemCount: 6,
              itemBuilder: (context, index) {
                return _buildShimmerCard();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.sceCardBg,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: _buildShimmerBox(borderRadius: BorderRadius.zero),
          ),
          Expanded(
            flex: 4,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildShimmerBox(width: 110.w, height: 14.h),
                      SizedBox(height: 6.h),
                      _buildShimmerBox(width: 70.w, height: 10.h),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Divider(
                        color: Colors.white.withValues(alpha: 0.07),
                        height: 1,
                        thickness: 1,
                      ),
                      SizedBox(height: 8.h),
                      _buildShimmerBox(width: 50.w, height: 10.h),
                      SizedBox(height: 4.h),
                      _buildShimmerBox(width: 80.w, height: 14.h),
                      SizedBox(height: 6.h),
                      _buildShimmerBox(
                        width: 100.w,
                        height: 16.h,
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerBox({
    double? width,
    double? height,
    BorderRadiusGeometry? borderRadius,
  }) {
    return Shimmer.fromColors(
      baseColor: Colors.white.withValues(alpha: 0.05),
      highlightColor: Colors.white.withValues(alpha: 0.1),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: borderRadius ?? BorderRadius.circular(12.r),
        ),
      ),
    );
  }
}
