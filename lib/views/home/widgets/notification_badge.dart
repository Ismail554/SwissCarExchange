import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rionydo/app_utils/utils/app_colors.dart';
import 'package:rionydo/views/notification/notification_view.dart';
import 'package:rionydo/app_utils/constants/api_service.dart';
import 'package:rionydo/app_utils/network/dio_manager.dart';
import 'package:rionydo/app_utils/network/enums.dart';

class NotificationBadge extends StatefulWidget {
  const NotificationBadge({super.key});

  @override
  State<NotificationBadge> createState() => _NotificationBadgeState();
}

class _NotificationBadgeState extends State<NotificationBadge> {
  int _unreadCount = 0;

  @override
  void initState() {
    super.initState();
    _fetchUnreadCount();
  }

  Future<void> _fetchUnreadCount() async {
    try {
      final response = await DioManager.apiRequest(
        url: ApiService.notificationCount,
        method: Methods.get,
      );
      response.fold(
        (error) => null,
        (data) {
          if (data != null && data['unread_count'] != null) {
            if (mounted) {
              setState(() {
                _unreadCount = data['unread_count'];
              });
            }
          }
        },
      );
    } catch (e) {
      debugPrint("Error fetching unread count: \$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const NotificationView()),
        );
        _fetchUnreadCount();
      },
      child: Container(
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: AppColors.sceCardBg,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white12),
        ),
        child: Stack(
          children: [
            Icon(
              Icons.notifications_none_rounded,
              color: Colors.white70,
              size: 22.sp,
            ),
            if (_unreadCount > 0)
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  constraints: BoxConstraints(minWidth: 8.w, minHeight: 8.w),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
