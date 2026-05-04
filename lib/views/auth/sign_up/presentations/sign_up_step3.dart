import 'dart:io';
import 'dart:ui';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:open_filex/open_filex.dart';
import 'package:provider/provider.dart';
import 'package:rionydo/app_utils/utils/app_colors.dart';
import 'package:rionydo/controllers/auth/register_provider.dart';
import 'package:rionydo/core/widgets/common_background.dart';
import 'package:rionydo/core/widgets/custom_button.dart';
import 'package:rionydo/core/widgets/custom_back_button.dart';
import 'package:rionydo/core/widgets/photo_picker_field.dart';
import 'package:rionydo/core/widgets/widget_snackbar.dart';
import 'package:rionydo/views/auth/sign_up/presentations/sign_up_step2.dart';

class SignUpStep3 extends StatefulWidget {
  final String email;
  final String password;
  final String phone;
  final UserRole role;
  final String address;
  final String fullName;
  final File? idDocumentFile;
  final String company;
  final String uid;

  const SignUpStep3({
    super.key,
    required this.email,
    required this.password,
    required this.phone,
    required this.role,
    required this.address,
    this.fullName = '',
    this.idDocumentFile,
    this.company = '',
    this.uid = '',
  });

  @override
  State<SignUpStep3> createState() => _SignUpStep3State();
}

class _SignUpStep3State extends State<SignUpStep3> {
  bool _isTermsAccepted = false;
  bool _isPickingFile = false;

  bool get _isIndividual => widget.role == UserRole.individual;

  bool _canCreate(RegisterProvider provider) {
    if (!_isTermsAccepted) return false;
    if (_isIndividual) {
      return provider.photoFile != null && widget.idDocumentFile != null;
    } else {
      return provider.licensePickedFile != null;
    }
  }

  String _formatSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  IconData _fileIcon(String? ext) {
    switch (ext?.toLowerCase()) {
      case 'pdf':
        return Icons.picture_as_pdf_outlined;
      case 'jpg':
      case 'jpeg':
      case 'png':
        return Icons.image_outlined;
      default:
        return Icons.insert_drive_file_outlined;
    }
  }

  Future<void> _showPhotoPicker() async {
    await showPhotoPicker(
      context: context,
      onPickFromSource: (source) async {
        Navigator.pop(context);
        final picker = ImagePicker();
        final picked = await picker.pickImage(source: source, imageQuality: 85);
        if (picked != null && mounted) {
          context.read<RegisterProvider>().setPhotoFile(File(picked.path), picked.name);
        }
      },
      onPickFromFiles: () async {
        Navigator.pop(context);
        final picked = await pickPhotoFromFiles();
        if (picked != null && mounted) {
          context.read<RegisterProvider>().setPhotoFile(picked.file, picked.name);
        }
      },
    );
  }

