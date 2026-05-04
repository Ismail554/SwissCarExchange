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
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        _calculateTimeLeft();
      }
    });
  }

  void _calculateTimeLeft() {
    if (widget.endTime == null) {
      setState(() {
        _timeLeft = Duration.zero;
      });
      return;
    }

    final now = DateTime.now();
    final difference = widget.endTime!.difference(now);

    setState(() {
      _timeLeft = difference.isNegative ? Duration.zero : difference;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_timeLeft == Duration.zero && widget.endTime != null && DateTime.now().isAfter(widget.endTime!)) {
      return Text(
        "AUCTION ENDED",
        style: widget.valueStyle ?? FontManager.heading3(color: AppColors.errorRed),
      );
    }

    final days = _timeLeft.inDays;
    final hours = _timeLeft.inHours % 24;
    final minutes = _timeLeft.inMinutes % 60;
    final seconds = _timeLeft.inSeconds % 60;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.showDays && days > 0) ...[
          _buildTimeSegment(days.toString().padLeft(2, '0'), "DAYS"),
          _buildSeparator(),
        ],
        _buildTimeSegment(hours.toString().padLeft(2, '0'), "HRS"),
        _buildSeparator(),
        _buildTimeSegment(minutes.toString().padLeft(2, '0'), "MIN"),
        _buildSeparator(),
        _buildTimeSegment(seconds.toString().padLeft(2, '0'), "SEC"),
      ],
    );
  }

  Widget _buildTimeSegment(String value, String label) {
    return Container(
      width: 65.w,
      padding: EdgeInsets.symmetric(vertical: 10.h),
      decoration: BoxDecoration(
        color: AppColors.sceCardBg,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: widget.valueStyle ??
                FontManager.heading3(
                  color: Colors.white,
                ).copyWith(fontSize: 22.sp),
          ),
          SizedBox(height: 2.h),
          Text(
            label,
            style: widget.labelStyle ??
                FontManager.labelSmall(
                  color: AppColors.textHint,
                ).copyWith(fontSize: 9.sp),
          ),
        ],
      ),
    );
  }

  Widget _buildSeparator() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      child: Text(
        ":",
        style: FontManager.heading3(
          color: AppColors.textHint,
        ),
      ),
    );
  }
}
