import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rionydo/core/utils/app_colors.dart';

class SceStarRating extends StatelessWidget {
  final double rating;
  final double size;
  final Color color;

  const SceStarRating({
    super.key,
    required this.rating,
    this.size = 14,
    this.color = AppColors.sceGold,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < rating.floor()
              ? Icons.star_rounded
              : index < rating
                  ? Icons.star_half_rounded
                  : Icons.star_outline_rounded,
          color: color,
          size: size.sp,
        );
      }),
    );
  }
}
