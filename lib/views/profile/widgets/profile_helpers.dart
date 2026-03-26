import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rionydo/core/constants/font_manager.dart';
import 'package:rionydo/core/utils/app_colors.dart';

class ProfileSectionTitle extends StatefulWidget {
  final String title;
  final VoidCallback? onTap;
  const ProfileSectionTitle(this.title, {super.key, this.onTap});

  @override
  State<ProfileSectionTitle> createState() => _ProfileSectionTitleState();
}

class _ProfileSectionTitleState extends State<ProfileSectionTitle> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 4.w),
      child: Text(
        widget.title,
        style: TextStyle(
          color: AppColors.greyD4,
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class ProfileStatItem extends StatelessWidget {
  final String value;
  final String label;
  final Color valueColor;

  const ProfileStatItem(this.value, this.label, this.valueColor, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontSize: 22.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 4.h),
        Text(label, style: FontManager.bodySmall(color: AppColors.grey)),
      ],
    );
  }
}

class ProfileListTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isPremiumFeature;
  final VoidCallback? onTap;

  const ProfileListTile(
    this.icon,
    this.title, {
    super.key,
    this.isPremiumFeature = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 4.h),
      leading: Icon(
        icon,
        color: isPremiumFeature ? AppColors.sceGold : AppColors.greyD9,
        size: 22.sp,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: AppColors.white,
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Icon(Icons.chevron_right, color: AppColors.grey, size: 20.sp),
      onTap: onTap,
    );
  }
}

class ProfileDivider extends StatelessWidget {
  final EdgeInsetsGeometry? margin;
  const ProfileDivider({super.key, this.margin});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      color: AppColors.darkGrey,
      margin: margin ?? EdgeInsets.symmetric(horizontal: 20.w),
    );
  }
}

class ProfileInfoRow extends StatelessWidget {
  final String label;
  final String value;

  const ProfileInfoRow(this.label, this.value, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: SizedBox(
        width: double.maxFinite,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: FontManager.bodySmall(color: AppColors.grey)),
            SizedBox(height: 4.h),
            Text(value, style: FontManager.bodyMedium(color: AppColors.white)),
          ],
        ),
      ),
    );
  }
}
