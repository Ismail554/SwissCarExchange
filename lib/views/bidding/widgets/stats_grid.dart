import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rionydo/core/constants/font_manager.dart';
import 'package:rionydo/core/utils/app_colors.dart';
import 'package:rionydo/views/bidding/widgets/bids_models.dart';

/// 2×2 grid of [StatCard] driven by a [PeriodStats] snapshot.
class StatsGrid extends StatelessWidget {
  final PeriodStats stats;

  const StatsGrid({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              StatCard(
                label: 'WIN RATE',
                value: stats.winRate,
                valueColor: AppColors.sceTeal,
                badge: stats.winRateBadge,
              ),
              SizedBox(height: 12.h),
              StatCard(
                label: 'AUCTIONS WON',
                value: stats.auctionsWon,
                valueColor: AppColors.white,
              ),
            ],
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            children: [
              StatCard(
                label: 'AVG BID',
                value: stats.avgBid,
                valueColor: AppColors.white,
              ),
              SizedBox(height: 12.h),
              StatCard(
                label: 'AUCTION PARTICIPATE',
                value: stats.auctionParticipate,
                valueColor: AppColors.sceGold,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Single analytics stat tile.
class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;
  final String? badge;

  const StatCard({
    super.key,
    required this.label,
    required this.value,
    required this.valueColor,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: const Color(0xFF0F1923),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.grey.withOpacity(0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: FontManager.labelSmall(color: AppColors.grey)),
          SizedBox(height: 6.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Text(
                  value,
                  key: ValueKey(value),
                  style: FontManager.heading2(color: valueColor),
                ),
              ),
              if (badge != null) ...[
                SizedBox(width: 6.w),
                Text(
                  '⬈ $badge',
                  style: FontManager.labelSmall(color: AppColors.sceTeal),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
