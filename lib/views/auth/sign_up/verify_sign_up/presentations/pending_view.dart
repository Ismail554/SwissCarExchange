import 'dart:ui';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:rionydo/app_utils/constants/font_manager.dart';
import 'package:rionydo/controllers/auth/auth_provider.dart';
import 'package:rionydo/app_utils/constants/app_padding.dart';
import 'package:rionydo/app_utils/utils/app_spacing.dart';
import 'package:rionydo/app_utils/utils/app_colors.dart';
import 'package:rionydo/core/widgets/common_background.dart';
import 'package:rionydo/views/auth/sign_up/verify_sign_up/widget/widget_common_top_logocard.dart';
import 'package:rionydo/views/profile/widgets/logout_button.dart';

class PendingView extends StatefulWidget {
  const PendingView({super.key});

  @override
  State<PendingView> createState() => _PendingViewState();
}

class _PendingViewState extends State<PendingView> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startStatusCheck();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startStatusCheck() {
    // Check every 30 seconds
    _timer = Timer.periodic(const Duration(seconds: 30), (timer) async {
      if (!mounted) return;
      final shouldCancel = await context.read<AuthProvider>().checkApprovalStatus(context);
      if (shouldCancel) {
        _timer?.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CommonBackground(
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppSpacing.h24,
            // --- Section 1: Logo with Circular Ring ---
            const WidgetCommonTopLogocard(
              title: "Verification In Progress",
              subtitle: "Your dealer credentials are being reviewed",
            ),

            // --- Section 2: Frosted Glass Status Widget ---
            Padding(
              padding: AppPadding.h24v12,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24.r),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                  child: Container(
                    width: double.maxFinite,
                    padding: EdgeInsets.symmetric(
                      horizontal: 18.h,
                      vertical: 16.w,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        width: 1.5.w,
                        color: Colors.white.withOpacity(0.1),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildDataRow("Company", "Weber Auto AG"),
                        _buildDivider(),
                        _buildDataRow("Submitted", "05 Mar 2026"),
                        _buildDivider(),
                        _buildStatusRow("Status", "Under Review"),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const Spacer(),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 16.w),
              child: const LogoutButton(),
              // WidgetOutlinedBtn(
              //   title: 'Logout',
              //   icon: Icons.logout,
              //   themeColor: Colors.red,
              //   onPressed: () {

              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(builder: (context) => LoginViews()),
              //     );
              //   },
              // ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Helper Methods ---

  Widget _buildDataRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusRow(String label, String status) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
        Row(
          children: [
            Container(
              width: 8.w,
              height: 8.h,
              decoration: const BoxDecoration(
                color: AppColors.scePendingGreen,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: AppColors.scePendingGreen, blurRadius: 8),
                ],
              ),
            ),
           SizedBox(width: 10.w),
            Text(
              status,
              style: FontManager.bodyMedium(color: AppColors.scePendingGreen),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Divider(color: Colors.white.withOpacity(0.05), thickness: 1),
    );
  }
}
