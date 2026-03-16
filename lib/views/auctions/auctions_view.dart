import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wynante/core/widgets/common_background.dart';

class AuctionsView extends StatefulWidget {
  const AuctionsView({super.key});

  @override
  State<AuctionsView> createState() => _AuctionsViewState();
}

class _AuctionsViewState extends State<AuctionsView> {
  @override
  Widget build(BuildContext context) {
    return CommonBackground(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.gavel_rounded, color: const Color(0xFF00D5BE), size: 64.sp),
            SizedBox(height: 16.h),
            Text(
              'Auctions Screen',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Explore ongoing car auctions',
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
