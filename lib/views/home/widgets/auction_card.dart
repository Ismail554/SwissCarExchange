import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rionydo/app_utils/utils/app_colors.dart';
import 'package:rionydo/app_utils/utils/app_spacing.dart';
import 'package:rionydo/app_utils/constants/font_manager.dart';
import 'package:rionydo/core/widgets/custom_button.dart';

class AuctionCard extends StatelessWidget {
  final String title;
  final String lotNo;
  final String currentBid;
  final bool isLive;
  final String? badge;
  final Map<String, String>? countdown;
  final String? desc;
  final String? timeMeta;
  final String? userCount;
  final String imageUrl;

  const AuctionCard({
    super.key,
    required this.title,
    required this.lotNo,
    required this.currentBid,
    required this.isLive,
    this.badge,
    this.countdown,
    this.desc,
    this.timeMeta,
    this.userCount,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final Color teal = AppColors.sceTeal;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.sceCardBg,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Product Image ───────────────────────────────────────────
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
                child: Image.network(
                  imageUrl,
                  height: 180.h,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 12.h,
                right: 12.w,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: Colors.white12),
                  ),
                  child: Text(
                    lotNo,
                    style: FontManager.labelSmall(
                      color: Colors.white,
                      fontSize: 10.sp,
                    ),
                  ),
                ),
              ),
              if (badge != null)
                Positioned(
                  top: 12.h,
                  left: 12.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.error,
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.circle, color: Colors.white, size: 6),
                        SizedBox(width: 4.w),
                        Text(
                          badge!,
                          style: FontManager.labelSmall(
                            color: Colors.white,
                            fontSize: 10.sp,
                          ).copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),

          // ── Card Body ───────────────────────────────────────────────
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: FontManager.heading4(
                        color: Colors.white,
                        fontSize: 16.sp,
                      ).copyWith(fontWeight: FontWeight.bold),
                    ),
                    const Icon(
                      Icons.info_outline,
                      color: Colors.white60,
                      size: 18,
                    ),
                  ],
                ),
                Text(
                  isLive ? 'Current Bid' : 'Lot Bid',
                  style: FontManager.bodySmall(
                    color: Colors.white38,
                    fontSize: 12.sp,
                  ),
                ),
                AppSpacing.h8,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      currentBid,
                      style: FontManager.heading2(
                        color: teal,
                        fontSize: 22.sp,
                      ).copyWith(fontWeight: FontWeight.w800),
                    ),
                    if (isLive)
                      Row(
                        children: [
                          Icon(
                            Icons.people_alt_outlined,
                            color: Colors.white38,
                            size: 14.sp,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            '24 Bids',
                            style: FontManager.bodySmall(
                              color: Colors.white38,
                              fontSize: 11.sp,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
                AppSpacing.h16,

                // ── Dynamic Row (Countdown or Meta Details) ───────────────
                if (isLive && countdown != null)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _TimerBlock(label: 'HRS', value: countdown!['hrs']!),
                      _Separator(),
                      _TimerBlock(label: 'MIN', value: countdown!['min']!),
                      _Separator(),
                      _TimerBlock(label: 'SEC', value: countdown!['sec']!),
                    ],
                  ),
                if (!isLive) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        desc ?? '',
                        style: FontManager.bodySmall(
                          color: Colors.white60,
                          fontSize: 13.sp,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.timer_outlined,
                            color: Colors.white38,
                            size: 14.sp,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            timeMeta ?? '',
                            style: FontManager.bodySmall(
                              color: Colors.white38,
                              fontSize: 11.sp,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(
                        Icons.people_alt_outlined,
                        color: Colors.white38,
                        size: 14.sp,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        '${userCount ?? "0"} Bids',
                        style: FontManager.bodySmall(
                          color: Colors.white38,
                          fontSize: 11.sp,
                        ),
                      ),
                    ],
                  ),
                ],

                AppSpacing.h20,

                // ── Place Bid Button ──────────────────────────────────────
                CustomButton(
                  text: 'PLACE BID',
                  onPressed: () {},
                  isPrimary: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TimerBlock extends StatelessWidget {
  final String label;
  final String value;
  const _TimerBlock({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70.w,
      padding: EdgeInsets.symmetric(vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: FontManager.labelSmall(
              color: Colors.white30,
              fontSize: 8.sp,
            ).copyWith(fontWeight: FontWeight.bold),
          ),
          Text(
            value,
            style: FontManager.heading3(
              color: Colors.white,
              fontSize: 18.sp,
            ).copyWith(fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}

class _Separator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      ':',
      style: FontManager.heading3(
        color: Colors.white24,
        fontSize: 18.sp,
      ).copyWith(fontWeight: FontWeight.bold),
    );
  }
}
