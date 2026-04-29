import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:rionydo/app_utils/constants/font_manager.dart';
import 'package:rionydo/app_utils/constants/global_state.dart';
import 'package:rionydo/app_utils/utils/app_colors.dart';
import 'package:rionydo/app_utils/utils/app_spacing.dart';
import 'package:rionydo/core/widgets/common_background.dart';

import 'package:rionydo/views/profile/widgets/profile_helpers.dart';
import 'package:rionydo/views/profile/widgets/profile_header_card.dart';
import 'package:rionydo/views/profile/widgets/my_bids_tile.dart';
import 'package:rionydo/views/profile/widgets/dealer_rating_card.dart';
import 'package:rionydo/views/profile/widgets/upgrade_premium_card.dart';
import 'package:rionydo/views/profile/widgets/premium_features_card.dart';
import 'package:rionydo/views/profile/widgets/account_info_card.dart';
import 'package:rionydo/views/profile/widgets/settings_card.dart';
import 'package:rionydo/views/profile/widgets/logout_button.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
    final bool isPremium = context.watch<GlobalState>().isPremium;

    return CommonBackground(
      child: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Profile',
                    style: FontManager.heading1(color: AppColors.white),
                  ),
                  Row(
                    children: [
                      Text(
                        'Test Premium',
                        style: TextStyle(
                          color: AppColors.greyD9,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Switch(
                        value: isPremium,
                        activeColor: AppColors.sceGold,
                        inactiveTrackColor: AppColors.darkGrey,
                        onChanged: (val) {
                          context.read<GlobalState>().isPremium = val;
                        },
                      ),
                    ],
                  ),
                ],
              ),
              AppSpacing.h24,
              ProfileHeaderCard(isPremium: isPremium),
              AppSpacing.h16,
              const MyBidsTile(),
              AppSpacing.h24,
              const ProfileSectionTitle('DEALER RATING'),
              AppSpacing.h12,
              const DealerRatingCard(),
              AppSpacing.h24,
              isPremium
                  ? const PremiumFeaturesCard()
                  : const UpgradePremiumCard(),
              AppSpacing.h24,
              const ProfileSectionTitle('ACCOUNT INFORMATION'),
              AppSpacing.h12,
              const AccountInfoCard(),
              AppSpacing.h24,
              const ProfileSectionTitle('SETTINGS'),
              AppSpacing.h12,
              const SettingsCard(),
              AppSpacing.h32,
              const LogoutButton(),
              AppSpacing.h32,
            ],
          ),
        ),
      ),
    );
  }
}
