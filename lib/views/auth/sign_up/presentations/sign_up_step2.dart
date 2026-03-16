import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wynante/core/widgets/common_background.dart';
import 'package:wynante/core/widgets/custom_button.dart';
import 'package:wynante/core/widgets/custom_text_field.dart';
import 'package:wynante/views/auth/sign_up/presentations/sign_up_step3.dart';

class SignUpStep2 extends StatefulWidget {
  final String email;
  const SignUpStep2({super.key, required this.email});

  @override
  State<SignUpStep2> createState() => _SignUpStep2State();
}

class _SignUpStep2State extends State<SignUpStep2> {
  final _companyController = TextEditingController();
  final _uidController = TextEditingController();
  final _addressController = TextEditingController();
  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();
    _companyController.addListener(_validate);
    _uidController.addListener(_validate);
    _addressController.addListener(_validate);
  }

  @override
  void dispose() {
    _companyController.dispose();
    _uidController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _validate() {
    final valid = _companyController.text.trim().isNotEmpty &&
        _uidController.text.trim().isNotEmpty &&
        _addressController.text.trim().isNotEmpty;
    if (_isFormValid != valid) setState(() => _isFormValid = valid);
  }

  @override
  Widget build(BuildContext context) {
    return CommonBackground(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Back Button
            Padding(
              padding: EdgeInsets.only(left: 16.w, top: 16.h),
              child: InkWell(
                onTap: () => Navigator.pop(context),
                borderRadius: BorderRadius.circular(30),
                child: Container(
                  width: 40.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.07),
                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                  ),
                  child: Icon(Icons.arrow_back, color: Colors.white, size: 18.sp),
                ),
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
                            children: const [
                              TextSpan(
                                text: 'Step  ',
                                style: TextStyle(color: Color(0xFF00D5BE), fontWeight: FontWeight.w600),
                              ),
                              TextSpan(
                                text: '2 of 3',
                                style: TextStyle(color: Color(0xFF00D5BE), fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          'Company',
                          style: TextStyle(color: Colors.white54, fontSize: 13.sp),
                        ),
                      ],
                    ),

                    SizedBox(height: 10.h),

                    // Progress bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: 2 / 3,
                        backgroundColor: Colors.white12,
                        valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF00D5BE)),
                        minHeight: 3,
                      ),
                    ),

                    SizedBox(height: 36.h),

                    // Company Name
                    Text(
                      'Company Name',
                      style: TextStyle(color: Colors.white70, fontSize: 13.sp),
                    ),
                    SizedBox(height: 8.h),
                    CustomTextField(
                      controller: _companyController,
                      hintText: 'Premium Auto Group AG',
                      prefixIcon: const Icon(Icons.business_outlined, color: Color(0xFFA0AABF), size: 20),
                    ),

                    SizedBox(height: 20.h),

                    // UID Number
                    Text(
                      'UID Number',
                      style: TextStyle(color: Colors.white70, fontSize: 13.sp),
                    ),
                    SizedBox(height: 8.h),
                    CustomTextField(
                      controller: _uidController,
                      hintText: 'CHE-123.456.789',
                      prefixIcon: const Icon(Icons.business_center_outlined, color: Color(0xFFA0AABF), size: 20),
                    ),

                    SizedBox(height: 20.h),

                    // Address
                    Text(
                      'Address',
                      style: TextStyle(color: Colors.white70, fontSize: 13.sp),
                    ),
                    SizedBox(height: 8.h),
                    CustomTextField(
                      controller: _addressController,
                      hintText: 'Streets, ZIP, City',
                      prefixIcon: const Icon(Icons.location_on_outlined, color: Color(0xFFA0AABF), size: 20),
                    ),

                    SizedBox(height: 40.h),

                    // Continue Button
                    CustomButton(
                      text: 'Continue',
                      isActive: _isFormValid,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => SignUpStep3(email: widget.email)),
                        );
                      },
                    ),

                    SizedBox(height: 20.h),
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