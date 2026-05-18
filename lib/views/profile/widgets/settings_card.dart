import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:rionydo/app_utils/utils/app_colors.dart';
import 'package:rionydo/views/profile/widgets/profile_helpers.dart';

class SettingsCard extends StatelessWidget {
  const SettingsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.sceCardBg,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.darkGrey, width: 1),
      ),
      child: Column(
        children: [
          ProfileListTile(
            Icons.person_outline,
            'Account Settings',
            onTap: () => context.push('/account-settings'),
          ),
          ProfileDivider(),
          ProfileListTile(
            Icons.notifications_outlined,
            'Notification setting',
            onTap: () => context.push('/notification-settings'),
          ),
          ProfileDivider(),
          ProfileListTile(
            Icons.currency_exchange_outlined,
            'Manage Subscription',
            onTap: () => context.push('/manage-subscription'),
          ),
          ProfileDivider(),
          ProfileListTile(
            Icons.credit_card_outlined,
            'Payment Methods',
            onTap: () => context.push('/payment-method'),
          ),
          ProfileDivider(),
          ProfileListTile(
            Icons.emoji_events_outlined,
            'Won Auctions',
            onTap: () => context.push('/won-auctions'),
          ),
          ProfileDivider(),
          ProfileListTile(
            Icons.security_outlined,
            'Security & Privacy',
            onTap: () => context.push('/privacy-settings'),
          ),
          ProfileDivider(),
          ProfileListTile(Icons.language_outlined, 'Languages', onTap: () {}),
          ProfileDivider(),
          ProfileListTile(
            Icons.help_outline,
            'Help & Support',
            onTap: () => context.push('/help-support'),
          ),
        ],
      ),
    );
  }
}
