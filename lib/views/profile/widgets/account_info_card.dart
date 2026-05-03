import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rionydo/app_utils/utils/app_colors.dart';
import 'package:rionydo/models/profile/user_profile_response.dart';
import 'package:rionydo/views/profile/widgets/profile_helpers.dart';

class AccountInfoCard extends StatelessWidget {
  final UserProfileResponse? profile;

  const AccountInfoCard({super.key, this.profile});

  @override
  Widget build(BuildContext context) {
    final p = profile;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.sceCardBg,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.darkGrey, width: 1),
      ),
      child: Column(
        children: [
          ProfileInfoRow('E-Mail', p?.email ?? '—'),
          const ProfileDivider(margin: EdgeInsets.zero),

          // Show UID for company, Full Name for private
          if (p is CompanyUserProfile) ...[
            ProfileInfoRow('UID Number', p.uid.isNotEmpty ? p.uid : '—'),
          ] else if (p is PrivateUserProfile) ...[
            ProfileInfoRow('Full Name', p.fullName.isNotEmpty ? p.fullName : '—'),
          ] else ...[
            const ProfileInfoRow('Info', '—'),
          ],

          const ProfileDivider(margin: EdgeInsets.zero),
          ProfileInfoRow('Phone', p?.phone.isNotEmpty == true ? p!.phone : '—'),
        ],
      ),
    );
  }
}
