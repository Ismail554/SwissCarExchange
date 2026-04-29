import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rionydo/app_utils/constants/font_manager.dart';
import 'package:rionydo/app_utils/utils/app_colors.dart';
import 'package:rionydo/core/widgets/common_background.dart';
import 'package:rionydo/core/widgets/custom_back_button.dart';
import 'package:rionydo/views/premium/widgets/payment_filter_chip.dart';
import 'package:rionydo/views/premium/widgets/payment_info_card.dart';
import 'package:rionydo/views/premium/widgets/payment_stat_card.dart';
import 'package:rionydo/views/premium/widgets/payment_transaction_card.dart';

class RecievePayments extends StatefulWidget {
  const RecievePayments({super.key});

  @override
  State<RecievePayments> createState() => _RecievePaymentsState();
}

class _RecievePaymentsState extends State<RecievePayments> {
  int _selectedIndex = 0; // 0 for Pending, 1 for Completed

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
                  "Receive Payments",
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
            Text("Track your earnings", style: FontManager.hintText()),
          ],
        ),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            SizedBox(height: 16.h),

            // ── TOP STATS ──
            Row(
              children: [
                Expanded(
                  child: PaymentStatCard(
                    label: "PENDING",
                    value: "280k",
                    accentColor: AppColors.sceGold,
                    bgColor: AppColors.sceGoldStatBg,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: PaymentStatCard(
                    label: "RECEIVED",
                    value: "190k",
                    accentColor: AppColors.sceTeal,
                    bgColor: AppColors.sceTealStatBg,
                  ),
                ),
              ],
            ),

            SizedBox(height: 24.h),

            // ── TOGGLE CHIPS ──
            Row(
              children: [
                PaymentFilterChip(
                  label: "Pending (2)",
                  isSelected: _selectedIndex == 0,
                  onTap: () => setState(() => _selectedIndex = 0),
                ),
                SizedBox(width: 12.w),
                PaymentFilterChip(
                  label: "Completed (2)",
                  isSelected: _selectedIndex == 1,
                  onTap: () => setState(() => _selectedIndex = 1),
                ),
              ],
            ),

            SizedBox(height: 24.h),

            // ── PAYMENT LIST ──
            _selectedIndex == 0 ? _buildPendingList() : _buildCompletedList(),

            SizedBox(height: 24.h),

            // ── INFO CARD ──
            const PaymentInfoCard(),

            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }

  Widget _buildPendingList() {
    return Column(
      children: [
        const PaymentTransactionCard(
          title: "Swiss Motor Group AG",
          subtitle: "Porsche 911 GT3 2022",
          status: "PENDING",
          amount: "185,000",
          date: "Mar 1, 2026",
          statusColor: AppColors.sceGreyA0,
        ),
        SizedBox(height: 16.h),
        const PaymentTransactionCard(
          title: "Elite Cars Zürich",
          subtitle: "Mercedes-AMG GT 2021",
          status: "PROCESSING",
          amount: "95,000",
          date: "Mar 2, 2026",
          statusColor: AppColors.sceGold,
        ),
      ],
    );
  }

  Widget _buildCompletedList() {
    return Column(
      children: [
        const PaymentTransactionCard(
          title: "Premium Autos GmbH",
          subtitle: "Audi R8 V10 Plus 2018",
          status: "COMPLETED",
          amount: "125,000",
          date: "Feb 25, 2026",
          statusColor: AppColors.sceTeal,
        ),
        SizedBox(height: 16.h),
        const PaymentTransactionCard(
          title: "Luxury Rides Basel",
          subtitle: "BMW M5 Competition 2023",
          status: "COMPLETED",
          amount: "142,000",
          date: "Feb 20, 2026",
          statusColor: AppColors.sceTeal,
        ),
      ],
    );
  }
}
