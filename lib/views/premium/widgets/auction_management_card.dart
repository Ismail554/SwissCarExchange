import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rionydo/app_utils/constants/font_manager.dart';
import 'package:rionydo/app_utils/utils/app_colors.dart';

class AuctionManagementCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String status;
  final String subStatus;
  final int views;
  final int bids;
  final int bidders;
  final double currentBid;
  final double reservePrice;
  final bool isReserveMet;
  final String timeLeft;
  final VoidCallback onViewDetails;
  final VoidCallback onMenuTap;

  const AuctionManagementCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.status,
    required this.subStatus,
    required this.views,
    required this.bids,
    required this.bidders,
    required this.currentBid,
    required this.reservePrice,
    required this.isReserveMet,
    required this.timeLeft,
    required this.onViewDetails,
    required this.onMenuTap,
  });

  // ── Helpers ──────────────────────────────────────────────────────────────

  Color get _subStatusColor => subStatus.toUpperCase() == 'LIVE'
      ? AppColors.errorRed.withValues(alpha: 0.85)
      : Colors.blue.withValues(alpha: 0.85);

  bool get _isSold => status.toLowerCase() == 'unsold';

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.h),
      decoration: BoxDecoration(
        color: AppColors.sceCardBg,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.07)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _ImageSection(
            imageUrl: imageUrl,
            status: status,
            subStatus: subStatus,
            subStatusColor: _subStatusColor,
            onMenuTap: onMenuTap,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 14.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // ── Title ──
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: FontManager.heading3(
                    color: Colors.white,
                  ).copyWith(fontSize: 16.sp, height: 1.3),
                ),
                SizedBox(height: 14.h),

                // ── Stats ──
                _StatsRow(views: views, bids: bids, bidders: bidders),
                SizedBox(height: 14.h),

                // ── Divider ──
                Divider(color: Colors.white.withValues(alpha: 0.06), height: 1),
                SizedBox(height: 14.h),

                // ── Price Row ──
                _PriceRow(currentBid: currentBid, reservePrice: reservePrice),
                SizedBox(height: 10.h),

                // ── Reserve Met Pill ──
                if (isReserveMet) ...[
                  _ReserveMetPill(),
                  SizedBox(height: 10.h),
                ] else ...[
                  _ReserveNotMetPill(),
                  SizedBox(height: 10.h),
                ],

                // ── Divider ──
                Divider(color: Colors.white.withValues(alpha: 0.06), height: 1),
                SizedBox(height: 12.h),

                // ── Footer ──
                _Footer(timeLeft: timeLeft, onViewDetails: onViewDetails),

                // ── Sold Actions ──
                if (_isSold) ...[SizedBox(height: 12.h), _SoldActions()],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Image Section ──────────────────────────────────────────────────────────

class _ImageSection extends StatelessWidget {
  final String imageUrl;
  final String status;
  final String subStatus;
  final Color subStatusColor;
  final VoidCallback onMenuTap;

