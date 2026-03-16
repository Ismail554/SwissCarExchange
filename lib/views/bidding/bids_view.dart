import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wynante/core/widgets/common_background.dart';

class BidsView extends StatefulWidget {
  const BidsView({super.key});

  @override
  State<BidsView> createState() => _BidsViewState();
}

class _BidsViewState extends State<BidsView> {
  @override
  Widget build(BuildContext context) {
    return CommonBackground(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.card_giftcard_rounded, color: const Color(0xFF00D5BE), size: 64.sp),
            SizedBox(height: 16.h),
            Text(
              'Your Bids',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Monitor your active and past bids here',
              style: TextStyle(
                color: Colors.white54,
                fontSize: 16.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
