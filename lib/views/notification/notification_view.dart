import 'package:flutter/material.dart';
import 'package:rionydo/services/firebase_service.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rionydo/app_utils/constants/font_manager.dart';
import 'package:rionydo/app_utils/utils/app_colors.dart';
import 'package:rionydo/app_utils/utils/app_spacing.dart';
import 'package:rionydo/core/widgets/common_background.dart';
import 'package:rionydo/core/widgets/custom_back_button.dart';
import 'package:rionydo/app_utils/constants/api_service.dart';
import 'package:rionydo/app_utils/network/dio_manager.dart';
import 'package:rionydo/app_utils/network/enums.dart';
import 'package:rionydo/models/notification/notification_response.dart';

class NotificationView extends StatefulWidget {
  const NotificationView({super.key});

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  List<NotificationItem> _notifications = [];
  int _unreadCount = 0;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    // FirebaseService.initFirebaseMessaging();
    _fetchNotifications();
    _fetchUnreadCount();
  }

  Future<void> _fetchNotifications() async {
    try {
      final response = await DioManager.apiRequest(
        url: ApiService.notifications,
        method: Methods.get,
      );
      response.fold(
        (error) {
          if (mounted) {
            setState(() {
              _isLoading = false;
              _errorMessage = "Failed to load notifications";
            });
          }
        },
        (data) {
          if (data != null && mounted) {
            final parsed = NotificationResponse.fromJson(data);
            setState(() {
              _notifications = parsed.results;
              _isLoading = false;
            });
          }
        },
      );
    } catch (e) {
      debugPrint("Error fetching notifications: $e");
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = "Something went wrong";
        });
      }
    }
  }

  Future<void> _fetchUnreadCount() async {
    try {
      final response = await DioManager.apiRequest(
        url: ApiService.notificationCount,
        method: Methods.get,
      );
      response.fold((error) => null, (data) {
        if (data != null && data['unread_count'] != null) {
          if (mounted) {
            setState(() {
              _unreadCount = data['unread_count'];
            });
          }
        }
      });
    } catch (e) {
      debugPrint("Error fetching unread count: $e");
    }
  }

  Future<void> _markAllRead() async {
    setState(() {
      _unreadCount = 0;
    });
    try {
      await DioManager.apiRequest(
        url: ApiService.readAllNotifications,
        method: Methods.post,
      );
    } catch (e) {
      debugPrint("Error marking all read: $e");
    }
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inSeconds < 60) return '${diff.inSeconds}s ago';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${(diff.inDays / 7).floor()}w ago';
  }

  @override
  Widget build(BuildContext context) {
    return CommonBackground(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const CustomBackButton(),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Notifications",
              style: FontManager.titleText(color: AppColors.white),
            ),
            if (_unreadCount > 0)
              Text(
                "$_unreadCount unread",
                style: FontManager.bodySmall(color: AppColors.sceGrey99),
              ),
          ],
        ),
        actions: [
          if (_unreadCount > 0)
            TextButton(
              onPressed: _markAllRead,
              child: Text(
                "Mark all read",
                style: FontManager.bodySmall(
                  color: AppColors.sceTeal,
                ).copyWith(fontWeight: FontWeight.w600),
              ),
            ),
        ],
      ),
      child: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.sceTeal),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: AppColors.sceGrey99, size: 48.sp),
            AppSpacing.h12,
            Text(
              _errorMessage!,
              style: FontManager.bodyMedium(color: AppColors.sceGrey99),
            ),
            AppSpacing.h12,
            TextButton(
              onPressed: () {
                setState(() {
                  _isLoading = true;
                  _errorMessage = null;
                });
                _fetchNotifications();
              },
              child: Text(
                "Retry",
                style: FontManager.bodyMedium(color: AppColors.sceTeal),
              ),
            ),
          ],
        ),
      );
    }

    if (_notifications.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_off_outlined,
              color: AppColors.sceGrey99,
              size: 48.sp,
            ),
            AppSpacing.h12,
            Text(
              "No notifications yet",
              style: FontManager.bodyMedium(color: AppColors.sceGrey99),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      itemCount: _notifications.length,
      separatorBuilder: (_, __) => AppSpacing.h12,
      itemBuilder: (context, index) {
        return _NotificationCard(
          item: _notifications[index],
          timeAgo: _timeAgo(_notifications[index].createdAt),
        );
      },
    );
  }
}

// ─────────────────── Notification Card ───────────────────

class _NotificationCard extends StatelessWidget {
  final NotificationItem item;
  final String timeAgo;
  const _NotificationCard({required this.item, required this.timeAgo});

  @override
  Widget build(BuildContext context) {
    final config = _getTypeConfig(item.notificationType);
    final bool isUnread = item.readAt == null;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.sceCardBg,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isUnread
              ? AppColors.sceTeal.withOpacity(0.15)
              : Colors.white.withOpacity(0.05),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// ICON
          Container(
            height: 44.w,
            width: 44.w,
            decoration: BoxDecoration(
              color: config.color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(config.icon, color: config.color, size: 22.sp),
          ),
          AppSpacing.w12,

          /// CONTENT
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.title,
                        style: FontManager.bodyMedium(
                          color: AppColors.white,
                        ).copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                    if (isUnread)
                      Container(
                        height: 10.w,
                        width: 10.w,
                        decoration: const BoxDecoration(
                          color: AppColors.sceTeal,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
                AppSpacing.h4,
                Text(
                  item.body,
                  style: FontManager.bodySmall(
                    color: AppColors.sceGrey99,
                  ).copyWith(height: 1.4),
                ),
                AppSpacing.h8,
                Text(
                  timeAgo,
                  style: FontManager.bodySmall(
                    color: AppColors.sceGrey99,
                  ).copyWith(fontSize: 11.sp),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────── Type Config ───────────────────

class _TypeConfig {
  final IconData icon;
  final Color color;
  const _TypeConfig({required this.icon, required this.color});
}

_TypeConfig _getTypeConfig(String notificationType) {
  switch (notificationType) {
    case 'auction_won':
      return const _TypeConfig(
        icon: Icons.emoji_events_outlined,
        color: AppColors.sceTeal,
      );
    case 'outbid':
      return const _TypeConfig(
        icon: Icons.trending_up_rounded,
        color: AppColors.errorRed,
      );
    case 'ending_soon':
      return const _TypeConfig(
        icon: Icons.access_time_rounded,
        color: Color(0xFFD4A843),
      );
    case 'bid_confirmed':
      return const _TypeConfig(
        icon: Icons.check_circle_outline,
        color: AppColors.sceTeal,
      );
    case 'payment_reminder':
      return const _TypeConfig(
        icon: Icons.payment_outlined,
        color: Color(0xFFD4A843),
      );
    case 'new_auction':
      return const _TypeConfig(
        icon: Icons.local_offer_outlined,
        color: AppColors.sceTeal,
      );
    case 'auction_update':
      return const _TypeConfig(
        icon: Icons.update_outlined,
        color: Color(0xFF64B5F6),
      );
    case 'admin_message':
      return const _TypeConfig(
        icon: Icons.admin_panel_settings_outlined,
        color: AppColors.sceGrey99,
      );
    default:
      return const _TypeConfig(
        icon: Icons.notifications_none_rounded,
        color: AppColors.sceGrey99,
      );
  }
}
