import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rionydo/core/utils/app_colors.dart';
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
          ProfileListTile(Icons.person_outline, 'Account Settings', onTap: () {  },),
          ProfileDivider(),
          ProfileListTile(Icons.notifications_outlined, 'Notification setting', onTap: () {  },),
          ProfileDivider(),
          ProfileListTile(Icons.credit_card_outlined, 'Payment Methods', onTap: () {  },),
          ProfileDivider(),
          ProfileListTile(Icons.emoji_events_outlined, 'Won Auctions', onTap: () {  },),
          ProfileDivider(), 
          ProfileListTile(Icons.security_outlined, 'Security & Privacy', onTap: () {  },),
          ProfileDivider(),
          ProfileListTile(Icons.language_outlined, 'Languages', onTap: () {  },),
          ProfileDivider(),
          ProfileListTile(Icons.help_outline, 'Help & Support', onTap: () {  },),
        ],
      ),
    );
  }
}
