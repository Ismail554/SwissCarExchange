import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:rionydo/app_utils/constants/font_manager.dart';
import 'package:rionydo/app_utils/utils/app_colors.dart';
import 'package:rionydo/app_utils/utils/assets_manager.dart';
import 'package:rionydo/core/widgets/common_background.dart';
import 'package:rionydo/core/widgets/custom_back_button.dart';
import 'package:rionydo/controllers/auctions/won_auction_provider.dart';
import 'package:rionydo/views/won_auction/widgets/won_auction_card.dart';

class WonAuctionHome extends StatefulWidget {
  const WonAuctionHome({super.key});

  @override
  State<WonAuctionHome> createState() => _WonAuctionHomeState();
}

class _WonAuctionHomeState extends State<WonAuctionHome> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WonAuctionProvider>().fetchWonAuctions();
    });
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WonAuctionProvider>(
      builder: (context, provider, child) {
        final auctions = provider.auctions;
        final totalCount = provider.response?.count ?? 0;

        return CommonBackground(
          appBar: AppBar(
            leading: const CustomBackButton(),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Won Auctions',
                  style: FontManager.titleText(color: AppColors.white),
                ),
                Text(
                  provider.isLoading 
                      ? 'Loading...' 
                      : '$totalCount vehicles won',
                  style: FontManager.bodySmall(color: AppColors.sceGreyA0),
                ),
              ],
            ),
          ),
          child: _buildBody(provider, auctions),
        );
      },
    );
  }

  Widget _buildBody(WonAuctionProvider provider, List auctions) {
    if (provider.isLoading) {
      return _buildShimmerLoading();
    }

    if (provider.errorMessage != null) {
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, color: AppColors.errorRed, size: 48.sp),
              SizedBox(height: 16.h),
              Text(
                'Something went wrong',
                style: FontManager.heading3(color: AppColors.white),
              ),
              SizedBox(height: 8.h),
              Text(
                provider.errorMessage!,
                textAlign: TextAlign.center,
                style: FontManager.bodyMedium(color: AppColors.sceGreyA0),
              ),
              SizedBox(height: 24.h),
              ElevatedButton(
                onPressed: () => provider.fetchWonAuctions(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.sceTeal,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                child: Text('Retry', style: FontManager.labelLarge(color: Colors.white)),
              ),
            ],
          ),
        ),
      );
    }

    if (auctions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.emoji_events_outlined, color: AppColors.sceOnboardingGold, size: 64.sp),
            SizedBox(height: 16.h),
            Text(
              'No won auctions yet',
              style: FontManager.heading3(color: AppColors.white),
            ),
            SizedBox(height: 8.h),
            Text(
              'Your successfully won vehicles will appear here.',
              style: FontManager.bodyMedium(color: AppColors.sceGreyA0),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      itemCount: auctions.length,
      itemBuilder: (context, index) {
        final auction = auctions[index];
        
        final imageUrl = auction.images.isNotEmpty 
            ? auction.images.first.url 
            : ImageAssets.car1; 

        final isPaymentCompleted = ['paid', 'payment_completed'].contains(auction.status.toLowerCase());

        return WonAuctionCard(
          auctionId: auction.id.toString(),
          imageUrl: imageUrl,
          title: auction.title,
          date: _formatDate(auction.endsAt),
          price: "CHF ${auction.currentHighestBid ?? auction.reservePrice}",
          isPaymentCompleted: isPaymentCompleted,
        );
      },
    );
  }

  Widget _buildShimmerLoading() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      itemCount: 3,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: AppColors.sceCardBg,
          highlightColor: AppColors.sceGreyA0.withOpacity(0.2),
          child: Container(
            margin: EdgeInsets.only(bottom: 20.h),
            decoration: BoxDecoration(
              color: AppColors.sceCardBg,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 180.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(height: 20.h, width: 200.w, color: Colors.white),
                      SizedBox(height: 12.h),
                      Row(
                        children: [
                          Container(height: 14.h, width: 80.w, color: Colors.white),
                          SizedBox(width: 16.w),
                          Container(height: 14.h, width: 80.w, color: Colors.white),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      Container(
                        height: 54.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Container(
                        height: 54.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
