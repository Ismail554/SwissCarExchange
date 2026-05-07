import 'package:flutter/material.dart';
import 'package:rionydo/services/firebase_service.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rionydo/app_utils/constants/font_manager.dart';
import 'package:rionydo/app_utils/utils/app_colors.dart';
import 'package:rionydo/core/widgets/common_background.dart';
import 'package:rionydo/core/widgets/custom_back_button.dart';
import 'package:rionydo/views/profile/widgets/notification_setting_tile.dart';
import 'package:rionydo/app_utils/constants/api_service.dart';
import 'package:rionydo/app_utils/network/dio_manager.dart';
import 'package:rionydo/app_utils/network/enums.dart';

class NotificationSettingsView extends StatefulWidget {
  const NotificationSettingsView({super.key});

  @override
  State<NotificationSettingsView> createState() => _NotificationSettingsViewState();
}

class _NotificationSettingsViewState extends State<NotificationSettingsView> {
  bool _newAuction = true;
  bool _auctionUpdate = true;
  bool _general = false;
  bool _adminMessage = true;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPreferences();
  }

  Future<void> _fetchPreferences() async {
    try {
      final response = await DioManager.apiRequest(
        url: ApiService.notificationPreferences,
        method: Methods.get,
      );
      response.fold(
        (error) => debugPrint("Error fetching notification preferences: \$error"),
        (data) {
          if (data != null && data is Map<String, dynamic>) {
            setState(() {
              _newAuction = data['new_auction_enabled'] ?? true;
              _auctionUpdate = data['auction_updates_enabled'] ?? true;
              _adminMessage = data['admin_messages_enabled'] ?? true;
            });
          }
        },
      );
    } catch (e) {
      debugPrint("Error fetching notification preferences exception: \$e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _updatePreferences() async {
    try {
      final response = await DioManager.apiRequest(
        url: ApiService.updateNotificationPreferences,
        method: Methods.put,
        body: {
          "new_auction_enabled": _newAuction,
          "auction_updates_enabled": _auctionUpdate,
          "admin_messages_enabled": _adminMessage,
        },
      );
      response.fold(
        (error) => debugPrint("Error updating notification preferences: \$error"),
        (data) => debugPrint("Notification preferences updated"),
      );
    } catch (e) {
      debugPrint("Error updating notification preferences exception: \$e");
    }
  }

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
      child: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.sceTeal))
          : SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
              child: Column(
                children: [
                  NotificationSettingTile(
                    title: "New Auction",
                    subtitle: "Get notify when new auction is posted",
                    value: _newAuction,
                    onChanged: (val) {
                      setState(() => _newAuction = val);
                      _updatePreferences();
                    },
                  ),
                  NotificationSettingTile(
                    title: "Auction Update",
                    subtitle: "Get notify when auction update",
                    value: _auctionUpdate,
                    onChanged: (val) {
                      setState(() => _auctionUpdate = val);
                      _updatePreferences();
                    },
                  ),
                  NotificationSettingTile(
                    title: "General Notification",
                    subtitle: "Get notify for general purpose",
                    value: _general,
                    onChanged: (val) {
                      setState(() => _general = val);
                      if (val) {
                        FirebaseService.initFirebaseMessaging();
                      } else {
                        FirebaseService.unregisterFirebaseMessaging();
                      }
                    },
                  ),
                  NotificationSettingTile(
                    title: "Admin Message",
                    subtitle: "Get notify for message from admin",
                    value: _adminMessage,
                    onChanged: (val) {
                      setState(() => _adminMessage = val);
                      _updatePreferences();
                    },
                  ),
                ],
              ),
            ),
    );
  }
}