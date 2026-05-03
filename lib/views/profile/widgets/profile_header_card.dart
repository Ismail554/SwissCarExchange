import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rionydo/app_utils/constants/font_manager.dart';
import 'package:rionydo/app_utils/utils/app_colors.dart';
import 'package:rionydo/app_utils/utils/app_spacing.dart';
import 'package:rionydo/views/profile/widgets/profile_helpers.dart';
import 'package:rionydo/views/bidding/widgets/bids_models.dart';
import 'package:rionydo/models/profile/user_profile_response.dart';

class ProfileHeaderCard extends StatelessWidget {
  final bool isPremium;
  final PeriodStats stats;
  final UserProfileResponse? profile;

  const ProfileHeaderCard({
    super.key,
    required this.isPremium,
    required this.stats,
    this.profile,
  });

  @override
  Widget build(BuildContext context) {
    // Derive display values from profile or fallback to defaults
    final String name = _displayName;
    final String memberSince = _memberSince;
    final String? avatarUrl = _avatarUrl;

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColors.sceCardBg,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.darkGrey, width: 1.w),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 28.r,
                backgroundImage: avatarUrl != null && avatarUrl.isNotEmpty
                    ? NetworkImage(avatarUrl)
                    : null,
                backgroundColor: AppColors.darkGrey,
                child: avatarUrl == null || avatarUrl.isEmpty
                    ? Icon(Icons.person, color: AppColors.grey, size: 28.r)
                    : null,
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: FontManager.heading3(color: AppColors.white),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      memberSince,
                      style: FontManager.bodySmall(color: AppColors.grey),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: isPremium
                      ? AppColors.scePremiumDealerBg
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(100.r),
                  border: Border.all(
                    color: isPremium ? AppColors.sceGold : AppColors.sceTeal,
                  ),
                ),
                child: Text(
                  isPremium ? 'Premium' : 'Basic',
                  style: TextStyle(
                    color: isPremium ? AppColors.sceGold : AppColors.sceTeal,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          AppSpacing.h20,
          Container(height: 1, color: AppColors.darkGrey),
          AppSpacing.h20,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ProfileStatItem(
                stats.auctionParticipate.toString(),
                'Auctions',
                AppColors.sceTeal,
              ),
              ProfileStatItem(
                stats.auctionsWon.toString(),
                'Won',
                AppColors.sceGold,
              ),
              ProfileStatItem(
                stats.winRate.toString(),
                'Success Rate',
                AppColors.sceTeal,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- Private helpers ---

  String get _displayName {
    final p = profile;
    if (p == null) return '—';
    return switch (p) {
      PrivateUserProfile() => p.fullName.isNotEmpty ? p.fullName : p.email,
      CompanyUserProfile() => p.company.isNotEmpty ? p.company : p.email,
    };
  }

  String get _memberSince {
    final p = profile;
    if (p == null) return '';
    final d = p.createdAt;
    return 'Member since ${d.year}';
  }

  String? get _avatarUrl {
    final p = profile;
    if (p == null) return null;
    return switch (p) {
      PrivateUserProfile() => p.photoUrl,
      CompanyUserProfile() => null,
    };
  }
}
