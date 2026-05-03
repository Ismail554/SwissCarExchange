import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rionydo/app_utils/utils/app_colors.dart';
import 'package:pinput/pinput.dart';
import 'package:rionydo/app_utils/utils/assets_manager.dart';
import 'package:rionydo/core/widgets/common_background.dart';
import 'package:rionydo/core/widgets/custom_button.dart';
import 'package:rionydo/core/widgets/custom_back_button.dart';
import 'package:provider/provider.dart';
import 'package:rionydo/controllers/auth/auth_provider.dart';

class OtpVerifyView extends StatefulWidget {
  final String email;
  const OtpVerifyView({super.key, required this.email});

  @override
  State<OtpVerifyView> createState() => _OtpVerifyViewState();
}

class _OtpVerifyViewState extends State<OtpVerifyView> {
  final TextEditingController _otpController = TextEditingController();
  bool _isOtpValid = false;

  // --- Resend countdown ---
  static const int _countdownStart = 60;
  int _secondsLeft = _countdownStart;
  bool _canResend = false;
  bool _isResending = false;
  Timer? _timer;

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
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() {
      _secondsLeft = _countdownStart;
      _canResend = false;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      setState(() {
        if (_secondsLeft > 1) {
          _secondsLeft--;
        } else {
          _secondsLeft = 0;
          _canResend = true;
          t.cancel();
        }
      });
    });
  }

  Future<void> _resendOtp() async {
    if (!_canResend || _isResending) return;
    
    setState(() => _isResending = true);
    final success = await context.read<AuthProvider>().resendOtp(context, email: widget.email);
    if (mounted) {
      setState(() => _isResending = false);
      if (success) {
        _startTimer();
      }
    }
  }

  @override
  void dispose() {
    _otpController.dispose();
    _timer?.cancel();
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
        color: AppColors.sceOnboardingGold,
        width: 1.5,
      ), // Gold accent
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        border: Border.all(color: AppColors.sceTeal), // Cyan accent
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
                child: const CustomBackButton(),
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
                      "We've sent a 6-digit code to",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: AppColors.sceGreyA0,
                        fontSize: 15.sp,
                        height: 1.5,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      widget.email,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: AppColors.sceTeal,
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
                            color: AppColors.sceGreyA0,
                            fontSize: 14.sp,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        GestureDetector(
                          onTap: (_canResend && !_isResending) ? _resendOtp : null,
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: _isResending
                                ? SizedBox(
                                    height: 16.h,
                                    width: 16.h,
                                    child: const CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: AppColors.sceTeal,
                                    ),
                                  )
                                : _canResend
                                    ? Text(
                                        'Resend Code',
                                        key: const ValueKey('resend'),
                                        style: TextStyle(
                                          color: AppColors.sceTeal,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      )
                                    : Text(
                                        'Resend in ${_secondsLeft}s',
                                        key: const ValueKey('countdown'),
                                        style: TextStyle(
                                          color: AppColors.sceGreyA0,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
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
                      isLoading: context.watch<AuthProvider>().isLoading,
                      onPressed: () {
                        context.read<AuthProvider>().verifyOtp(
                          context,
                          email: widget.email,
                          otp: _otpController.text,
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