  const _ImageSection({
    required this.imageUrl,
    required this.status,
    required this.subStatus,
    required this.subStatusColor,
    required this.onMenuTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
          child: Image.network(
            imageUrl,
            height: 170.h,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => Container(
              height: 170.h,
              color: Colors.white.withValues(alpha: 0.04),
              child: Center(
                child: Icon(
                  Icons.image_not_supported_outlined,
                  color: Colors.white24,
                  size: 36.sp,
                ),
              ),
            ),
          ),
        ),

        // Gradient overlay for better badge readability
        Positioned.fill(
          child: ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.center,
                  colors: [Colors.black.withValues(alpha: 0.45), Colors.transparent],
                ),
              ),
            ),
          ),
        ),

        // Badges — constrained to avoid overflow
        Positioned(
          top: 10.h,
          left: 10.w,
          right: 50.w, // leave room for the menu icon
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _Badge(text: status, color: AppColors.sceTeal),
              SizedBox(width: 6.w),
              _Badge(text: subStatus, color: subStatusColor),
            ],
          ),
        ),

        // Menu icon
        Positioned(
          top: 10.h,
          right: 10.w,
          child: GestureDetector(
            onTap: onMenuTap,
            behavior: HitTestBehavior.opaque,
            child: Container(
              padding: EdgeInsets.all(6.r),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(
                Icons.more_vert_rounded,
                color: Colors.white,
                size: 18.sp,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Badge ──────────────────────────────────────────────────────────────────

class _Badge extends StatelessWidget {
  final String text;
  final Color color;

  const _Badge({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Text(
        text.toUpperCase(),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: Colors.white,
          fontSize: 10.sp,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.6,
        ),
      ),
    );
  }
}

// ── Stats Row ──────────────────────────────────────────────────────────────

class _StatsRow extends StatelessWidget {
  final int views;
  final int bids;
  final int bidders;

  const _StatsRow({
    required this.views,
    required this.bids,
    required this.bidders,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StatChip(
          label: 'Views',
          value: _formatCount(views),
          icon: Icons.visibility_outlined,
          iconColor: Colors.cyanAccent,
        ),
        SizedBox(width: 8.w),
        _StatChip(
          label: 'Bids',
          value: _formatCount(bids),
          icon: Icons.trending_up_rounded,
          iconColor: AppColors.sceTeal,
        ),
        SizedBox(width: 8.w),
        _StatChip(
          label: 'Bidders',
          value: _formatCount(bidders),
          icon: Icons.group_outlined,
          iconColor: Colors.orangeAccent,
        ),
      ],
    );
  }

  String _formatCount(int n) =>
      n >= 1000 ? '${(n / 1000).toStringAsFixed(1)}k' : '$n';
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color iconColor;

  const _StatChip({
    required this.label,
    required this.value,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 9.h, horizontal: 6.w),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: iconColor, size: 14.sp),
            SizedBox(height: 4.h),
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: FontManager.labelMedium(
                color: Colors.white,
              ).copyWith(fontWeight: FontWeight.w700, fontSize: 13.sp),
            ),
            SizedBox(height: 2.h),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: FontManager.labelSmall(
                color: AppColors.sceGreyA0,
              ).copyWith(fontSize: 9.sp),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Price Row ──────────────────────────────────────────────────────────────

class _PriceRow extends StatelessWidget {
  final double currentBid;
  final double reservePrice;

  const _PriceRow({required this.currentBid, required this.reservePrice});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Current Bid', style: FontManager.hintText()),
              SizedBox(height: 2.h),
              Text(
                'CHF ${_fmt(currentBid)}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: FontManager.titleText(
                  color: AppColors.sceTeal,
                ).copyWith(fontSize: 17.sp, fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
        SizedBox(width: 12.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Reserve', style: FontManager.hintText()),
            SizedBox(height: 2.h),
            Text(
              'CHF ${_fmt(reservePrice)}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: FontManager.bodyMedium(
                color: Colors.white,
              ).copyWith(fontWeight: FontWeight.w600, fontSize: 14.sp),
            ),
          ],
        ),
      ],
    );
  }

  String _fmt(double v) => v >= 1000
      ? v
            .toStringAsFixed(0)
            .replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => "'")
      : v.toStringAsFixed(0);
}

// ── Reserve Met Pill ───────────────────────────────────────────────────────

class _ReserveMetPill extends StatelessWidget {
  const _ReserveMetPill();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 7.h, horizontal: 12.w),
      decoration: BoxDecoration(
        color: AppColors.sceTeal.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.sceTeal.withValues(alpha: 0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.verified_rounded, color: AppColors.sceTeal, size: 13.sp),
          SizedBox(width: 6.w),
          Flexible(
            child: Text(
              'Reserve Price Met',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: FontManager.labelSmall(
                color: AppColors.sceTeal,
              ).copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Reserve Not Met Pill ───────────────────────────────────────────────────

class _ReserveNotMetPill extends StatelessWidget {
  const _ReserveNotMetPill();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(vertical: 7.h, horizontal: 12.w),
      decoration: BoxDecoration(
        color: AppColors.errorRed.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.errorRed.withValues(alpha: 0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.error_outline_rounded,
            color: AppColors.errorRed,
            size: 13.sp,
          ),
          SizedBox(width: 6.w),
          Flexible(
            child: Text(
              'Under the reserve price',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: FontManager.labelSmall(
                color: AppColors.errorRed,
              ).copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Footer ─────────────────────────────────────────────────────────────────

class _Footer extends StatelessWidget {
  final String timeLeft;
  final VoidCallback onViewDetails;

  const _Footer({required this.timeLeft, required this.onViewDetails});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Time left with clock icon
        Icon(Icons.schedule_rounded, color: AppColors.sceGreyA0, size: 13.sp),
        SizedBox(width: 4.w),
        Expanded(
          child: Text(
            timeLeft,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: FontManager.hintText(),
          ),
        ),
        SizedBox(width: 8.w),
        // View Details button
        GestureDetector(
          onTap: onViewDetails,
          behavior: HitTestBehavior.opaque,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'View Details',
                style: FontManager.labelMedium(
                  color: AppColors.sceTeal,
                ).copyWith(fontSize: 12.sp),
              ),
              SizedBox(width: 3.w),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: AppColors.sceTeal,
                size: 11.sp,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Sold Actions ───────────────────────────────────────────────────────────

class _SoldActions extends StatelessWidget {
  const _SoldActions();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.all(2.r),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: AppColors.sceTeal.withValues(alpha: 0.5)),
            ),
            child: Text(
              'Sold',
              textAlign: TextAlign.center,
              style: FontManager.labelMedium(color: AppColors.sceTeal),
            ),
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Container(
            padding: EdgeInsets.all(2.r),
            decoration: BoxDecoration(
              color: AppColors.errorRed.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: AppColors.errorRed.withValues(alpha: 0.5)),
            ),
            child: Text(
              'Withdraw',
              textAlign: TextAlign.center,
              style: FontManager.labelMedium(color: AppColors.errorRed),
            ),
          ),
        ),
      ],
    );
  }
}
