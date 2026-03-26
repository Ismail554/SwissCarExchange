import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rionydo/core/utils/app_colors.dart';
import 'package:rionydo/views/profile/presentations/account_settings_view.dart';
import 'package:rionydo/views/profile/presentations/notification_settings_view.dart';
import 'package:rionydo/views/profile/presentations/payment_method_view.dart';
import 'package:rionydo/views/profile/widgets/profile_helpers.dart';
import 'package:rionydo/views/won_auction/presentations/won_auction_home.dart';

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
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AccountSettingsView(),
                ),
              );
            },
          ),
          ProfileDivider(),
          ProfileListTile(
            Icons.notifications_outlined,
            'Notification setting',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationSettingsView(),
                ),
              );
            },
          ),
          ProfileDivider(),
          ProfileListTile(
            Icons.credit_card_outlined,
            'Payment Methods',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PaymentMethodView(),
                ),
              );
            },
          ),
          ProfileDivider(),
          ProfileListTile(
            Icons.emoji_events_outlined,
            'Won Auctions',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const WonAuctionHome()),
              );
            },
          ),
          ProfileDivider(),
          ProfileListTile(
            Icons.security_outlined,
            'Security & Privacy',
            onTap: () {},
          ),
          ProfileDivider(),
          ProfileListTile(Icons.language_outlined, 'Languages', onTap: () {}),
          ProfileDivider(),
          ProfileListTile(Icons.help_outline, 'Help & Support', onTap: () {}),
        ],
      ),
    );
  }
}
