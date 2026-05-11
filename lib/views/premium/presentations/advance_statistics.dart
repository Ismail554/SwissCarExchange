import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:rionydo/app_utils/constants/font_manager.dart';
import 'package:rionydo/app_utils/utils/app_colors.dart';
import 'package:rionydo/core/widgets/common_background.dart';
import 'package:rionydo/core/widgets/custom_back_button.dart';
import 'package:rionydo/controllers/advance_statistics_provider.dart';
import '../../home/widgets/stat_card.dart';

class AdvanceStatistics extends StatefulWidget {
  const AdvanceStatistics({super.key});

  @override
  State<AdvanceStatistics> createState() => _AdvanceStatisticsState();
}

class _AdvanceStatisticsState extends State<AdvanceStatistics> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdvanceStatisticsProvider>().fetchAdvanceStatistics();
    });
  }

  @override
  Widget build(BuildContext context) {
    return CommonBackground(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const CustomBackButton(),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "Advanced Statistics",
                  style: FontManager.titleText(
                    color: Colors.white,
                  ).copyWith(fontSize: 18.sp),
                ),
                SizedBox(width: 4.w),
                Icon(
                  Icons.workspace_premium_rounded,
                  color: AppColors.sceGold,
                  size: 18.sp,
                ),
              ],
            ),
            Text("Premium dealer insights", style: FontManager.hintText()),
          ],
        ),
      ),
      child: Consumer<AdvanceStatisticsProvider>(
        builder: (context, provider, child) {
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: provider.isLoading
                ? _buildShimmerLoading()
                : provider.error != null
                ? _buildErrorWidget(
                    provider.error!,
                    () => provider.fetchAdvanceStatistics(),
                  )
                : provider.statistics == null
                ? _buildErrorWidget(
                    "No data available",
                    () => provider.fetchAdvanceStatistics(),
                  )
                : _buildContent(provider.statistics!),
          );
        },
      ),
    );
  }

  Widget _buildContent(dynamic stats) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20.h),

        // ── STATISTICS GRID ──
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 16.h,
          crossAxisSpacing: 16.w,
          childAspectRatio: 1.4,
          children: [
            StatCard(
              label: "SELL-THROUGH RATE",
              value: "${stats.sellThroughRate.toStringAsFixed(1)}%",
              accentColor: AppColors.sceTeal,
            ),
            StatCard(
              label: "AVG SALE PRICE",
              value: stats.avgSellPrice,
              accentColor: AppColors.sceGold,
              isWatchlist: true, // Use gold bg
            ),
            StatCard(
              label: "TOTAL REVENUE",
              value: stats.totalRevenue,
              accentColor: AppColors.sceTeal,
            ),
            StatCard(
              label: "WIN RATE",
              value: "${stats.winRate.toStringAsFixed(1)}%",
              accentColor: Colors.white.withOpacity(0.9),
            ),
          ],
        ),

        SizedBox(height: 32.h),

        // ── PERFORMANCE SUMMARY ──
        Text(
          "PERFORMANCE SUMMARY",
          style: FontManager.labelMedium(
            color: AppColors.sceGreyA0,
          ).copyWith(letterSpacing: 1.2, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16.h),

        Container(
          decoration: BoxDecoration(
            color: AppColors.sceCardBg,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: Colors.white.withOpacity(0.05)),
          ),
          child: Column(
            children: [
              _buildSummaryItem(
                icon: Icons.inventory_2_outlined,
                label: "Active Listings",
                value: stats.activeAuctions.toString(),
                iconColor: AppColors.sceTeal,
              ),
              _buildDivider(),
              _buildSummaryItem(
                icon: Icons.track_changes_rounded,
                label: "Total Sold",
                value: stats.soldCount.toString(),
                iconColor: AppColors.sceTeal,
              ),
              _buildDivider(),
              _buildSummaryItem(
                icon: Icons.attach_money_rounded,
                label: "Total Revenue",
                value: "CHF ${stats.totalRevenue}",
                iconColor: AppColors.sceGold,
                isCurrency: true,
              ),
            ],
          ),
        ),
        SizedBox(height: 40.h),
      ],
    );
  }

  Widget _buildSummaryItem({
    required IconData icon,
    required String label,
    required String value,
    required Color iconColor,
    bool isCurrency = false,
  }) {
    return Padding(
      padding: EdgeInsets.all(20.r),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 24.sp),
          SizedBox(width: 16.w),
          Text(
            label,
            style: FontManager.bodyMedium(
              color: Colors.white,
            ).copyWith(fontSize: 16.sp),
          ),
          const Spacer(),
          Text(
            value,
            style: FontManager.heading3(color: Colors.white).copyWith(
              fontSize: isCurrency ? 20.sp : 24.sp,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: Colors.white.withOpacity(0.05),
      indent: 20.w,
      endIndent: 20.w,
    );
  }

  Widget _buildShimmerLoading() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20.h),
        // Statistics Grid Shimmer
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 16.h,
          crossAxisSpacing: 16.w,
          childAspectRatio: 1.4,
          children: List.generate(
            4,
            (index) => _buildShimmerBox(
              height: 100.h,
              borderRadius: BorderRadius.circular(16.r),
            ),
          ),
        ),
        SizedBox(height: 32.h),
        // Summary Title Shimmer
        _buildShimmerBox(width: 150.w, height: 16.h),
        SizedBox(height: 16.h),
        // Summary Container Shimmer
        Container(
          decoration: BoxDecoration(
            color: AppColors.sceCardBg,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: Colors.white.withOpacity(0.05)),
          ),
          child: Column(
            children: [
              _buildSummaryShimmerItem(),
              _buildDivider(),
              _buildSummaryShimmerItem(),
              _buildDivider(),
              _buildSummaryShimmerItem(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryShimmerItem() {
    return Padding(
      padding: EdgeInsets.all(20.r),
      child: Row(
        children: [
          _buildShimmerBox(
            width: 24.w,
            height: 24.h,
            borderRadius: BorderRadius.circular(12.r),
          ),
          SizedBox(width: 16.w),
          _buildShimmerBox(width: 100.w, height: 16.h),
          const Spacer(),
          _buildShimmerBox(width: 50.w, height: 20.h),
        ],
      ),
    );
  }

  Widget _buildShimmerBox({
    double? width,
    double? height,
    BorderRadius? borderRadius,
  }) {
    return Shimmer.fromColors(
      baseColor: Colors.white.withOpacity(0.05),
      highlightColor: Colors.white.withOpacity(0.1),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: borderRadius ?? BorderRadius.circular(4.r),
        ),
      ),
    );
  }

  Widget _buildErrorWidget(String error, VoidCallback onRetry) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 40.h, horizontal: 20.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                color: AppColors.errorRed.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline_rounded,
                color: AppColors.errorRed,
                size: 40.sp,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              "Could not load statistics",
              style: FontManager.heading3(color: Colors.white),
            ),
            SizedBox(height: 8.h),
            Text(
              error,
              textAlign: TextAlign.center,
              style: FontManager.bodyMedium(color: AppColors.sceGreyA0),
            ),
            SizedBox(height: 24.h),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text("Retry"),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.sceTeal,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
