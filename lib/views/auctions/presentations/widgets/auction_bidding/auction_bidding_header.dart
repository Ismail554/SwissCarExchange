import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:rionydo/app_utils/constants/font_manager.dart';
import 'package:rionydo/app_utils/utils/app_colors.dart';
import 'package:rionydo/core/widgets/custom_back_button.dart';
import 'package:rionydo/core/widgets/widget_snackbar.dart';
import 'package:rionydo/models/auctions/my_auctions_response.dart';
import 'package:rionydo/models/auctions/auctions_detail_response.dart';
import 'package:rionydo/controllers/auctions/auctions_detail_provider.dart';
import 'package:rionydo/views/auctions/widgets/video_player_widget.dart';

class AuctionBiddingHeader extends StatelessWidget {
  final AuctionItem initialData;
  final AuctionDetailResponse? detailData;
  final bool isAutoBidEnabled;

  const AuctionBiddingHeader({
    super.key,
    required this.initialData,
    this.detailData,
    required this.isAutoBidEnabled,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: AppColors.primaryColor,
      expandedHeight: 300.h,
      pinned: true,
      leading: Padding(
        padding: EdgeInsets.only(left: 6.w),
        child: Align(
          alignment: Alignment.centerLeft,
          child: CustomBackButton(),
        ),
      ),
      leadingWidth: 64.w,
      title: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.sceGold, width: 1),
          borderRadius: BorderRadius.circular(20.r),
          color: AppColors.sceCardBg.withValues(alpha: 0.8),
        ),
        child: Text(
          "3. LIVE BIDDING",
          style: FontManager.labelSmall(color: AppColors.sceGold),
        ),
      ),
      centerTitle: true,
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 16.w, top: 8.h, bottom: 8.h),
          child: CircleAvatar(
            backgroundColor: AppColors.sceCardBg.withValues(alpha: 0.8),
            child: Consumer<AuctionsDetailProvider>(
              builder: (context, provider, child) {
                final detail = provider.auctionDetail;
                final isWatchlisted = detail?.isWatchlisted ?? false;

                return IconButton(
                  icon: Icon(
                    isWatchlisted ? Icons.favorite : Icons.favorite_border,
                    color: isWatchlisted ? AppColors.errorRed : Colors.white,
                    size: 20,
                  ),
                  onPressed: () async {
                    final success = await provider.toggleWatchlist(
                      initialData.id.toString(),
                    );

                    if (success && context.mounted) {
                      AppSnackBar.success(
                        context,
                        isWatchlisted
                            ? "Removed from watchlist"
                            : "Added to watchlist",
                      );
                    }
                  },
                );
              },
            ),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 20.h),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
              ),
              child: (detailData?.images ?? initialData.images).isNotEmpty
                  ? Image.network(
                      (detailData?.images ?? initialData.images).first.url,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.white10,
                        child: const Icon(
                          Icons.image_not_supported_outlined,
                          color: Colors.white24,
                        ),
                      ),
                    )
                  : Container(
                      color: Colors.white10,
                      child: const Icon(
                        Icons.image_not_supported_outlined,
                        color: Colors.white24,
                      ),
                    ),
            ),
            if (isAutoBidEnabled)
              Positioned(
                top: 100.h,
                left: 16.w,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.sceTeal,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.trending_up,
                        color: Colors.white,
                        size: 14.sp,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        "Auto Bid Enabled",
                        style: FontManager.labelSmall(
                          color: Colors.white,
                        ).copyWith(fontSize: 10.sp),
                      ),
                    ],
                  ),
                ),
              ),
            // Video play button (centered)
            if ((detailData?.videoUrl ?? '').isNotEmpty)
              Positioned.fill(
                child: Center(
                  child: VideoPlayButton(
                    videoUrl: detailData!.videoUrl!,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
