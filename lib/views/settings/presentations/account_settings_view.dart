import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:rionydo/app_utils/constants/font_manager.dart';
import 'package:rionydo/app_utils/utils/app_colors.dart';
import 'package:rionydo/app_utils/utils/app_spacing.dart';
import 'package:rionydo/controllers/profile_provider.dart';
import 'package:rionydo/app_utils/constants/global_state.dart';
import 'package:rionydo/models/profile/user_profile_response.dart';
import 'package:rionydo/core/widgets/common_background.dart';
import 'package:rionydo/core/widgets/custom_back_button.dart';
import 'package:rionydo/core/widgets/custom_button.dart';
import 'package:rionydo/core/widgets/custom_text_field.dart';
import 'package:rionydo/core/widgets/photo_picker_field.dart';
import 'package:rionydo/core/widgets/widget_snackbar.dart';

class AccountSettingsView extends StatefulWidget {
  const AccountSettingsView({super.key});

  @override
  State<AccountSettingsView> createState() => _AccountSettingsViewState();
}

class _AccountSettingsViewState extends State<AccountSettingsView> {
  final _formKey = GlobalKey<FormState>();

  // Shared
  final _emailCtrl   = TextEditingController();
  final _phoneCtrl   = TextEditingController();
  final _addressCtrl = TextEditingController();

  // Private only
  final _fullNameCtrl = TextEditingController();

  // Company only
  final _companyCtrl = TextEditingController();
  final _uidCtrl     = TextEditingController();
  final _websiteCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<UserProfileProvider>();

      if (provider.userProfile != null) {
        _populateFields(provider.userProfile!);
      } else {
        provider.fetchProfile(globalState: context.read<GlobalState>());
      }

