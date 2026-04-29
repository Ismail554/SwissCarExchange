import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:rionydo/app_utils/utils/assets_manager.dart';

class CustomBackButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final double size;

  const CustomBackButton({super.key, this.onPressed, this.size = 52.0});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:
          onPressed ??
          () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Container(
            width: size.sp,
            height: size.sp,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Image.asset(IconAssets.customBack, fit: BoxFit.contain),
            // SvgPicture.asset(
            //   'assets/svgs/sample_back.svg',
            //   fit: BoxFit.contain,
            // ),
          ),
        ),
      ),
    );
  }
}
