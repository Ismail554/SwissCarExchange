import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:rionydo/app_utils/constants/font_manager.dart';
import 'package:rionydo/app_utils/utils/app_colors.dart';
import 'package:rionydo/core/widgets/custom_button.dart';
import 'package:rionydo/core/widgets/custom_back_button.dart';
import 'package:rionydo/views/auctions/presentations/auction_bidding.dart';
import 'package:rionydo/views/auctions/widgets/auction_countdown.dart';
import 'package:rionydo/controllers/auctions/auctions_detail_provider.dart';
import 'package:rionydo/models/auctions/my_auctions_response.dart';
import 'package:rionydo/models/auctions/auctions_detail_response.dart';
import 'package:rionydo/models/auctions/auction_image.dart';
import 'package:rionydo/core/widgets/widget_snackbar.dart';

class AuctionDetails extends StatefulWidget {
  final AuctionItem data;
  const AuctionDetails({super.key, required this.data});

  @override
  State<AuctionDetails> createState() => _AuctionDetailsState();
}

class _AuctionDetailsState extends State<AuctionDetails> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuctionsDetailProvider>().fetchAuctionDetail(
        widget.data.id.toString(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Consumer<AuctionsDetailProvider>(
        builder: (context, provider, child) {
          final detail = provider.auctionDetail;
          final isLoading = provider.isLoading;

          return Stack(
            children: [
              CustomScrollView(
                slivers: [
                  // Image Header with Title Overlay
                  SliverAppBar(
                    backgroundColor: AppColors.primaryColor,
                    expandedHeight: 300.h,
                    pinned: true,
                    leading: const Align(
                      alignment: Alignment.centerLeft,
                      child: CustomBackButton(),
                    ),
                    leadingWidth: 64.w,
                    actions: [
                      Padding(
                        padding: EdgeInsets.only(
                          right: 16.w,
                          top: 8.h,
                          bottom: 8.h,
                        ),
                        child: CircleAvatar(
                          backgroundColor: Colors.black45,
                          child: IconButton(
                            icon: Icon(
                              detail?.isWatchlisted ?? false
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: detail?.isWatchlisted ?? false
                                  ? AppColors.errorRed
                                  : Colors.white,
                              size: 20,
                            ),
                            onPressed: () async {
                              final provider =
                                  context.read<AuctionsDetailProvider>();
                              final isCurrentlyWatchlisted =
                                  detail?.isWatchlisted ?? false;

                              final success = await provider.toggleWatchlist(
                                widget.data.id.toString(),
                              );

                              if (success && context.mounted) {
                                AppSnackBar.success(
                                  context,
                                  isCurrentlyWatchlisted
                                      ? "Removed from watchlist"
                                      : "Added to watchlist",
                                );
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                    flexibleSpace: FlexibleSpaceBar(
                      background: Stack(
                        fit: StackFit.expand,
                        children: [
                          // Image Carousel
                          Container(
                            color: Colors.white.withOpacity(0.1),
                            child: () {
                              final images =
                                  detail?.images ?? widget.data.images;
                              if (images.isEmpty) {
                                return const Icon(
                                  Icons.directions_car,
                                  color: AppColors.textHint,
                                  size: 50,
                                );
                              }
                              return Stack(
                                children: [
                                  PageView.builder(
                                    controller: _pageController,
                                    onPageChanged: (index) {
                                      setState(() {
                                        _currentPage = index;
                                      });
                                    },
                                    itemCount: images.length,
                                    itemBuilder: (context, index) {
                                      return Image.network(
                                        images[index].url,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                const Icon(
                                                  Icons.broken_image,
                                                  color: AppColors.textHint,
                                                  size: 50,
                                                ),
                                      );
                                    },
                                  ),
                                  // Carousel Indicator
                                  if (images.length > 1)
                                    Positioned(
                                      bottom: 40.h,
                                      left: 0,
                                      right: 0,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: List.generate(
                                          images.length,
                                          (index) => Container(
                                            width: 8.w,
                                            height: 8.w,
                                            margin: EdgeInsets.symmetric(
                                              horizontal: 4.w,
                                            ),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: _currentPage == index
                                                  ? AppColors.sceTeal
                                                  : Colors.white.withOpacity(
                                                      0.5,
                                                    ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              );
                            }(),
                          ),
                          // Gradient overlay
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            height: 120.h,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [
                                    Colors.black.withOpacity(0.9),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),
                          ),
                          // Title Overlay
                          Positioned(
                            bottom: 16.h,
                            left: 16.w,
                            right: 16.w,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  detail?.title ?? widget.data.title,
                                  style: FontManager.displaySmall(
                                    color: Colors.white,
                                  ).copyWith(fontSize: 24.sp),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  "Lot #${detail?.id ?? widget.data.id} • ${detail?.totalBidders ?? widget.data.totalBidders} Gebote",
                                  style: FontManager.bodyMedium(
                                    color: AppColors.textHint,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Content
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 24.h),

                          // Current Bid Container
                          _buildBidSection(detail, widget.data),

                          SizedBox(height: 12.h),
                          Text(
                            "Vehicle data",
                            style: FontManager.heading3(color: Colors.white),
                          ),

                          // Grid with Shimmer support
                          isLoading
                              ? _buildShimmerGrid()
                              : _buildVehicleDataGrid(detail),

                          Text(
                            "Description",
                            style: FontManager.heading3(color: Colors.white),
                          ),
                          SizedBox(height: 4.h),

                          // Description with Shimmer support
                          isLoading
                              ? _buildShimmerBox(height: 100.h)
                              : _buildDescriptionCard(detail?.description),

                          SizedBox(height: 140.h),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // Bottom Button
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: _buildBottomButton(context, widget.data),
              ),

              if (provider.errorMessage != null)
                _buildErrorOverlay(provider.errorMessage!),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBidSection(AuctionDetailResponse? detail, AuctionItem initial) {
    final currentBid = detail?.currentHighestBid ?? initial.currentHighestBid;
    final reservePrice = detail?.reservePrice ?? initial.reservePrice;
    final displayBid = currentBid ?? reservePrice;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.sceTealStatBg,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.sceTeal.withOpacity(0.3)),
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
              Text("CHF ", style: FontManager.heading1(color: Colors.white)),
              Text(
                displayBid,
                style: FontManager.heading1(
                  color: AppColors.sceTeal,
                ).copyWith(fontSize: 32.sp),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Text(
            "TIME REMAINING",
            style: FontManager.labelSmall(
              color: AppColors.textHint,
            ).copyWith(letterSpacing: 1.2),
          ),
          SizedBox(height: 8.h),
          AuctionCountdown(endTime: detail?.endsAt ?? initial.endsAt),
        ],
      ),
    );
  }

  Widget _buildVehicleDataGrid(AuctionDetailResponse? detail) {
    if (detail == null) return const SizedBox.shrink();
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 8.h,
      crossAxisSpacing: 8.w,
      childAspectRatio: 2.2,
      children: [
        _buildDataCard(
          Icons.calendar_today_outlined,
          "Year",
          detail.vehicleYear.toString(),
        ),
        _buildDataCard(
          Icons.speed_outlined,
          "Mileage",
          "${detail.vehicleMileage} km",
        ),
        _buildDataCard(
          Icons.local_gas_station_outlined,
          "Fuel",
          detail.vehicleFuelType,
        ),
        _buildDataCard(
          Icons.location_on_outlined,
          "Location",
          detail.vehicleLocation,
        ),
      ],
    );
  }

  Widget _buildDescriptionCard(String? description) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.sceCardBg,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Text(
        description ?? "Keine Beschreibung verfügbar.",
        style: FontManager.bodyMedium(
          color: AppColors.textHint,
        ).copyWith(height: 1.5),
      ),
    );
  }

  Widget _buildDataCard(IconData icon, String subtitle, String value) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.sceCardBg,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.sceTeal, size: 16.sp),
              SizedBox(width: 6.w),
              Text(
                subtitle,
                style: FontManager.bodySmall(
                  color: AppColors.textHint,
                ).copyWith(fontSize: 12.sp),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            value,
            style: FontManager.bodyMedium(
              color: Colors.white,
            ).copyWith(fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerGrid() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12.h,
      crossAxisSpacing: 12.w,
      childAspectRatio: 2.2,
      children: List.generate(4, (index) => _buildShimmerBox()),
    );
  }

  Widget _buildShimmerBox({double? height}) {
    return Shimmer.fromColors(
      baseColor: Colors.white.withOpacity(0.05),
      highlightColor: Colors.white.withOpacity(0.1),
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
    );
  }

  Widget _buildBottomButton(BuildContext context, AuctionItem initial) {
    return Container(
      padding: EdgeInsets.all(16.w).copyWith(bottom: 24.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            AppColors.primaryColor,
            AppColors.primaryColor.withOpacity(0.0),
          ],
        ),
      ),
      child: SafeArea(
        child: CustomButton(
          text: "OFFER NOW",
          onPressed: () {
            final detail = context.read<AuctionsDetailProvider>().auctionDetail;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    AuctionBidding(initialData: initial, detailData: detail),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildErrorOverlay(String message) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(24.w),
        margin: EdgeInsets.all(32.w),
        decoration: BoxDecoration(
          color: AppColors.sceCardBg,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: AppColors.errorRed.withOpacity(0.3)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline,
              color: AppColors.errorRed,
              size: 48,
            ),
            SizedBox(height: 16.h),
            Text(
              "Fehler beim Laden",
              style: FontManager.heading3(color: Colors.white),
            ),
            SizedBox(height: 8.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: FontManager.bodyMedium(color: AppColors.textHint),
            ),
            SizedBox(height: 24.h),
            ElevatedButton(
              onPressed: () {
                context.read<AuctionsDetailProvider>().fetchAuctionDetail(
                  widget.data.id.toString(),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.sceTeal,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: const Text("Wiederholen"),
            ),
          ],
        ),
      ),
    );
  }
}
