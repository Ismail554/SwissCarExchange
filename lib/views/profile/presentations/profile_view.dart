import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:rionydo/core/constants/font_manager.dart';
import 'package:rionydo/core/constants/global_state.dart';
import 'package:rionydo/core/utils/app_colors.dart';
import 'package:rionydo/core/utils/app_spacing.dart';
import 'package:rionydo/core/widgets/common_background.dart';

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
              _buildTopCard(isPremium),
              AppSpacing.h16,
              _buildMyBidsCard(),
              AppSpacing.h24,
              _buildSectionTitle('DEALER RATING'),
              AppSpacing.h12,
              _buildDealerRatingCard(),
              AppSpacing.h24,
              isPremium ? _buildPremiumFeatures() : _buildUpgradeToPremiumCard(),
              AppSpacing.h24,
              _buildSectionTitle('ACCOUNT INFORMATION'),
              AppSpacing.h12,
              _buildAccountInfoCard(),
              AppSpacing.h24,
              _buildSectionTitle('SETTINGS'),
              AppSpacing.h12,
              _buildSettingsCard(),
              AppSpacing.h32,
              _buildLogoutButton(),
              AppSpacing.h32,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(left: 4.w),
      child: Text(
        title,
        style: TextStyle(
          color: AppColors.greyD4,
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildTopCard(bool isPremium) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColors.sceCardBg,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.darkGrey, width: 1),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 28.r,
                backgroundImage: const NetworkImage('https://i.pravatar.cc/150?img=11'),
                backgroundColor: AppColors.darkGrey,
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Premium Auto\nGroup AG',
                      style: FontManager.heading3(color: AppColors.white),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Member since 2023',
                      style: FontManager.bodySmall(color: AppColors.grey),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: isPremium ? AppColors.scePremiumDealerBg : Colors.transparent,
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
          Container(
            height: 1,
            color: AppColors.darkGrey,
          ),
          AppSpacing.h20,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem('47', 'Bids', AppColors.sceTeal),
              _buildStatItem('12', 'Won', AppColors.sceGold),
              _buildStatItem('96%', 'Success Rate', AppColors.sceTeal),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label, Color valueColor) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontSize: 22.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: FontManager.bodySmall(color: AppColors.grey),
        ),
      ],
    );
  }

  Widget _buildMyBidsCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.sceCardBg,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.darkGrey, width: 1),
      ),
      child: ListTile(
        leading: Icon(Icons.feed_outlined, color: AppColors.sceGold, size: 20.sp),
        title: Text(
          'My Bids',
          style: TextStyle(
            color: AppColors.sceGold,
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: Icon(Icons.chevron_right, color: AppColors.grey, size: 20.sp),
        onTap: () {},
      ),
    );
  }

  Widget _buildDealerRatingCard() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColors.sceCardBg,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.darkGrey, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: const BoxDecoration(
                  color: AppColors.buttonColor, 
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.star, color: AppColors.white, size: 24.sp),
              ),
              SizedBox(width: 16.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '4.6',
                        style: TextStyle(
                          color: AppColors.sceGold,
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 4.h),
                        child: Text(
                          ' / 5',
                          style: TextStyle(
                            color: AppColors.grey,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Based on 28 reviews',
                    style: FontManager.bodySmall(color: AppColors.grey),
                  ),
                ],
              ),
            ],
          ),
          AppSpacing.h20,
          Container(
            height: 1,
            color: AppColors.darkGrey,
          ),
          AppSpacing.h16,
          Text(
            '28 completed sales',
            style: FontManager.bodyMedium(color: AppColors.greyD4),
          ),
          AppSpacing.h16,
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: AppColors.darkGrey),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                padding: EdgeInsets.symmetric(vertical: 12.h),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'View All Reviews',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Icon(Icons.chevron_right, color: AppColors.white, size: 18.sp),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpgradeToPremiumCard() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF3B250A),
            Color(0xFF1D1408),
          ],
        ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.sceGold.withOpacity(0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Upgrade to Premium',
            style: TextStyle(
              color: AppColors.sceGold,
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          AppSpacing.h12,
          Text(
            'Get priority bidding, advanced analytics, and\ncreate your own auctions.',
            style: TextStyle(color: AppColors.greyD9, fontSize: 13.sp, height: 1.4),
          ),
          AppSpacing.h16,
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              backgroundColor: AppColors.scePremiumDealerBg,
              side: BorderSide(color: AppColors.sceGold.withOpacity(0.5)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Text(
              'View Benefits',
              style: TextStyle(
                color: AppColors.sceGold,
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumFeatures() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 4.w, bottom: 12.h),
          child: Row(
            children: [
              Icon(Icons.workspace_premium, color: AppColors.sceGold, size: 20.sp),
              SizedBox(width: 8.w),
              Text(
                'PREMIUM FEATURES',
                style: TextStyle(
                  color: AppColors.sceGold,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.sceCardBg,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: AppColors.darkGrey, width: 1),
          ),
          child: Column(
            children: [
              _buildListTile(Icons.add, 'Create Auction', isPremiumFeature: true),
              _buildDivider(),
              _buildListTile(Icons.inventory_2_outlined, 'Auction Management', isPremiumFeature: true),
              _buildDivider(),
              _buildListTile(Icons.trending_up, 'Advanced Statistics', isPremiumFeature: true),
              _buildDivider(),
              _buildListTile(Icons.attach_money, 'Receive Payments', isPremiumFeature: true),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAccountInfoCard() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.sceCardBg,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.darkGrey, width: 1),
      ),
      child: Column(
        children: [
          _buildInfoRow('E-Mail', 'info@premiumauto.ch'),
          _buildDivider(margin: EdgeInsets.zero),
          _buildInfoRow('UID Number', 'CHE-123.456.789'),
          _buildDivider(margin: EdgeInsets.zero),
          _buildInfoRow('Phone', '+41 79 123 45 67'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: FontManager.bodySmall(color: AppColors.grey),
            ),
            SizedBox(height: 4.h),
            Text(
              value,
              style: FontManager.bodyMedium(color: AppColors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.sceCardBg,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.darkGrey, width: 1),
      ),
      child: Column(
        children: [
          _buildListTile(Icons.person_outline, 'Account Settings'),
          _buildDivider(),
          _buildListTile(Icons.notifications_outlined, 'Notification setting'),
          _buildDivider(),
          _buildListTile(Icons.credit_card_outlined, 'Payment Methods'),
          _buildDivider(),
          _buildListTile(Icons.emoji_events_outlined, 'Won Auctions'),
          _buildDivider(),
          _buildListTile(Icons.security_outlined, 'Security & Privacy'),
          _buildDivider(),
          _buildListTile(Icons.language_outlined, 'Languages'),
          _buildDivider(),
          _buildListTile(Icons.help_outline, 'Help & Support'),
        ],
      ),
    );
  }

  Widget _buildListTile(IconData icon, String title, {bool isPremiumFeature = false}) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 4.h),
      leading: Icon(
        icon,
        color: isPremiumFeature ? AppColors.sceGold : AppColors.greyD9,
        size: 22.sp,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: AppColors.white,
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Icon(Icons.chevron_right, color: AppColors.grey, size: 20.sp),
      onTap: () {},
    );
  }

  Widget _buildDivider({EdgeInsetsGeometry? margin}) {
    return Container(
      height: 1,
      color: AppColors.darkGrey,
      margin: margin ?? EdgeInsets.symmetric(horizontal: 20.w),
    );
  }

  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () {},
        style: OutlinedButton.styleFrom(
          backgroundColor: AppColors.error.withOpacity(0.05),
          side: BorderSide(color: AppColors.error.withOpacity(0.3)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          padding: EdgeInsets.symmetric(vertical: 16.h),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout, color: AppColors.error, size: 20.sp),
            SizedBox(width: 8.w),
            Text(
              'Logout',   
              style: FontManager.bodyMedium(color: AppColors.error),
            ),
          ],
        ),
      ),
    );
  }
}
