import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rionydo/app_utils/utils/app_colors.dart';
import 'package:rionydo/app_utils/constants/font_manager.dart';

class AuctionCountdown extends StatefulWidget {
  final DateTime? endTime;
  final TextStyle? labelStyle;
  final TextStyle? valueStyle;
  final bool showDays;

  const AuctionCountdown({
    super.key,
    required this.endTime,
    this.labelStyle,
    this.valueStyle,
    this.showDays = true,
  });

  @override
  State<AuctionCountdown> createState() => _AuctionCountdownState();
}

class _AuctionCountdownState extends State<AuctionCountdown> {
  Timer? _timer;
  Duration _timeLeft = Duration.zero;

  bool get _isEnded =>
      widget.endTime != null && DateTime.now().isAfter(widget.endTime!);

  @override
  void initState() {
    super.initState();
    _calculateTimeLeft();
    _startTimer();
  }

  @override
  void didUpdateWidget(AuctionCountdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.endTime != widget.endTime) {
      _calculateTimeLeft();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) _calculateTimeLeft();
    });
  }

  void _calculateTimeLeft() {
    if (widget.endTime == null) {
      setState(() => _timeLeft = Duration.zero);
      return;
    }
    final diff = widget.endTime!.difference(DateTime.now());
    setState(() => _timeLeft = diff.isNegative ? Duration.zero : diff);
  }

  @override
  Widget build(BuildContext context) {
    // ── Ended state ──
    if (_isEnded) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: AppColors.errorRed.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: AppColors.errorRed.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.timer_off_rounded,
              color: AppColors.errorRed,
              size: 13.sp,
            ),
            SizedBox(width: 5.w),
            Text(
              'AUCTION ENDED',
              style:
                  widget.valueStyle ??
                  FontManager.labelSmall(
                    color: AppColors.errorRed,
                  ).copyWith(fontWeight: FontWeight.w700, fontSize: 11.sp),
            ),
          ],
        ),
      );
    }

    final days = _timeLeft.inDays;
    final showDays = widget.showDays || days > 0;
    final hours = showDays ? _timeLeft.inHours % 24 : _timeLeft.inHours;
    final minutes = _timeLeft.inMinutes % 60;
    final seconds = _timeLeft.inSeconds % 60;

    // Urgency: under 1 hour remaining
    final isUrgent = _timeLeft.inSeconds > 0 && _timeLeft.inHours < 1;

    return LayoutBuilder(
      builder: (context, constraints) {
        // Shrink segment width if space is tight
        final availableWidth = constraints.maxWidth;
        final segmentCount = showDays && days > 0 ? 4 : 3;
        // Each segment + separators. Separator ~16.w each (padding 6 * 2 + colon width ~4)
        final separatorCount = segmentCount - 1;
        final usableWidth = availableWidth - (separatorCount * 20.w);
        final segmentWidth = (usableWidth / segmentCount).clamp(40.0, 65.0);

        return Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (showDays && days > 0) ...[
              _TimeSegment(
                value: _pad(days),
                label: 'DAYS',
                width: segmentWidth.w,
                isUrgent: isUrgent,
                valueStyle: widget.valueStyle,
                labelStyle: widget.labelStyle,
              ),
              _Separator(isUrgent: isUrgent),
            ],
            _TimeSegment(
              value: _pad(hours),
              label: 'HRS',
              width: segmentWidth.w,
              isUrgent: isUrgent,
              valueStyle: widget.valueStyle,
              labelStyle: widget.labelStyle,
            ),
            _Separator(isUrgent: isUrgent),
            _TimeSegment(
              value: _pad(minutes),
              label: 'MIN',
              width: segmentWidth.w,
              isUrgent: isUrgent,
              valueStyle: widget.valueStyle,
              labelStyle: widget.labelStyle,
            ),
            _Separator(isUrgent: isUrgent),
            _TimeSegment(
              value: _pad(seconds),
              label: 'SEC',
              width: segmentWidth.w,
              isUrgent: isUrgent,
              valueStyle: widget.valueStyle,
              labelStyle: widget.labelStyle,
            ),
          ],
        );
      },
    );
  }

  String _pad(int n) => n.toString().padLeft(2, '0');
}

// ── Time Segment ─────────────────────────────────────────────────────────────

class _TimeSegment extends StatelessWidget {
  final String value;
  final String label;
  final double width;
  final bool isUrgent;
  final TextStyle? valueStyle;
  final TextStyle? labelStyle;

  const _TimeSegment({
    required this.value,
    required this.label,
    required this.width,
    required this.isUrgent,
    this.valueStyle,
    this.labelStyle,
  });

  @override
  Widget build(BuildContext context) {
    final urgentColor = AppColors.errorRed;
    final borderColor = isUrgent
        ? urgentColor.withOpacity(0.35)
        : Colors.white.withOpacity(0.07);
    final bgColor = isUrgent
        ? urgentColor.withOpacity(0.07)
        : AppColors.sceCardBg;
    final valueColor = isUrgent ? urgentColor : Colors.white;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: width,
      padding: EdgeInsets.symmetric(vertical: 8.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style:
                valueStyle ??
                FontManager.heading3(
                  color: valueColor,
                ).copyWith(fontSize: 20.sp, height: 1),
          ),
          SizedBox(height: 3.h),
          Text(
            label,
            style:
                labelStyle ??
                FontManager.labelSmall(
                  color: isUrgent
                      ? urgentColor.withOpacity(0.7)
                      : AppColors.textHint,
                ).copyWith(fontSize: 8.sp, letterSpacing: 0.4),
          ),
        ],
      ),
    );
  }
}

// ── Separator ─────────────────────────────────────────────────────────────────

class _Separator extends StatelessWidget {
  final bool isUrgent;

  const _Separator({required this.isUrgent});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Text(
        ':',
        style: FontManager.heading3(
          color: isUrgent
              ? AppColors.errorRed.withOpacity(0.6)
              : AppColors.textHint,
        ).copyWith(fontSize: 18.sp, height: 1),
      ),
    );
  }
}
