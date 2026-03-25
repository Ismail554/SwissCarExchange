import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rionydo/core/constants/font_manager.dart';
import 'package:rionydo/core/utils/app_colors.dart';
import 'package:rionydo/core/utils/app_spacing.dart';
import 'package:rionydo/core/widgets/common_background.dart';
import 'package:rionydo/core/widgets/custom_back_button.dart';
import 'package:rionydo/core/widgets/custom_button.dart';
import 'package:rionydo/core/widgets/custom_text_field.dart';
import 'package:rionydo/core/widgets/widget_snackbar.dart';

class AccountSettingsView extends StatefulWidget {
  const AccountSettingsView({super.key});

  @override
  State<AccountSettingsView> createState() => _AccountSettingsViewState();
}

class _AccountSettingsViewState extends State<AccountSettingsView> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers with mock initial data
  final _companyCtrl = TextEditingController(text: "Premium Auto Group AG");
  final _uidCtrl = TextEditingController(text: "CHE-123.456.789");
  final _emailCtrl = TextEditingController(text: "info@premiumauto.ch");
  final _phoneCtrl = TextEditingController(text: "+41 79 123 45 67");
  final _addressCtrl = TextEditingController(text: "Bahnhofstrasse 45, 8001 Zürich");
  final _websiteCtrl = TextEditingController(text: "www.premiumauto.ch");

  @override
  void dispose() {
    _companyCtrl.dispose();
    _uidCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _addressCtrl.dispose();
    _websiteCtrl.dispose();
    super.dispose();
  }

  void _saveChanges() {
    if (_formKey.currentState?.validate() ?? false) {
      AppSnackBar.success(context, "Account settings updated successfully!");
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CommonBackground(
      appBar: AppBar(
        leading: const CustomBackButton(),
        title: Text(
          'Account Settings',
          style: FontManager.titleText(color: AppColors.white),
        ),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Company Name ---
              _FieldLabel("Company Name"),
              AppSpacing.h8,
              CustomTextField(
                controller: _companyCtrl,
                hintText: "Enter company name",
                prefixIcon: Icon(Icons.business_outlined, color: AppColors.sceGreyA0, size: 20.sp),
              ),
              AppSpacing.h18,

              // --- UID Number ---
              _FieldLabel("UID Number"),
              AppSpacing.h8,
              CustomTextField(
                controller: _uidCtrl,
                hintText: "Enter UID number",
                prefixIcon: Icon(Icons.business_outlined, color: AppColors.sceGreyA0, size: 20.sp),
              ),
              AppSpacing.h18,

              // --- Email ---
              _FieldLabel("Email"),
              AppSpacing.h8,
              CustomTextField(
                controller: _emailCtrl,
                hintText: "info@example.ch",
                keyboardType: TextInputType.emailAddress,
                prefixIcon: Icon(Icons.email_outlined, color: AppColors.sceGreyA0, size: 20.sp),
              ),
              AppSpacing.h18,

              // --- Phone ---
              _FieldLabel("Phone"),
              AppSpacing.h8,
              CustomTextField(
                controller: _phoneCtrl,
                hintText: "+41 XX XXX XX XX",
                keyboardType: TextInputType.phone,
                prefixIcon: Icon(Icons.phone_outlined, color: AppColors.sceGreyA0, size: 20.sp),
              ),
              AppSpacing.h18,

              // --- Address ---
              _FieldLabel("Address"),
              AppSpacing.h8,
              CustomTextField(
                controller: _addressCtrl,
                hintText: "Street, Number, ZIP City",
              ),
              AppSpacing.h18,

              // --- Website ---
              _FieldLabel("Website"),
              AppSpacing.h8,
              CustomTextField(
                controller: _websiteCtrl,
                hintText: "www.example.ch",
                keyboardType: TextInputType.url,
              ),
              AppSpacing.h32,

              // --- Save Button ---
              CustomButton(
                text: "Save Changes",
                onPressed: _saveChanges,
                icon: Icons.save_outlined,
              ),
              AppSpacing.h40,
            ],
          ),
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: FontManager.bodyMedium(color: AppColors.sceGreyA0).copyWith(fontSize: 14.sp),
    );
  }
}