import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rionydo/app_utils/constants/font_manager.dart';
import 'package:rionydo/app_utils/utils/app_spacing.dart';
import 'package:rionydo/core/widgets/common_background.dart';
import 'package:rionydo/core/widgets/custom_text_field.dart';
import 'package:rionydo/app_utils/utils/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:rionydo/controllers/auctions/my_auctions_provider.dart';
import 'package:rionydo/models/auctions/my_auctions_response.dart';
import 'package:rionydo/views/auctions/presentations/auction_details.dart';
import 'package:shimmer/shimmer.dart';

class AuctionsView extends StatefulWidget {
  const AuctionsView({super.key});

  @override
  State<AuctionsView> createState() => _AuctionsViewState();
}

class _AuctionsViewState extends State<AuctionsView> {
  int _selectedFilterIndex = 0;
  final List<String> _filters = [
    "All",
    "Active",
    "Sold",
    "Unsold",
    "Withdrawn",
    "Payment Expired",
    "Shipping Expired",
    "Scheduled",
    "Removed",
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MyAuctionsProvider>().fetchAuctions();
    });
  }

  String _mapFilterToStatus(String filter) {
    switch (filter) {
      case "Active":
        return "active";
      case "Sold":
        return "sold";
      case "Unsold":
        return "unsold";
      case "Withdrawn":
        return "withdrawn";
      case "Payment Expired":
        return "payment_expired";
      case "Shipping Expired":
        return "shipping_expired";
      case "Scheduled":
        return "scheduled";
      case "Removed":
        return "removed";
      default:
        return "all";
    }
  }

  @override
  Widget build(BuildContext context) {
    return CommonBackground(
      appBar: AppBar(
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
              hintText: "Search make, model...",
              prefixIcon: const Icon(Icons.search, color: AppColors.textHint),
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
                        context.read<MyAuctionsProvider>().fetchAuctions(
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
                                : Colors.white.withOpacity(0.1),
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

                final auctions = provider.auctions;

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
                                    return _buildAuctionCard(auctions[index]);
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

  Widget _buildAuctionCard(AuctionItem auction) {
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
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        clipBehavior: Clip
            .hardEdge, // Prevents image from bleeding outside rounded corners
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Image Section ──────────────────────────────────────────
            Expanded(
              flex: 4,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Image / placeholder
                  auction.images.isNotEmpty
                      ? Image.network(
                          auction.images.first.url,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              _buildImagePlaceholder(),
                          loadingBuilder: (_, child, progress) =>
                              progress == null
                              ? child
                              : _buildImagePlaceholder(loading: true),
                        )
                      : _buildImagePlaceholder(),

                  // Subtle gradient overlay for readability
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.25),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Status badge (top-left, more accessible than a bare dot)
                  if (auction.status == "active")
                    Positioned(
                      top: 8.h,
                      left: 8.w,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.85),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
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
                              "Live",
                              style: FontManager.bodySmall(color: Colors.white)
                                  .copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 10.sp,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // ── Details Section ────────────────────────────────────────
            Expanded(
              flex: 4,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // ── Title + Brand ──────────────────────────────────
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          auction.title,
                          style: FontManager.bodyMedium(
                            color: Colors.white,
                          ).copyWith(fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          auction.vehicleBrand,
                          style: FontManager.bodySmall(
                            color: AppColors.textHint,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),

                    // ── Bid + Time ─────────────────────────────────────
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Divider(
                          color: Colors.white.withOpacity(0.07),
                          height: 1,
                          thickness: 1,
                        ),
                        SizedBox(height: 8.h),

                        // Label row
                        Text(
                          "Current Bid",
                          style: FontManager.bodySmall(
                            color: AppColors.textHint,
                          ).copyWith(fontSize: 10.sp),
                        ),
                        SizedBox(height: 2.h),

                        // Price on its own full-width row — never truncated
                        Text(
                          "CHF ${auction.currentHighestBid ?? auction.reservePrice}",
                          style: FontManager.bodyMedium(
                            color: AppColors.sceTeal,
                          ).copyWith(fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow
                              .ellipsis, // fallback for extreme values
                        ),

                        SizedBox(height: 6.h),

                        // Time chip — sits below, full width available
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 6.w,
                              vertical: 3.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.07),
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.access_time_rounded,
                                  size: 10.sp,
                                  color: AppColors.textHint,
                                ),
                                SizedBox(width: 3.w),
                                Text(
                                  _getTimeRemaining(auction.endsAt),
                                  style: FontManager.bodySmall(
                                    color: AppColors.textHint,
                                  ).copyWith(fontSize: 10.sp),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Helpers ─────────────────────────────────────────────────────────────────

  Widget _buildImagePlaceholder({bool loading = false}) {
    return Container(
      color: Colors.white.withOpacity(0.07),
      child: Center(
        child: loading
            ? SizedBox(
                width: 20.w,
                height: 20.h,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.sceTeal.withOpacity(0.6),
                ),
              )
            : Icon(
                Icons.directions_car_outlined,
                color: AppColors.textHint.withOpacity(0.4),
                size: 32.sp,
              ),
      ),
    );
  }

  String _getTimeRemaining(DateTime? endsAt) {
    if (endsAt == null) {
      return "Ended";
    }
    final now = DateTime.now();
    final difference = endsAt.difference(now);

    if (difference.isNegative) {
      return "Ended";
    }

    if (difference.inDays > 0) {
      return "${difference.inDays}d ${difference.inHours % 24}h remaining";
    } else if (difference.inHours > 0) {
      return "${difference.inHours}h ${difference.inMinutes % 60}m remaining";
    } else {
      return "${difference.inMinutes}m remaining";
    }
  }

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
        border: Border.all(color: Colors.white.withOpacity(0.05)),
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
                        color: Colors.white.withOpacity(0.07),
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
      baseColor: Colors.white.withOpacity(0.05),
      highlightColor: Colors.white.withOpacity(0.1),
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
