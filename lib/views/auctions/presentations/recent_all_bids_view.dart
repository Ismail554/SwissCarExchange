import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:rionydo/app_utils/constants/font_manager.dart';
import 'package:rionydo/app_utils/utils/app_colors.dart';
import 'package:rionydo/controllers/auctions/auctions_detail_provider.dart';
import 'package:rionydo/core/widgets/common_background.dart';
import 'package:rionydo/core/widgets/custom_back_button.dart';

class RecentAllBidsView extends StatelessWidget {
  final String auctionId;

  const RecentAllBidsView({super.key, required this.auctionId});

  double _parseBid(String value) {
    String cleanValue = value.replaceAll(',', '');
    return double.tryParse(cleanValue) ?? 0.0;
  }

  String _formatCurrency(int amount) {
    final str = amount.toString();
    if (str.length > 3) {
      return "${str.substring(0, str.length - 3)},${str.substring(str.length - 3)}";
    }
    return str;
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inSeconds < 60) return '${diff.inSeconds}s ago';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  @override
  Widget build(BuildContext context) {
    return CommonBackground(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const CustomBackButton(),
        title: Text(
          "All Bids",
          style: FontManager.titleText(color: AppColors.white),
        ),
        centerTitle: true,
      ),
      child: Consumer<AuctionsDetailProvider>(
        builder: (context, provider, _) {
          if (provider.isBidHistoryLoading && provider.bidHistory.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.sceTeal),
            );
          }

          if (provider.bidHistory.isEmpty) {
            return Center(
              child: Text(
                "No bids yet.",
                style: FontManager.bodySmall(color: AppColors.textHint),
              ),
            );
          }

          return RefreshIndicator(
            color: AppColors.sceTeal,
            backgroundColor: AppColors.sceCardBg,
            onRefresh: () => provider.fetchBidHistory(auctionId),
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: provider.bidHistory.length,
              separatorBuilder: (context, index) => SizedBox(height: 12.h),
              itemBuilder: (context, index) {
                final bid = provider.bidHistory[index];
                final gradient = bid.isMe
                    ? const LinearGradient(
                        colors: [Colors.grey, Colors.blueGrey],
                      )
                    : LinearGradient(
                        colors: [
                          Colors.primaries[bid.bidderAlias.hashCode.abs() %
                              Colors.primaries.length],
                          Colors.primaries[(bid.bidderAlias.hashCode.abs() +
                                  3) %
                              Colors.primaries.length],
                        ],
                      );
                final amount = _formatCurrency(
                  _parseBid(bid.amountAfter).toInt(),
                );

                return _buildBidTile(
                  bid.isMe ? "You" : bid.bidderAlias,
                  _timeAgo(bid.createdAt),
                  amount,
                  gradient,
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildBidTile(
    String name,
    String time,
    String amount,
    Gradient gradient,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.sceCardBg,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Row(
        children: [
          Container(
            width: 32.w,
            height: 32.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: gradient,
            ),
            alignment: Alignment.center,
            child: Text(
              name.isNotEmpty ? name[0].toUpperCase() : '?',
              style: FontManager.labelMedium(
                color: Colors.white,
              ).copyWith(fontSize: 12.sp, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(width: 12.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: FontManager.labelMedium(color: Colors.white)),
              SizedBox(height: 2.h),
              Text(
                time,
                style: FontManager.bodySmall(
                  color: AppColors.textHint,
                ).copyWith(fontSize: 11.sp),
              ),
            ],
          ),
          const Spacer(),
          Text(amount, style: FontManager.heading3(color: AppColors.sceTeal)),
        ],
      ),
    );
  }
}
