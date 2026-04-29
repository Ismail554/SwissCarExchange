import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rionydo/app_utils/constants/font_manager.dart';
import 'package:rionydo/app_utils/utils/app_colors.dart';
import 'package:rionydo/app_utils/utils/app_spacing.dart';
import 'package:rionydo/core/widgets/common_background.dart';
import 'package:rionydo/core/widgets/custom_back_button.dart';

/// Notification type determines the icon and accent color.
enum NotificationType {
  auctionWon,
  outbid,
  endingSoon,
  bidConfirmed,
  paymentReminder,
}

class _NotificationItem {
  final NotificationType type;
  final String title;
  final String body;
  final String timeAgo;
  bool isUnread;
  final bool hasViewDetails;

  _NotificationItem({
    required this.type,
    required this.title,
    required this.body,
    required this.timeAgo,
    this.isUnread = false,
    this.hasViewDetails = false,
  });
}

class NotificationView extends StatefulWidget {
  const NotificationView({super.key});

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  late final List<_NotificationItem> _notifications;

  @override
  void initState() {
    super.initState();
    _notifications = [
      _NotificationItem(
        type: NotificationType.auctionWon,
        title: "Auction Won!",
        body: "Congratulations! You won the Porsche 911 GT3 auction.",
        timeAgo: "5 min ago",
        isUnread: true,
      ),
      _NotificationItem(
        type: NotificationType.outbid,
        title: "You've been outbid",
        body: "Someone placed a higher bid on Mercedes-Benz AMG GT.",
        timeAgo: "1 hour ago",
        isUnread: true,
      ),
      _NotificationItem(
        type: NotificationType.endingSoon,
        title: "Auction Ending Soon",
        body: "Audi RS6 Avant auction ends in 2 hours.",
        timeAgo: "2 hours ago",
      ),
      _NotificationItem(
        type: NotificationType.bidConfirmed,
        title: "Bid Confirmed",
        body: "Your bid of CHF 125,000 was placed successfully.",
        timeAgo: "5 hours ago",
      ),
      _NotificationItem(
        type: NotificationType.paymentReminder,
        title: "Payment Reminder",
        body: "Payment for Porsche Cayenne is due in 24 hours.",
        timeAgo: "1 day ago",
      ),
    ];
  }

  int get _unreadCount => _notifications.where((n) => n.isUnread).length;

  void _markAllRead() {
    setState(() {
      for (final n in _notifications) {
        n.isUnread = false;
      }
    });
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
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        itemCount: _notifications.length,
        separatorBuilder: (_, __) => AppSpacing.h12,
        itemBuilder: (context, index) {
          return _NotificationCard(item: _notifications[index]);
        },
      ),
    );
  }
}

// ─────────────────── Notification Card ───────────────────

class _NotificationCard extends StatelessWidget {
  final _NotificationItem item;
  const _NotificationCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final config = _getTypeConfig(item.type);

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.sceCardBg,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: item.isUnread
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
                    if (item.isUnread)
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item.timeAgo,
                      style: FontManager.bodySmall(
                        color: AppColors.sceGrey99,
                      ).copyWith(fontSize: 11.sp),
                    ),
                    if (item.hasViewDetails)
                      GestureDetector(
                        onTap: () {
                          // Navigate to relevant detail screen
                        },
                        child: Text(
                          "View Details",
                          style: FontManager.bodySmall(color: AppColors.sceTeal)
                              .copyWith(
                                fontWeight: FontWeight.w600,
                                fontSize: 12.sp,
                              ),
                        ),
                      ),
                  ],
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

_TypeConfig _getTypeConfig(NotificationType type) {
  switch (type) {
    case NotificationType.auctionWon:
      return const _TypeConfig(
        icon: Icons.emoji_events_outlined,
        color: AppColors.sceTeal,
      );
    case NotificationType.outbid:
      return const _TypeConfig(
        icon: Icons.trending_up_rounded,
        color: AppColors.errorRed,
      );
    case NotificationType.endingSoon:
      return const _TypeConfig(
        icon: Icons.access_time_rounded,
        color: AppColors.sceGold,
      );
    case NotificationType.bidConfirmed:
      return const _TypeConfig(
        icon: Icons.trending_up_rounded,
        color: AppColors.sceTeal,
      );
    case NotificationType.paymentReminder:
      return const _TypeConfig(
        icon: Icons.notifications_active_outlined,
        color: AppColors.sceGrey99,
      );
  }
}
