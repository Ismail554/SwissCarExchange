import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rionydo/core/utils/app_colors.dart';
import 'package:rionydo/views/profile/widgets/profile_helpers.dart';

class AccountInfoCard extends StatelessWidget {
  const AccountInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.sceCardBg,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.darkGrey, width: 1),
      ),
      child: const Column(
        children: [
          ProfileInfoRow('E-Mail', 'info@premiumauto.ch'),
          ProfileDivider(margin: EdgeInsets.zero),
          ProfileInfoRow('UID Number', 'CHE-123.456.789'),
          ProfileDivider(margin: EdgeInsets.zero),
          ProfileInfoRow('Phone', '+41 79 123 45 67'),
        ],
      ),
    );
  }
}
