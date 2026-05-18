import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:rionydo/core/widgets/custom_back_button.dart';
import 'package:shimmer/shimmer.dart';

import 'package:rionydo/app_utils/constants/font_manager.dart';
import 'package:rionydo/app_utils/utils/app_colors.dart';
import 'package:rionydo/app_utils/utils/app_spacing.dart';
import 'package:rionydo/controllers/auctions/auctions_detail_provider.dart';
import 'package:rionydo/core/widgets/common_background.dart';
import 'package:rionydo/core/widgets/widget_snackbar.dart';
import 'package:rionydo/views/auctions/widgets/auction_card.dart';

class MyWishlistView extends StatefulWidget {
  const MyWishlistView({super.key});

  @override
  State<MyWishlistView> createState() => _MyWishlistViewState();
}

class _MyWishlistViewState extends State<MyWishlistView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuctionsDetailProvider>().fetchWishlist();
    });
  }

  @override
  Widget build(BuildContext context) {
    return CommonBackground(
      appBar: AppBar(
        leading: CustomBackButton(),
        backgroundColor: Colors.transparent,
        title: Text(
          "My Wishlist",
          style: FontManager.heading1(color: Colors.white),
        ),
        centerTitle: false,
      ),
      child: SafeArea(
        child: Consumer<AuctionsDetailProvider>(
          builder: (context, provider, _) {
            if (provider.isWishlistLoading) {
              return _buildShimmerLoading();
            }

            final items = provider.wishlist;

            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppSpacing.h10,
                  Text(
                    "${items.length} Items found",
                    style: FontManager.bodyMedium(color: AppColors.textHint),
                  ),
                  AppSpacing.h10,
                  Expanded(
                    child: RefreshIndicator(
                      color: AppColors.sceTeal,
                      backgroundColor: AppColors.sceCardBg,
                      onRefresh: () async {
                        await provider.fetchWishlist();
                      },
                      child: items.isEmpty
                          ? ListView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              children: [
                                SizedBox(
                                  height: 300.h,
                                  child: Center(
                                    child: Text(
                                      "No items in your wishlist",
                                      style: FontManager.bodyMedium(
                                        color: AppColors.textHint,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : GridView.builder(
                              physics: const AlwaysScrollableScrollPhysics(),
                              padding: EdgeInsets.only(bottom: 20.h),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 16.w,
                                    mainAxisSpacing: 16.h,
                                    childAspectRatio: 0.54,
                                  ),
                              itemCount: items.length,
                              itemBuilder: (context, index) {
                                final item = items[index];
                                return AuctionCard(
                                  title: item.title,
                                  vehicleBrand: item.vehicleBrand,
                                  currentHighestBid: item.currentHighestBid,
                                  reservePrice: item.reservePrice,
                                  status: item.status,
                                  endsAt: item.endsAt,
                                  startsAt: item.startsAt,
                                  imageUrl: item.images.isNotEmpty
                                      ? item.images.first.url
                                      : null,
                                  onTap: () {
                                    context.push(
                                      '/auction-details',
                                      extra: item.toAuctionItem(),
                                    );
                                  },
                                  topRightOverlay: Padding(
                                    padding: EdgeInsets.only(
                                      right: 16.w,
                                      top: 8.h,
                                      bottom: 8.h,
                                    ),
                                    child: CircleAvatar(
                                      backgroundColor: Colors.black45,
                                      child: IconButton(
                                        icon: const Icon(
                                          Icons.favorite,
                                          color: Colors.red,
                                          size: 20,
                                        ),
                                        onPressed: () async {
                                          // Optimistic: item removed from list
                                          // instantly before the API resolves.
                                          final success = await provider
                                              .removeFromWishlist(
                                                item.id.toString(),
                                              );

                                          if (!success && context.mounted) {
                                            AppSnackBar.error(
                                              context,
                                              "Failed to remove. Please try again.",
                                            );
                                          } else if (context.mounted) {
                                            AppSnackBar.success(
                                              context,
                                              "Removed from wishlist",
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                  ),
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
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
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
