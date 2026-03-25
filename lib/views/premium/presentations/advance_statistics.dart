import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rionydo/core/constants/font_manager.dart';
import 'package:rionydo/core/utils/app_colors.dart';
import 'package:rionydo/core/widgets/common_background.dart';
import 'package:rionydo/core/widgets/custom_back_button.dart';
import '../../home/widgets/stat_card.dart';

class AdvanceStatistics extends StatefulWidget {
  const AdvanceStatistics({super.key});

  @override
  State<AdvanceStatistics> createState() => _AdvanceStatisticsState();
}

class _AdvanceStatisticsState extends State<AdvanceStatistics> {
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
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
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
                const StatCard(
                  label: "SELL-THROUGH RATE",
                  value: "87%",
                  subValue: "↗ +3%",
                  accentColor: AppColors.sceTeal,
                ),
                StatCard(
                  label: "AVG SALE PRICE",
                  value: "235k",
                  accentColor: AppColors.sceGold,
                  isWatchlist: true, // Use gold bg
                ),
                const StatCard(
                  label: "TOTAL REVENUE",
                  value: "2.23M",
                  accentColor: AppColors.sceTeal,
                ),
                StatCard(
                  label: "WIN RATE",
                  value: "92%",
                  accentColor: Colors.white.withOpacity(0.9),
                ),
              ],
            ),

            SizedBox(height: 32.h),

            // ── PERFORMANCE SUMMARY ──
            Text(
              "PERFORMANCE SUMMARY",
              style: FontManager.labelMedium(color: AppColors.sceGreyA0).copyWith(
                letterSpacing: 1.2,
                fontWeight: FontWeight.bold,
              ),
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
                    value: "3",
                    iconColor: AppColors.sceTeal,
                  ),
                  _buildDivider(),
                  _buildSummaryItem(
                    icon: Icons.track_changes_rounded,
                    label: "Total Sold",
                    value: "23",
                    iconColor: AppColors.sceTeal,
                  ),
                  _buildDivider(),
                  _buildSummaryItem(
                    icon: Icons.attach_money_rounded,
                    label: "Total Revenue",
                    value: "CHF 2235k",
                    iconColor: AppColors.sceGold,
                    isCurrency: true,
                  ),
                ],
              ),
            ),
            SizedBox(height: 40.h),
          ],
        ),
      ),
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
            style: FontManager.bodyMedium(color: Colors.white).copyWith(fontSize: 16.sp),
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
}
