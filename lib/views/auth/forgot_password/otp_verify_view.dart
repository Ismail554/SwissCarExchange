import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';
import 'package:wynante/core/assets_manager.dart';
import 'package:wynante/core/widgets/common_background.dart';
import 'package:wynante/core/widgets/custom_button.dart';
import 'package:wynante/views/auth/forgot_password/successful_view.dart';

class OtpVerifyView extends StatefulWidget {
  final String email;
  const OtpVerifyView({super.key, required this.email});

  @override
  State<OtpVerifyView> createState() => _OtpVerifyViewState();
}

class _OtpVerifyViewState extends State<OtpVerifyView> {
  final TextEditingController _otpController = TextEditingController();
  bool _isOtpValid = false;

  @override
  void initState() {
    super.initState();
    _otpController.addListener(() {
      final valid = _otpController.text.length == 6;
      if (_isOtpValid != valid) {
        setState(() {
          _isOtpValid = valid;
        });
      }
    });
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56.w,
      height: 64.h,
      textStyle: TextStyle(
        fontSize: 24.sp,
        color: Colors.white,
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(
          0.04,
        ), // Consistent with CustomTextField
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(
        color: const Color(0xFFD4AF37),
        width: 1.5,
      ), // Gold accent
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        border: Border.all(color: const Color(0xFF00D5BE)), // Cyan accent
      ),
    );

    return CommonBackground(
      child: SafeArea(
        child: Column(
          children: [
            // Top Bar with Back Button
            Padding(
              padding: EdgeInsets.only(left: 16.w, top: 16.h),
              child: Align(
                alignment: Alignment.centerLeft,
                child: InkWell(
                  onTap: () => Navigator.pop(context),
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.04),
                    ),
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 20.sp,
                    ),
                  ),
                ),
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 24.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 20.h),
                    // Logo Image
                    Image.asset(
                      IconAssets.app_logo,
                      width: 250.w,
                      height: 80.h,
                    ),

                    SizedBox(height: 48.h),

                    // Title
                    Text(
                      'Verify Your Email',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32.sp,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.5,
                      ),
                    ),
                    SizedBox(height: 12.h),

                    // Subtitle
                    Text(
                      "We've sent a 6-digit code to\n${widget.email}",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: const Color(0xFFA0AABF),
                        fontSize: 15.sp,
                        height: 1.5,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 48.h),

                    // Pinput for OTP
                    Center(
                      child: Pinput(
                        length: 6,
                        controller: _otpController,
                        defaultPinTheme: defaultPinTheme,
                        focusedPinTheme: focusedPinTheme,
                        submittedPinTheme: submittedPinTheme,
                        showCursor: true,
                        onCompleted: (pin) {
                          // Optional: Auto submit here
                        },
                      ),
                    ),

                    SizedBox(height: 48.h),

                    // Resend Text
                    Column(
                      children: [
                        Text(
                          "Didn't receive the code?",
                          style: TextStyle(
                            color: const Color(0xFFA0AABF),
                            fontSize: 14.sp,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        GestureDetector(
                          onTap: () {
                            // TODO: Add resend action
                          },
                          child: Text(
                            'Resend in 60s',
                            style: TextStyle(
                              color: const Color(
                                0xFFA0AABF,
                              ), // Or secondary accent color
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 48.h),

                    // Verify Code Button
                    CustomButton(
                      text: 'Verify Code',
                      isActive: _isOtpValid,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SuccessfulView(),
                          ),
                        );
                      },
                    ),
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
