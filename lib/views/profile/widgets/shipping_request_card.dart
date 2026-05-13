import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rionydo/app_utils/constants/font_manager.dart';
import 'package:rionydo/app_utils/utils/app_colors.dart';
import 'package:rionydo/models/profile/my_shipping_request_response.dart';

class ShippingRequestCard extends StatelessWidget {
  const ShippingRequestCard({super.key, required this.item});

  final ShippingResult item;

  @override
  Widget build(BuildContext context) {
    final cfg = _statusConfig(item.status);

    return Container(
      margin: EdgeInsets.only(bottom: 14.h),
      decoration: BoxDecoration(
        color: AppColors.sceCardBg,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header strip ──
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: cfg.stripColor.withValues(alpha: 0.08),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.r),
                topRight: Radius.circular(16.r),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.local_shipping_rounded,
                  color: cfg.stripColor,
                  size: 16.sp,
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    item.auctionTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: FontManager.bodyMedium(
                      color: Colors.white,
                    ).copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
                SizedBox(width: 8.w),
                // Status pill
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: cfg.pillBg,
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(color: cfg.pillBorder),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6.w,
                        height: 6.w,
                        decoration: BoxDecoration(
                          color: cfg.stripColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 5.w),
                      Text(
                        cfg.label,
                        style: FontManager.labelMedium(
                          color: cfg.stripColor,
                        ).copyWith(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── Body ──
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            child: Column(
              children:
                  [
                        if (item.buyer.fullName.isNotEmpty)
                          _InfoRow(
                            icon: Icons.person_outline_rounded,
                            label: "Buyer",
                            value: item.buyer.fullName,
                          ),
                        if (item.buyer.company.isNotEmpty)
                          _InfoRow(
                            icon: Icons.business_outlined,
                            label: "Company",
                            value: item.buyer.company,
                          ),
                        if (item.buyer.email.isNotEmpty)
                          _InfoRow(
                            icon: Icons.email_outlined,
                            label: "Email",
                            value: item.buyer.email,
                          ),
                        if (item.buyer.phone.isNotEmpty)
                          _InfoRow(
                            icon: Icons.phone_outlined,
                            label: "Phone",
                            value: item.buyer.phone,
                          ),
                        if (item.buyer.address.isNotEmpty)
                          _InfoRow(
                            icon: Icons.location_on_outlined,
                            label: "Address",
                            value: item.buyer.address,
                            maxLines: 2,
                          ),
                        _InfoRow(
                          icon: Icons.account_balance_wallet_outlined,
                          label: "Amount",
                          value: "CHF ${item.amount}",
                          valueColor: AppColors.sceGold,
                          bold: true,
                        ),
                        _InfoRow(
                          icon: _methodIcon(item.shippingMethod),
                          label: "Method",
                          value: _formatMethod(item.shippingMethod),
                        ),
                        _InfoRow(
                          icon: Icons.calendar_today_outlined,
                          label: "Requested",
                          value: _formatDate(item.createdAt.toLocal()),
                        ),
                      ]
                      .expand((widget) => [widget, SizedBox(height: 10.h)])
                      .toList()
                    ..removeLast(),
            ),
          ),
        ],
      ),
    );
  }

  String _formatMethod(String raw) {
    switch (raw) {
      case 'local_pickup':
        return 'Local Pickup';
      case 'dealer_delivery':
        return 'Dealer Delivery';
      case 'third_party':
        return 'Third-Party Logistics';
      default:
        return raw
            .replaceAll('_', ' ')
            .split(' ')
            .map(
              (w) =>
                  w.isNotEmpty ? '${w[0].toUpperCase()}${w.substring(1)}' : '',
            )
            .join(' ');
    }
  }

  static String _formatDate(DateTime dt) {
    final months = const [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final d = dt.day.toString().padLeft(2, '0');
    final m = months[dt.month - 1];
    final y = dt.year;
    final h = dt.hour.toString().padLeft(2, '0');
    final min = dt.minute.toString().padLeft(2, '0');
    return '$d $m $y, $h:$min';
  }

  IconData _methodIcon(String method) {
    switch (method) {
      case 'local_pickup':
        return Icons.store_outlined;
      case 'dealer_delivery':
        return Icons.directions_car_outlined;
      case 'third_party':
        return Icons.inventory_2_outlined;
      default:
        return Icons.local_shipping_outlined;
    }
  }

  ShippingStatusConfig _statusConfig(String status) {
    switch (status) {
      case 'shipping_pending':
        return ShippingStatusConfig(
          label: "Pending",
          stripColor: AppColors.sceRegistrationGold,
          pillBg: AppColors.sceRegistrationGold.withValues(alpha: 0.1),
          pillBorder: AppColors.sceRegistrationGold.withValues(alpha: 0.3),
        );
      case 'completed':
        return ShippingStatusConfig(
          label: "Completed",
          stripColor: AppColors.sceTeal,
          pillBg: AppColors.sceTeal.withValues(alpha: 0.1),
          pillBorder: AppColors.sceTeal.withValues(alpha: 0.3),
        );
      case 'cancelled':
        return ShippingStatusConfig(
          label: "Cancelled",
          stripColor: AppColors.errorRed,
          pillBg: AppColors.errorRed.withValues(alpha: 0.1),
          pillBorder: AppColors.errorRed.withValues(alpha: 0.3),
        );
      default:
        return ShippingStatusConfig(
          label: status
              .replaceAll('_', ' ')
              .split(' ')
              .map(
                (w) => w.isNotEmpty
                    ? '${w[0].toUpperCase()}${w.substring(1)}'
                    : '',
              )
              .join(' '),
          stripColor: AppColors.sceGreyA0,
          pillBg: AppColors.sceGreyA0.withValues(alpha: 0.1),
          pillBorder: AppColors.sceGreyA0.withValues(alpha: 0.3),
        );
    }
  }
}

class ShippingStatusConfig {
  final String label;
  final Color stripColor;
  final Color pillBg;
  final Color pillBorder;

  const ShippingStatusConfig({
    required this.label,
    required this.stripColor,
    required this.pillBg,
    required this.pillBorder,
  });
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
    this.bold = false,
    this.maxLines = 1,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;
  final bool bold;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, size: 14.sp, color: AppColors.sceGreyA0),
        SizedBox(width: 8.w),
        Text(
          "$label: ",
          style: FontManager.labelMedium(color: AppColors.sceGreyA0),
        ),
        Expanded(
          child: Text(
            value,
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis,
            style: FontManager.labelMedium(
              color: valueColor ?? Colors.white,
            ).copyWith(fontWeight: bold ? FontWeight.w700 : FontWeight.w500),
          ),
        ),
      ],
    );
  }
}
