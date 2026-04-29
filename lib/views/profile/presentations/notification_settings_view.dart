import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rionydo/app_utils/constants/font_manager.dart';
import 'package:rionydo/app_utils/utils/app_colors.dart';
import 'package:rionydo/core/widgets/common_background.dart';
import 'package:rionydo/core/widgets/custom_back_button.dart';
import 'package:rionydo/views/profile/widgets/notification_setting_tile.dart';

class NotificationSettingsView extends StatefulWidget {
  const NotificationSettingsView({super.key});

  @override
  State<NotificationSettingsView> createState() => _NotificationSettingsViewState();
}

class _NotificationSettingsViewState extends State<NotificationSettingsView> {
  bool _newAuction = true;
  bool _payment = true;
  bool _general = false;
  bool _adminMessage = true;

  @override
  Widget build(BuildContext context) {
    return CommonBackground(
      appBar: AppBar(
        leading: const CustomBackButton(),
        title: Text(
          'Notification Settings',
          style: FontManager.titleText(color: AppColors.white),
        ),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
        child: Column(
          children: [
            NotificationSettingTile(
              title: "New Auction",
              subtitle: "Get notify when new classes are post",
              value: _newAuction,
              onChanged: (val) => setState(() => _newAuction = val),
            ),
            NotificationSettingTile(
              title: "Payment",
              subtitle: "Get notify for Payments Related",
              value: _payment,
              onChanged: (val) => setState(() => _payment = val),
            ),
            NotificationSettingTile(
              title: "General Notification",
              subtitle: "Get notify for general purpose",
              value: _general,
              onChanged: (val) => setState(() => _general = val),
            ),
            NotificationSettingTile(
              title: "Admin Message",
              subtitle: "Get notify for message from admin",
              value: _adminMessage,
              onChanged: (val) => setState(() => _adminMessage = val),
            ),
          ],
        ),
      ),
    );
  }
}