      provider.addListener(_onProfileUpdate);
    });
  }

  void _onProfileUpdate() {
    final profile = context.read<UserProfileProvider>().userProfile;
    if (profile != null && _emailCtrl.text.isEmpty) {
      _populateFields(profile);
    }
  }

  void _populateFields(UserProfileResponse profile) {
    _emailCtrl.text   = profile.email;
    _phoneCtrl.text   = profile.phone;
    _addressCtrl.text = profile.address;

    if (profile is PrivateUserProfile) {
      _fullNameCtrl.text = profile.fullName;
    } else if (profile is CompanyUserProfile) {
      _companyCtrl.text  = profile.company;
      _uidCtrl.text      = profile.uid;
      _websiteCtrl.text  = profile.website;
    }
  }

  @override
  void dispose() {
    context.read<UserProfileProvider>().removeListener(_onProfileUpdate);
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _addressCtrl.dispose();
    _fullNameCtrl.dispose();
    _companyCtrl.dispose();
    _uidCtrl.dispose();
    _websiteCtrl.dispose();
    super.dispose();
  }

  // ─── Photo Picker ──────────────────────────────────────────────────────────

  Future<void> _showPhotoPicker() async {
    await showPhotoPicker(
      context: context,
      onPickFromSource: (source) async {
        Navigator.pop(context);
        final picked = await ImagePicker().pickImage(source: source, imageQuality: 85);
        if (picked != null && mounted) {
          context.read<UserProfileProvider>().setPhotoFile(File(picked.path), picked.name);
        }
      },
      onPickFromFiles: () async {
        Navigator.pop(context);
        final picked = await pickPhotoFromFiles();
        if (picked != null && mounted) {
          context.read<UserProfileProvider>().setPhotoFile(picked.file, picked.name);
        }
      },
    );
  }

  // ─── Save Changes ──────────────────────────────────────────────────────────

  Future<void> _saveChanges() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final provider   = context.read<UserProfileProvider>();
    final isCompany  = context.read<GlobalState>().userType == UserType.company;

    bool success;

    if (isCompany) {
      // Company: website accepted, no photo_url
      success = await provider.updateProfile({
        'company': _companyCtrl.text.trim(),
        'uid':     _uidCtrl.text.trim(),
        'phone':   _phoneCtrl.text.trim(),
        'address': _addressCtrl.text.trim(),
        'website': _websiteCtrl.text.trim(),
      });
    } else {
      // Private: photo_url, no website
      final baseBody = {
        'full_name': _fullNameCtrl.text.trim(),
        'phone':     _phoneCtrl.text.trim(),
        'address':   _addressCtrl.text.trim(),
      };

      if (provider.pendingPhotoFile != null) {
        success = await provider.uploadPhotoAndUpdate(provider.pendingPhotoFile!, baseBody);
      } else {
        success = await provider.updateProfile(baseBody);
      }
    }

    if (mounted) {
      if (success) {
        AppSnackBar.success(context, 'Account settings updated successfully!');
        Navigator.pop(context);
      } else {
        final error = context.read<UserProfileProvider>().saveError;
        AppSnackBar.error(context, error ?? 'Failed to update settings');
      }
    }
  }

  // ─── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final isCompany = context.watch<GlobalState>().userType == UserType.company;
    final isSaving  = context.watch<UserProfileProvider>().isSaving;

    return CommonBackground(
      appBar: AppBar(
        leading: const CustomBackButton(),
        title: Text('Account Settings', style: FontManager.titleText(color: AppColors.white)),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ── Private Fields ──────────────────────────────────────────────
              if (!isCompany) ...[
                _FieldLabel('Full Name'),
                AppSpacing.h8,
                CustomTextField(
                  controller: _fullNameCtrl,
                  hintText: 'Enter your full name',
                  prefixIcon: Icon(Icons.person_outline, color: AppColors.sceGreyA0, size: 20.sp),
                ),
                AppSpacing.h18,

                _FieldLabel('Profile Photo'),
                AppSpacing.h8,
                Consumer<UserProfileProvider>(
                  builder: (_, provider, __) {
                    final existingUrl = (provider.userProfile is PrivateUserProfile)
                        ? (provider.userProfile as PrivateUserProfile).photoUrl
                        : null;
                    return PhotoPickerField(
                      photoFile: provider.pendingPhotoFile,
                      photoFileName: provider.pendingPhotoFileName,
                      networkPhotoUrl: existingUrl,
                      onTap: _showPhotoPicker,
                      onRemove: () => provider.setPhotoFile(null, null),
                    );
                  },
                ),
                AppSpacing.h18,
              ],

              // ── Company Fields ──────────────────────────────────────────────
              if (isCompany) ...[
                _FieldLabel('Company Name'),
                AppSpacing.h8,
                CustomTextField(
                  controller: _companyCtrl,
                  hintText: 'Enter company name',
                  prefixIcon: Icon(Icons.business_outlined, color: AppColors.sceGreyA0, size: 20.sp),
                ),
                AppSpacing.h18,

                _FieldLabel('UID Number'),
                AppSpacing.h8,
                CustomTextField(
                  controller: _uidCtrl,
                  hintText: 'CHE-XXX.XXX.XXX',
                  prefixIcon: Icon(Icons.badge_outlined, color: AppColors.sceGreyA0, size: 20.sp),
                ),
                AppSpacing.h18,
              ],

              // ── Shared Fields ───────────────────────────────────────────────
              _FieldLabel('Email (Read-only)'),
              AppSpacing.h8,
              CustomTextField(
                controller: _emailCtrl,
                enabled: false,
                hintText: 'info@example.ch',
                keyboardType: TextInputType.emailAddress,
                prefixIcon: Icon(Icons.email_outlined, color: AppColors.sceGreyA0, size: 20.sp),
              ),
              AppSpacing.h18,

              _FieldLabel('Phone'),
              AppSpacing.h8,
              CustomTextField(
                controller: _phoneCtrl,
                hintText: '+41 XX XXX XX XX',
                keyboardType: TextInputType.phone,
                prefixIcon: Icon(Icons.phone_outlined, color: AppColors.sceGreyA0, size: 20.sp),
              ),
              AppSpacing.h18,

              _FieldLabel('Address'),
              AppSpacing.h8,
              CustomTextField(
                controller: _addressCtrl,
                hintText: 'Street, Number, ZIP City',
                prefixIcon: Icon(Icons.location_on_outlined, color: AppColors.sceGreyA0, size: 20.sp),
              ),
              AppSpacing.h18,

              // ── Company-only: Website ───────────────────────────────────────
              if (isCompany) ...[
                _FieldLabel('Website'),
                AppSpacing.h8,
                CustomTextField(
                  controller: _websiteCtrl,
                  hintText: 'www.example.ch',
                  keyboardType: TextInputType.url,
                  prefixIcon: Icon(Icons.language_outlined, color: AppColors.sceGreyA0, size: 20.sp),
                ),
                AppSpacing.h18,
              ],

              AppSpacing.h16,

              // ── Save Button ─────────────────────────────────────────────────
              CustomButton(
                text: 'Save Changes',
                isLoading: isSaving,
                isActive: !isSaving,
                onPressed: () => _saveChanges(),
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