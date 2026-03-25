import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rionydo/core/constants/font_manager.dart';
import 'package:rionydo/core/utils/app_colors.dart';
import 'package:rionydo/core/widgets/common_background.dart';
import 'package:rionydo/core/widgets/custom_back_button.dart';
import 'package:rionydo/core/widgets/widget_snackbar.dart';

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
                  child: _buildStatCard(
                    "PENDING",
                    "280k",
                    AppColors.sceGold,
                    AppColors.sceGoldStatBg,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: _buildStatCard(
                    "RECEIVED",
                    "190k",
                    AppColors.sceTeal,
                    AppColors.sceTealStatBg,
                  ),
                ),
              ],
            ),

            SizedBox(height: 24.h),

            // ── TOGGLE CHIPS ──
            Row(
              children: [
                _buildFilterChip("Pending (2)", 0),
                SizedBox(width: 12.w),
                _buildFilterChip("Completed (2)", 1),
              ],
            ),

            SizedBox(height: 24.h),

            // ── PAYMENT LIST ──
            _selectedIndex == 0 ? _buildPendingList() : _buildCompletedList(),

            SizedBox(height: 24.h),

            // ── INFO CARD ──
            _buildInfoCard(),

            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    Color accentColor,
    Color bgColor,
  ) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: accentColor.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: FontManager.labelSmall(
              color: accentColor.withOpacity(0.6),
            ).copyWith(letterSpacing: 1.2, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.h),
          Text(
            value,
            style: FontManager.heading2(
              color: accentColor,
            ).copyWith(fontWeight: FontWeight.w900),
          ),
          Text(
            "CHF",
            style: FontManager.labelSmall(color: accentColor.withOpacity(0.4)),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, int index) {
    bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.scePremiumOrange
              : const Color(0xFF4A5568),
          borderRadius: BorderRadius.circular(10.r),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.scePremiumOrange.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Text(
          label,
          style: FontManager.labelMedium(color: Colors.white).copyWith(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildPendingList() {
    return Column(
      children: [
        _buildPaymentCard(
          title: "Swiss Motor Group AG",
          subtitle: "Porsche 911 GT3 2022",
          status: "PENDING",
          amount: "185,000",
          date: "Mar 1, 2026",
          statusColor: AppColors.sceGreyA0,
        ),
        SizedBox(height: 16.h),
        _buildPaymentCard(
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
        _buildPaymentCard(
          title: "Premium Autos GmbH",
          subtitle: "Audi R8 V10 Plus 2018",
          status: "COMPLETED",
          amount: "125,000",
          date: "Feb 25, 2026",
          statusColor: AppColors.sceTeal,
        ),
        SizedBox(height: 16.h),
        _buildPaymentCard(
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

  Widget _buildPaymentCard({
    required String title,
    required String subtitle,
    required String status,
    required String amount,
    required String date,
    required Color statusColor,
  }) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.sceCardBg,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 20.r,
                backgroundColor: AppColors.sceTeal.withOpacity(0.1),
                child: Icon(
                  Icons.person_outline_rounded,
                  color: AppColors.sceTeal,
                  size: 20.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: FontManager.bodyMedium(
                        color: Colors.white,
                      ).copyWith(fontWeight: FontWeight.bold, fontSize: 16.sp),
                    ),
                    Text(subtitle, style: FontManager.hintText()),
                  ],
                ),
              ),
              Text(
                status,
                style: FontManager.labelSmall(
                  color: statusColor,
                ).copyWith(fontWeight: FontWeight.bold, letterSpacing: 0.5),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Amount",
                    style: FontManager.labelSmall(color: AppColors.sceGreyA0),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    "CHF $amount",
                    style: FontManager.heading3(
                      color: AppColors.sceTeal,
                    ).copyWith(fontWeight: FontWeight.w900),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        color: AppColors.sceGreyA0,
                        size: 12.sp,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        "Date",
                        style: FontManager.labelSmall(
                          color: AppColors.sceGreyA0,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    date,
                    style: FontManager.bodyMedium(color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
          if (status == "COMPLETED") ...[
            SizedBox(height: 4.h),
            Divider(color: Colors.white.withOpacity(0.1), thickness: 1),
            SizedBox(height: 2.h),
            SizedBox(
              width: double.maxFinite,
              child: ElevatedButton.icon(
                onPressed: () {
                  AppSnackBar.success(context, "Invoice is downloading.....");
                },
                icon: Icon(
                  Icons.download_rounded,
                  color: Colors.white,
                  size: 18.sp,
                ),
                label: Text(
                  "Download Invoice",
                  style: FontManager.labelMedium(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4A5568),
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                    // side: Border.all(color: Colors.white.withOpacity(0.05)),
                  ),
                  elevation: 0,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.sceTealStatBg.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.sceTeal.withOpacity(0.1)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.attach_money_rounded,
            color: AppColors.sceTeal,
            size: 24.sp,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Payment Processing",
                  style: FontManager.bodyMedium(
                    color: Colors.white,
                  ).copyWith(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4.h),
                Text(
                  "Payments are transferred to your registered bank account within 2-3 business days after buyer confirmation.",
                  style: FontManager.bodySmall(
                    color: AppColors.textHint,
                  ).copyWith(height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