  Future<void> _pickLicense() async {
    setState(() => _isPickingFile = true);
    try {
      final result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
        withData: false,
        withReadStream: false,
      );
      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        if (file.size > 5 * 1024 * 1024) {
          if (mounted) {
            AppSnackBar.error(
              context,
              'File exceeds 5 MB limit. Please choose a smaller file.',
            );
          }
          return;
        }
        if (mounted) {
          context.read<RegisterProvider>().setLicenseFile(file);
        }
      }
    } finally {
      if (mounted) setState(() => _isPickingFile = false);
    }
  }

  Future<void> _openLicense() async {
    final provider = context.read<RegisterProvider>();
    final path = provider.licensePickedFile?.path;
    if (path == null) return;
    if (!File(path).existsSync()) {
      if (mounted)
        AppSnackBar.error(context, 'File not found. Please pick it again.');
      return;
    }
    await OpenFilex.open(path);
  }

  Future<void> _submit() async {
    final provider = context.read<RegisterProvider>();
    if (_isIndividual) {
      await provider.registerPrivate(
        context: context,
        email: widget.email,
        password: widget.password,
        phone: widget.phone,
        address: widget.address,
        fullName: widget.fullName,
        photoFile: provider.photoFile!,
        idDocumentFile: widget.idDocumentFile!,
      );
    } else {
      await provider.registerCompany(
        context: context,
        email: widget.email,
        password: widget.password,
        phone: widget.phone,
        address: widget.address,
        company: widget.company,
        uid: widget.uid,
        licenseFile: File(provider.licensePickedFile!.path!),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final teal = AppColors.sceTeal;
    final isLoading = context.watch<RegisterProvider>().isLoading;

    return CommonBackground(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 16.w, top: 16.h),
              child: Align(
                alignment: Alignment.centerLeft,
                child: const CustomBackButton(),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Step indicator
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RichText(
                          text: TextSpan(
                            style: TextStyle(fontSize: 13.sp),
                            children: [
                              TextSpan(
                                text: 'Step  ',
                                style: TextStyle(
                                  color: teal,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              TextSpan(
                                text: '3 of 3',
                                style: TextStyle(
                                  color: teal,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          'Verification',
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: 13.sp,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: 1.0,
                        backgroundColor: Colors.white12,
                        valueColor: AlwaysStoppedAnimation<Color>(teal),
                        minHeight: 3,
                      ),
                    ),
                    SizedBox(height: 36.h),

                    // Title
                    Text(
                      _isIndividual ? 'Profile Photo' : 'Business Verification',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      _isIndividual
                          ? 'Upload a clear profile photo to complete your registration.'
                          : 'Upload your commercial register extract\n(Handelsregisterauszug) to verify your B2B status.',
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 13.sp,
                        height: 1.5,
                      ),
                    ),
                    SizedBox(height: 28.h),
                    
                    Consumer<RegisterProvider>(
                      builder: (context, provider, _) => Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // ── Individual ──────────────────────────────────
                          if (_isIndividual) ...[
                            _SectionLabel('Profile Photo'),
                            SizedBox(height: 8.h),
                            PhotoPickerField(
                              photoFile: provider.photoFile,
                              photoFileName: provider.photoFileName,
                              onTap: _showPhotoPicker,
                              onRemove: () => provider.setPhotoFile(null, null),
                            ),
                            SizedBox(height: 20.h),
                            _SectionLabel('ID Document (from Step 2)'),
                            SizedBox(height: 8.h),
                            _ReadonlyDocRow(file: widget.idDocumentFile, teal: teal),
                          ],
      
                          // ── Company ─────────────────────────────────────
                          if (!_isIndividual) ...[
                            _SectionLabel('Commercial Register Extract'),
                            SizedBox(height: 8.h),
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              decoration: BoxDecoration(
                                color: provider.licensePickedFile != null
                                    ? teal.withOpacity(0.06)
                                    : Colors.white.withOpacity(0.04),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: provider.licensePickedFile != null
                                      ? teal.withOpacity(0.5)
                                      : Colors.white.withOpacity(0.15),
                                  width: 1.5,
                                ),
                              ),
                              child: provider.licensePickedFile != null
                                  ? Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 20.w,
                                        vertical: 18.h,
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 44.w,
                                            height: 44.w,
                                            decoration: BoxDecoration(
                                              color: teal.withOpacity(0.12),
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            child: Icon(
                                              _fileIcon(
                                                provider.licensePickedFile!.extension,
                                              ),
                                              color: teal,
                                              size: 22.sp,
                                            ),
                                          ),
                                          SizedBox(width: 14.w),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  provider.licensePickedFile!.name,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 13.sp,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                SizedBox(height: 4.h),
                                                Text(
                                                  _formatSize(
                                                    provider.licensePickedFile!.size,
                                                  ),
                                                  style: TextStyle(
                                                    color: Colors.white38,
                                                    fontSize: 11.sp,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(width: 8.w),
                                          _DocActionBtn(
                                            icon: Icons.visibility_outlined,
                                            tooltip: 'View',
                                            color: teal,
                                            onTap: _openLicense,
                                          ),
                                          SizedBox(width: 8.w),
                                          _DocActionBtn(
                                            icon: Icons.swap_horiz,
                                            tooltip: 'Change',
                                            color: Colors.white54,
                                            onTap: _pickLicense,
                                          ),
                                        ],
                                      ),
                                    )
                                  : InkWell(
                                      onTap: _isPickingFile ? null : _pickLicense,
                                      borderRadius: BorderRadius.circular(16),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(vertical: 40.h),
                                        child: _isPickingFile
                                            ? Center(
                                                child: SizedBox(
                                                  width: 28,
                                                  height: 28,
                                                  child: CircularProgressIndicator(
                                                    color: teal,
                                                    strokeWidth: 2,
                                                  ),
                                                ),
                                              )
                                            : Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.upload_outlined,
                                                    color: Colors.white54,
                                                    size: 36.sp,
                                                  ),
                                                  SizedBox(height: 12.h),
                                                  Text(
                                                    'Tap to upload document',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14.sp,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                  SizedBox(height: 6.h),
                                                  Text(
                                                    'PDF, JPG or PNG (max 5MB)',
                                                    style: TextStyle(
                                                      color: Colors.white38,
                                                      fontSize: 11.sp,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                      ),
                                    ),
                            ),
                          ],
                        ],
                      ),
                    ),

                    SizedBox(height: 24.h),

                    // Terms
                    GestureDetector(
                      onTap: () =>
                          setState(() => _isTermsAccepted = !_isTermsAccepted),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 20.w,
                            height: 20.w,
                            margin: EdgeInsets.only(top: 2.h),
                            decoration: BoxDecoration(
                              color: _isTermsAccepted
                                  ? teal.withOpacity(0.15)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: _isTermsAccepted ? teal : Colors.white38,
                                width: 1.5,
                              ),
                            ),
                            child: _isTermsAccepted
                                ? Icon(Icons.check, color: teal, size: 14)
                                : null,
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  color: Colors.white60,
                                  fontSize: 13.sp,
                                  height: 1.5,
                                ),
                                children: [
                                  TextSpan(
                                    text: _isIndividual
                                        ? 'I confirm that all information provided is accurate and I accept the '
                                        : 'I confirm that I am authorized to act on behalf of this company and accept the ',
                                  ),
                                  TextSpan(
                                    text: _isIndividual
                                        ? 'Terms & Conditions'
                                        : 'B2B Terms & Conditions',
                                    style: TextStyle(
                                      color: teal,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 36.h),

                    Consumer<RegisterProvider>(
                      builder: (context, provider, _) => CustomButton(
                        text: 'Create Account',
                        isActive: _canCreate(provider),
                        isLoading: isLoading,
                        onPressed: _submit,
                      ),
                    ),

                    SizedBox(height: 24.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// Section Label
// ─────────────────────────────────────────────────────────
class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: TextStyle(color: Colors.white70, fontSize: 13.sp),
  );
}


// ─────────────────────────────────────────────────────────
// Readonly row showing the id doc from Step 2
// ─────────────────────────────────────────────────────────
class _ReadonlyDocRow extends StatelessWidget {
  final File? file;
  final Color teal;

  const _ReadonlyDocRow({required this.file, required this.teal});

  @override
  Widget build(BuildContext context) {
    if (file == null) {
      return Container(
        height: 52.h,
        padding: EdgeInsets.symmetric(horizontal: 14.w),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.04),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.red.withOpacity(0.4), width: 1.2),
        ),
        child: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.red, size: 18),
            SizedBox(width: 10.w),
            Text(
              'No ID document found — go back to Step 2',
              style: TextStyle(color: Colors.red, fontSize: 12.sp),
            ),
          ],
        ),
      );
    }

    final fileName = file!.path.split(RegExp(r'[/\\]')).last;
    return Container(
      height: 52.h,
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      decoration: BoxDecoration(
        color: teal.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: teal.withOpacity(0.4), width: 1.2),
      ),
      child: Row(
        children: [
          Icon(Icons.check_circle_outline_rounded, color: teal, size: 20),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              fileName,
              style: TextStyle(
                color: Colors.white,
                fontSize: 13.sp,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }
}


// ─────────────────────────────────────────────────────────
// Document Action Button
// ─────────────────────────────────────────────────────────
class _DocActionBtn extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final Color color;
  final VoidCallback onTap;

  const _DocActionBtn({
    required this.icon,
    required this.tooltip,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.08),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 18),
        ),
      ),
    );
  }
}
