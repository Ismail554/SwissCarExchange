import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wynante/core/widgets/common_background.dart';

class BidsView extends StatelessWidget {
  const BidsView({super.key});

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
              'My Bids',
              style: TextStyle(color: Colors.white, fontSize: 24.sp, fontWeight: FontWeight.bold),
            ),
            Text(
              'Track your active and historical bids',
              style: TextStyle(color: Colors.white54, fontSize: 14.sp),
            ),
          ],
        ),
      ),
    );
  }
}
