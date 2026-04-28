import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rionydo/core/constants/font_manager.dart';
import 'package:rionydo/core/utils/app_colors.dart';
import 'package:rionydo/core/utils/app_spacing.dart';
import 'package:rionydo/core/widgets/common_background.dart';
import 'package:rionydo/core/widgets/custom_back_button.dart';
import 'package:rionydo/core/widgets/custom_button.dart';
import 'package:rionydo/core/widgets/custom_text_field.dart';

class PrivacySettingsView extends StatefulWidget {
  const PrivacySettingsView({super.key});

  @override
  State<PrivacySettingsView> createState() => _PrivacySettingsViewState();
}

class _PrivacySettingsViewState extends State<PrivacySettingsView> {
  bool _twoFactorEnabled = false;

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
          decoration: BoxDecoration(
            color: AppColors.sceCardBg.withOpacity(0.95),
            borderRadius: BorderRadius.circular(28.r),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// 🔴 ICON
              Container(
                height: 70.h,
                width: 70.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      Colors.red.withOpacity(0.2),
                      Colors.redAccent.withOpacity(0.05),
                    ],
                  ),
                  border: Border.all(
                    color: Colors.redAccent.withOpacity(0.4),
                    width: 1.2.w,
                  ),
                ),
                child: Icon(
                  Icons.delete_forever_rounded,
                  color: Colors.redAccent,
                  size: 34.sp,
                ),
              ),

              SizedBox(height: 20.h),

              ///  TITLE
              Text(
                "Delete Account",
                style: FontManager.heading2(
                  color: AppColors.white,
                ).copyWith(fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 10.h),

              /// ⚠️ DESCRIPTION
              Text(
                "This action is permanent and cannot be undone.\nAll your data will be erased forever.",
                style: FontManager.bodyMedium(color: AppColors.sceGreyA0),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 28.h),

              ///  DELETE BUTTON
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.errorRed,
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    // delete logic
                  },
                  child: Text(
                    "Delete My Account",
                    style: FontManager.bodyMedium(
                      color: Colors.white,
                    ).copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
              ),

              SizedBox(height: 12.h),

              /// CANCEL BUTTON (Ghost style)
              CustomButton(
                text: "Cancel",
                onPressed: () => Navigator.pop(context),
                isPrimary: false,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CommonBackground(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const CustomBackButton(),
        title: Text(
          'Security & Privacy',
          style: FontManager.titleText(color: AppColors.white),
        ),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text(
            //   "SECURITY",
            //   style: FontManager.labelMedium(color: AppColors.sceGreyA0),
            // ),
            // AppSpacing.h16,
            // Container(
            //   decoration: BoxDecoration(
            //     color: AppColors.sceCardBg,
            //     borderRadius: BorderRadius.circular(16.r),
            //     border: Border.all(color: Colors.white.withOpacity(0.05)),
            //   ),
            //   child: Column(
            //     children: [
            //       _SecurityOption(
            //         icon: Icons.lock_outline,
            //         title: "Change Password",
            //         subtitle: "Last changed 30 days ago",
            //         onTap: () {
            //           // Logic to trigger password change flow/fields
            //         },
            //       ),
            //       Divider(color: Colors.white.withOpacity(0.05), height: 1),
            //       Padding(
            //         padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            //         child: Row(
            //           children: [
            //             Icon(Icons.phone_android_outlined, color: AppColors.sceGreyA0, size: 24.sp),
            //             AppSpacing.w16,
            //             Expanded(
            //               child: Column(
            //                 crossAxisAlignment: CrossAxisAlignment.start,
            //                 children: [
            //                   Text(
            //                     "Two-Factor Authentication",
            //                     style: FontManager.bodyMedium(color: AppColors.white)
            //                         .copyWith(fontWeight: FontWeight.w600),
            //                   ),
            //                   Text(
            //                     "Add an extra layer of security",
            //                     style: FontManager.bodySmall(color: AppColors.sceGrey99),
            //                   ),
            //                 ],
            //               ),
            //             ),
            //             CupertinoSwitch(
            //               activeColor: AppColors.sceTeal,
            //               value: _twoFactorEnabled,
            //               onChanged: (val) => setState(() => _twoFactorEnabled = val),
            //             ),
            //           ],
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            // AppSpacing.h40,
            // Change Password Form (Optional if user taps Change Password, showing it directly for convenience)
            Text(
              "CHANGE PASSWORD",
              style: FontManager.labelMedium(color: AppColors.sceGreyA0),
            ),
            AppSpacing.h16,
            const CustomTextField(
              hintText: "Enter Current Password",
              obscureText: true,
              prefixIcon: Icon(Icons.lock_open, color: AppColors.sceGreyA0),
            ),
            AppSpacing.h16,
            const CustomTextField(
              hintText: "Enter New Password",
              obscureText: true,
              prefixIcon: Icon(Icons.lock_outline, color: AppColors.sceGreyA0),
            ),
            AppSpacing.h16,
            const CustomTextField(
              hintText: "Confirm New Password",
              obscureText: true,
              prefixIcon: Icon(Icons.lock_person, color: AppColors.sceGreyA0),
            ),
            AppSpacing.h24,
            CustomButton(
              text: "Change Password",
              onPressed: () {
                // Logic to update password
              },
            ),

            AppSpacing.h48,
            Text(
              "DANGER ZONE",
              style: FontManager.labelMedium(color: AppColors.errorRed),
            ),
            AppSpacing.h16,
            InkWell(
              onTap: _showDeleteAccountDialog,
              borderRadius: BorderRadius.circular(16.r),
              child: Container(
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: AppColors.errorRed.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: AppColors.errorRed.withOpacity(0.2),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.delete_outline,
                      color: AppColors.errorRed,
                      size: 28.sp,
                    ),
                    AppSpacing.w16,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Delete Account",
                            style: FontManager.bodyLarge(
                              color: AppColors.errorRed,
                            ).copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Permanently delete your account and data",
                            style: FontManager.bodySmall(
                              color: AppColors.errorRed.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            AppSpacing.h40,
          ],
        ),
      ),
    );
  }
}

class _SecurityOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SecurityOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Row(
          children: [
            Icon(icon, color: AppColors.sceGreyA0, size: 24.sp),
            AppSpacing.w16,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: FontManager.bodyMedium(
                      color: AppColors.white,
                    ).copyWith(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    subtitle,
                    style: FontManager.bodySmall(color: AppColors.sceGrey99),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: AppColors.sceGreyA0,
              size: 14.sp,
            ),
          ],
        ),
      ),
    );
  }
}
