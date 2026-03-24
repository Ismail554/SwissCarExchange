import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:open_filex/open_filex.dart';
import 'package:rionydo/core/widgets/common_background.dart';
import 'package:rionydo/core/widgets/custom_button.dart';
import 'package:rionydo/core/widgets/custom_back_button.dart';
import 'package:rionydo/views/auth/forgot_password/otp_verify_view.dart';

class SignUpStep3 extends StatefulWidget {
  final String email;
  const SignUpStep3({super.key, required this.email});

  @override
  State<SignUpStep3> createState() => _SignUpStep3State();
}

class _SignUpStep3State extends State<SignUpStep3> {
  bool _isTermsAccepted = false;
  PlatformFile? _pickedFile;
  bool _isPickingFile = false;

  bool get _hasDocument => _pickedFile != null;
  bool get _canCreate => _isTermsAccepted && _hasDocument;

  // Human-readable file size
  String _formatSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  // Extension icon
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

  Future<void> _pickDocument() async {
    setState(() => _isPickingFile = true);
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
        withData: false,
        withReadStream: false,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        final sizeBytes = file.size;

        // Validate max 5 MB
        if (sizeBytes > 5 * 1024 * 1024) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.redAccent.withOpacity(0.9),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                content: const Text(
                  'File exceeds 5 MB limit. Please choose a smaller file.',
                ),
              ),
            );
          }
          return;
        }

        setState(() => _pickedFile = file);
      }
    } finally {
      if (mounted) setState(() => _isPickingFile = false);
    }
  }

  Future<void> _openDocument() async {
    final path = _pickedFile?.path;
    if (path == null) return;
    if (!File(path).existsSync()) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.redAccent.withOpacity(0.9),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            content: const Text('File not found. Please pick it again.'),
          ),
        );
      }
      return;
    }
    await OpenFilex.open(path);
  }

  @override
  Widget build(BuildContext context) {
    final teal = const Color(0xFF00D5BE);

    return CommonBackground(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Back Button
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
                    // Step indicator row
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

                    // Full progress bar
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

                    // Verification Title
                    Text(
                      'Verification',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      'Upload your commercial register extract\n(Handelsregisterauszug) to verify your B2B status.',
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 13.sp,
                        height: 1.5,
                      ),
                    ),

                    SizedBox(height: 28.h),

                    // --- Upload / Document Area ---
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      decoration: BoxDecoration(
                        color: _hasDocument
                            ? teal.withOpacity(0.06)
                            : Colors.white.withOpacity(0.04),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: _hasDocument
                              ? teal.withOpacity(0.5)
                              : Colors.white.withOpacity(0.15),
                          width: 1.5,
                        ),
                      ),
                      child: _hasDocument
                          // ---- Selected state ----
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
                                      _fileIcon(_pickedFile!.extension),
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
                                          _pickedFile!.name,
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
                                          _formatSize(_pickedFile!.size),
                                          style: TextStyle(
                                            color: Colors.white38,
                                            fontSize: 11.sp,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                  // View button
                                  _DocActionBtn(
                                    icon: Icons.visibility_outlined,
                                    tooltip: 'View',
                                    color: teal,
                                    onTap: _openDocument,
                                  ),
                                  SizedBox(width: 8.w),
                                  // Replace button
                                  _DocActionBtn(
                                    icon: Icons.swap_horiz,
                                    tooltip: 'Change',
                                    color: Colors.white54,
                                    onTap: _pickDocument,
                                  ),
                                ],
                              ),
                            )
                          // ---- Empty / pick state ----
                          : InkWell(
                              onTap: _isPickingFile ? null : _pickDocument,
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

                    SizedBox(height: 24.h),

                    // Terms Checkbox
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
                                  const TextSpan(
                                    text:
                                        'I confirm that I am authorized to act on behalf of this company and accept the ',
                                  ),
                                  TextSpan(
                                    text: 'B2B Terms & Conditions',
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

                    // Create Account Button
                    CustomButton(
                      text: 'Create Account',
                      isActive: _canCreate,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                OtpVerifyView(email: widget.email),
                          ),
                        );
                      },
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
