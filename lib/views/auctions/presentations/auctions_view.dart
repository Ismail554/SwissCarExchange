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
    "Upcoming",
    "Sold",
    "Unsold",
    "Withdrawn",
    "Payment Expired",
    "Shipping Expired",
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
      case "Upcoming":
        return "upcoming";
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
                  return const Expanded(
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.sceTeal,
                      ),
                    ),
                  );
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
                        child: auctions.isEmpty
                            ? Center(
                                child: Text(
                                  "No auctions found",
                                  style: FontManager.bodyMedium(
                                    color: AppColors.textHint,
                                  ),
                                ),
                              )
                            : GridView.builder(
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section
            Expanded(
              flex: 4,
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(16.r),
                      ),
                      color: Colors.white.withOpacity(0.1),
                      image: auction.images.isNotEmpty
                          ? DecorationImage(
                              image: NetworkImage(auction.images.first.url),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    width: double.maxFinite,
                    child: auction.images.isEmpty
                        ? const Icon(
                            Icons.directions_car,
                            color: AppColors.textHint,
                          )
                        : null,
                  ),
                  if (auction.status == "active")
                    Positioned(
                      top: 8.h,
                      right: 8.w,
                      child: Container(
                        width: 10.w,
                        height: 10.w,
                        decoration: const BoxDecoration(
                          color: Colors.greenAccent,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            // Details Section
            Expanded(
              flex: 5,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
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
                        SizedBox(height: 4.h),
                        Text(
                          auction.vehicleBrand,
                          style: FontManager.bodySmall(
                            color: AppColors.textHint,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Current Bid",
                          style: FontManager.bodySmall(
                            color: AppColors.textHint,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          "CHF ${auction.currentHighestBid ?? auction.reservePrice}",
                          style: FontManager.bodyMedium(
                            color: AppColors.sceTeal,
                          ).copyWith(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          _getTimeRemaining(auction.createdAt),
                          style: FontManager.bodySmall(
                            color: AppColors.textHint,
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

  String _getTimeRemaining(DateTime endsAt) {
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
}
