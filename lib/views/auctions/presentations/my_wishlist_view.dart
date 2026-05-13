import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'package:rionydo/app_utils/constants/font_manager.dart';
import 'package:rionydo/controllers/auctions/auctions_detail_provider.dart';
import 'package:rionydo/core/widgets/common_background.dart';
import 'package:rionydo/core/widgets/widget_snackbar.dart';
import 'package:rionydo/models/notification%20&%20wishlist/my_wishlist_response.dart';

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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        automaticallyImplyLeading: false,
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
              return const Center(
                child: CircularProgressIndicator(color: Colors.white),
              );
            }

            final items = provider.wishlist;

            if (items.isEmpty) {
              return Center(
                child: Text(
                  "No items in your wishlist",
                  style: FontManager.bodyMedium(color: Colors.white),
                ),
              );
            }

            return ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return _buildWishlistCard(item, context);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildWishlistCard(WishListItem item, BuildContext context) {
    // Since this is the wishlist view, we assume all items are watchlisted
    bool isWatchlisted = true;

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: const Color(0xFF091F19),
        borderRadius: BorderRadius.circular(12.r),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              // Vehicle Image
              Image.network(
                item.images.isNotEmpty
                    ? item.images.first.url
                    : 'https://placehold.co/600x400/1a1a2e/e0e0e0',
                height: 180.h,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 180.h,
                  color: Colors.grey.shade800,
                  child: const Center(
                    child: Icon(Icons.broken_image, color: Colors.white),
                  ),
                ),
              ),

              // Watchlist Action Button overlay
              Positioned(
                right: 0,
                top: 0,
                child: Padding(
                  padding: EdgeInsets.only(right: 16.w, top: 8.h, bottom: 8.h),
                  child: CircleAvatar(
                    backgroundColor: Colors.black45,
                    child: IconButton(
                      icon: Icon(
                        isWatchlisted ? Icons.favorite : Icons.favorite_border,
                        color: isWatchlisted ? Colors.red : Colors.white,
                        size: 20,
                      ),
                      onPressed: () async {
                        final provider = context.read<AuctionsDetailProvider>();

                        final success = await provider.toggleWatchlist(
                          item.id.toString(),
                        );

                        if (success && context.mounted) {
                          AppSnackBar.success(
                            context,
                            "Removed from watchlist",
                          );
                          // Refresh the wishlist
                          provider.fetchWishlist();
                        }
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Card Details
          Padding(
            padding: EdgeInsets.all(12.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 8.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Highest Bid: \$${item.currentHighestBid}",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white12,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Text(
                        item.status.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
