import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:rionydo/app_utils/utils/app_colors.dart';
import 'package:rionydo/controllers/auth/register_provider.dart';
import 'package:rionydo/core/widgets/common_background.dart';
import 'package:rionydo/core/widgets/custom_button.dart';
import 'package:rionydo/core/widgets/custom_text_field.dart';
import 'package:rionydo/core/widgets/custom_back_button.dart';
import 'package:rionydo/views/auth/sign_up/presentations/sign_up_step3.dart';

enum UserRole { individual, company }

class SignUpStep2 extends StatefulWidget {
  final String email;
  final String password;
  final String phone;
  const SignUpStep2({
    super.key,
    required this.email,
    required this.password,
    required this.phone,
  });

  @override
  State<SignUpStep2> createState() => _SignUpStep2State();
}

class _SignUpStep2State extends State<SignUpStep2> {
  // ── Tab / Role ─────────────────────────────────────────
  late PageController _pageController;

  bool _isFormValid = false;
  final _imagePicker = ImagePicker();

  // ── Lifecycle ──────────────────────────────────────────
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<RegisterProvider>();
      _pageController = PageController(
        initialPage: provider.selectedRole.index,
      );
      for (final c in _allControllers(provider)) {
        c.addListener(_validate);
      }
      // Ensure the provider notifies changes when it changes files so that validate can run.
      provider.addListener(_validate);
      setState(() {});
      _validate();
    });
  }

  @override
  void dispose() {
    final provider = context.read<RegisterProvider>();
    provider.removeListener(_validate);
    for (final c in _allControllers(provider)) {
      c.removeListener(_validate);
    }
    _pageController.dispose();
    super.dispose();
  }

  List<TextEditingController> _allControllers(RegisterProvider provider) => [
    provider.nameController,
    provider.individualAddressController,
    provider.companyController,
    provider.uidController,
    provider.companyAddressController,
  ];

  // ── Validation ─────────────────────────────────────────
  void _validate() {
    if (!mounted) return;
    final provider = context.read<RegisterProvider>();
    final valid = provider.selectedRole == UserRole.individual
        ? provider.nameController.text.trim().isNotEmpty &&
              provider.individualAddressController.text.trim().isNotEmpty &&
              provider.idFile != null
        : provider.companyController.text.trim().isNotEmpty &&
              provider.uidController.text.trim().isNotEmpty &&
              provider.companyAddressController.text.trim().isNotEmpty;

    if (_isFormValid != valid) setState(() => _isFormValid = valid);
  }

  // ── Tab switching ──────────────────────────────────────
  void _switchRole(UserRole role) {
    final provider = context.read<RegisterProvider>();
    if (provider.selectedRole == role) return;
    provider.setRole(role);
    setState(() {
      _isFormValid = false;
    });
    _pageController.animateToPage(
      role.index,
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeInOut,
    );
    _validate();
  }

  void _onPageChanged(int index) {
    final provider = context.read<RegisterProvider>();
    final role = UserRole.values[index];
    if (provider.selectedRole != role) {
      provider.setRole(role);
      setState(() {
        _isFormValid = false;
      });
      _validate();
    }
  }

  // ── File picking ───────────────────────────────────────
  Future<void> _showPickerOptions() async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _PickerSheet(
        onCamera: () => _pickFromSource(ImageSource.camera),
        onGallery: () => _pickFromSource(ImageSource.gallery),
        onFile: _pickFromFiles,
      ),
    );
  }

  Future<void> _pickFromSource(ImageSource source) async {
    Navigator.pop(context);
    final picked = await _imagePicker.pickImage(
      source: source,
      imageQuality: 85,
    );
    if (picked != null) _setFile(File(picked.path), picked.name, isImage: true);
  }

  Future<void> _pickFromFiles() async {
    Navigator.pop(context);
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
    );
    if (result == null || result.files.single.path == null) return;
    final f = result.files.single;
    final ext = f.extension?.toLowerCase() ?? '';
    _setFile(
      File(f.path!),
      f.name,
      isImage: const ['jpg', 'jpeg', 'png'].contains(ext),
    );
  }

  void _setFile(File file, String name, {required bool isImage}) {
    context.read<RegisterProvider>().setIdFile(file, name, isImage);
    _validate();
  }

  void _removeFile() {
    context.read<RegisterProvider>().setIdFile(null, null, false);
    _validate();
  }

  // ── Build ──────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final teal = AppColors.sceTeal;
    return CommonBackground(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Back button
            Padding(
              padding: EdgeInsets.only(left: 16.w, top: 16.h),
              child: Align(
                alignment: Alignment.centerLeft,
                child: const CustomBackButton(),
              ),
            ),

            Expanded(
              child: Consumer<RegisterProvider>(
                builder: (context, provider, _) {
                  if (!mounted) return const SizedBox.shrink();
                  // Check if pageController is initialized
                  try {
                    _pageController.hasClients;
                  } catch (e) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.w,
                      vertical: 20.h,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildStepHeader(provider),
                        SizedBox(height: 10.h),
                        _buildProgressBar(),
                        SizedBox(height: 28.h),

                        // ── Role toggle ──────────────────────
                        _RoleToggle(
                          selected: provider.selectedRole,
                          onChanged: _switchRole,
                        ),
                        SizedBox(height: 28.h),

                        // ── PageView forms ───────────────────
                        // Intrinsic height wraps the PageView so it sizes
                        // to the tallest child without a fixed height.
                        _PageViewForms(
                          pageController: _pageController,
                          onPageChanged: _onPageChanged,
                          individualForm: _IndividualForm(
                            nameController: provider.nameController,
                            addressController:
                                provider.individualAddressController,
                            idFile: provider.idFile,
                            idFileName: provider.idFileName,
                            isImage: provider.isIdImage,
                            onPickFile: _showPickerOptions,
                            onRemoveFile: _removeFile,
                          ),
                          companyForm: _CompanyForm(
                            companyController: provider.companyController,
                            uidController: provider.uidController,
                            addressController:
                                provider.companyAddressController,
                          ),
                        ),

                        SizedBox(height: 40.h),

                        CustomButton(
                          text: 'Continue',
                          isActive: _isFormValid,
                          onPressed: () {
                            FocusScope.of(context).unfocus();

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => SignUpStep3(
                                  email: widget.email,
                                  password: widget.password,
                                  phone: widget.phone,
                                  role: provider.selectedRole,

                                  // Individual
                                  fullName: provider.nameController.text.trim(),
                                  address:
                                      provider.selectedRole ==
                                          UserRole.individual
                                      ? provider
                                            .individualAddressController
                                            .text
                                            .trim()
                                      : provider.companyAddressController.text
                                            .trim(),
                                  idDocumentFile: provider.idFile,

                                  // Company
                                  company: provider.companyController.text
                                      .trim(),
                                  uid: provider.uidController.text.trim(),
                                ),
                              ),
                            );
                          },
                        ),

                        SizedBox(height: 20.h),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepHeader(RegisterProvider provider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        RichText(
          text: TextSpan(
            style: TextStyle(fontSize: 13.sp),
            children: const [
              TextSpan(
                text: 'Step  ',
                style: TextStyle(
                  color: AppColors.sceTeal,
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextSpan(
                text: '2 of 3',
                style: TextStyle(
                  color: AppColors.sceTeal,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: Text(
            key: ValueKey(provider.selectedRole),
            provider.selectedRole == UserRole.individual
                ? 'Individual'
                : 'Company',
            style: TextStyle(color: Colors.white54, fontSize: 13.sp),
          ),
        ),
      ],
    );
  }

  Widget _buildProgressBar() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: LinearProgressIndicator(
        value: 2 / 3,
        backgroundColor: Colors.white12,
        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.sceTeal),
        minHeight: 3,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// PageView wrapper — sizes itself to its tallest child
// ─────────────────────────────────────────────────────────
class _PageViewForms extends StatelessWidget {
  final PageController pageController;
  final ValueChanged<int> onPageChanged;
  final Widget individualForm;
  final Widget companyForm;

  const _PageViewForms({
    required this.pageController,
    required this.onPageChanged,
    required this.individualForm,
    required this.companyForm,
  });

  @override
  Widget build(BuildContext context) {
    // We use a fixed-height trick: ConstrainedBox + PageView.
    // The children are IgnorePointer-safe and physics is locked to prevent
    // accidental swipe (the toggle drives navigation).
    return SizedBox(
      // Enough height for either form; increased to 430.h to prevent overflow.
      height: 430.h,
      child: PageView(
        controller: pageController,
        onPageChanged: onPageChanged,
        physics: const ClampingScrollPhysics(),
        children: [individualForm, companyForm],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// Role Toggle — sliding pill indicator
// ─────────────────────────────────────────────────────────
class _RoleToggle extends StatelessWidget {
  final UserRole selected;
  final ValueChanged<UserRole> onChanged;

  const _RoleToggle({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52.h,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
      ),
      child: Stack(
        children: [
          // ── Sliding pill ─────────────────────────
          AnimatedAlign(
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeInOutCubic,
            alignment: selected == UserRole.individual
                ? Alignment.centerLeft
                : Alignment.centerRight,
            child: FractionallySizedBox(
              widthFactor: 0.5,
              heightFactor:
                  1.0, // Forces the pill to match the container's height
              child: Container(
                margin: EdgeInsets.all(4.r),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.sceTeal,
                      AppColors.sceTeal.withOpacity(0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.sceTeal.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Labels (above the pill) ──────────────
          Positioned.fill(
            child: Row(
              crossAxisAlignment:
                  CrossAxisAlignment.stretch, // Stretch children to fill height
              children: UserRole.values.map((role) {
                final isSelected = selected == role;
                final contentColor = isSelected ? Colors.white : Colors.white38;

                return Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior
                        .opaque, // Ensure entire area is tappable
                    onTap: () => onChanged(role),
                    child: Center(
                      // Centers the content vertically and horizontally
                      child: AnimatedScale(
                        scale: isSelected ? 1.0 : 0.98,
                        duration: const Duration(milliseconds: 200),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TweenAnimationBuilder<Color?>(
                              duration: const Duration(milliseconds: 300),
                              tween: ColorTween(
                                begin: contentColor,
                                end: contentColor,
                              ),
                              builder: (context, color, _) {
                                return Icon(
                                  role == UserRole.individual
                                      ? Icons.person_outline_rounded
                                      : Icons.business_outlined,
                                  size: 19.sp,
                                  color: color,
                                );
                              },
                            ),
                            SizedBox(width: 8.w),
                            AnimatedDefaultTextStyle(
                              duration: const Duration(milliseconds: 300),
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: isSelected
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                                color: contentColor,
                                letterSpacing: 0.2,
                              ),
                              child: Text(
                                role == UserRole.individual
                                    ? 'Individual'
                                    : 'Company',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// Individual Form
// ─────────────────────────────────────────────────────────
class _IndividualForm extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController addressController;
  final File? idFile;
  final String? idFileName;
  final bool isImage;
  final VoidCallback onPickFile;
  final VoidCallback onRemoveFile;

  const _IndividualForm({
    required this.nameController,
    required this.addressController,
    required this.idFile,
    required this.idFileName,
    required this.isImage,
    required this.onPickFile,
    required this.onRemoveFile,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _LabeledField(
          textInputAction: .next,
          label: 'Full Name',
          controller: nameController,
          hintText: 'Enter your Full Name',
          icon: Icons.person_outline_rounded,
        ),
        SizedBox(height: 20.h),

        _FieldLabel('NID / Passport'),
        SizedBox(height: 8.h),
        _FilePickerField(
          idFile: idFile,
          idFileName: idFileName,
          isImage: isImage,
          onTap: onPickFile,
          onRemove: onRemoveFile,
        ),
        SizedBox(height: 20.h),

        _LabeledField(
          textInputAction: .done,
          label: 'Address',
          controller: addressController,
          hintText: 'Street, ZIP, City',
          icon: Icons.location_on_outlined,
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────
// Company Form
// ─────────────────────────────────────────────────────────
class _CompanyForm extends StatelessWidget {
  final TextEditingController companyController;
  final TextEditingController uidController;
  final TextEditingController addressController;

  const _CompanyForm({
    required this.companyController,
    required this.uidController,
    required this.addressController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _LabeledField(
          label: 'Company Name',
          controller: companyController,
          hintText: 'Premium Auto Group AG',
          icon: Icons.business_outlined,
        ),
        SizedBox(height: 20.h),

        _LabeledField(
          label: 'UID Number',
          controller: uidController,
          hintText: 'CHE-123.456.789',
          icon: Icons.business_center_outlined,
        ),
        SizedBox(height: 20.h),

        _LabeledField(
          label: 'Address',
          controller: addressController,
          hintText: 'Street, ZIP, City',
          icon: Icons.location_on_outlined,
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────
// Shared: Label + TextField combined (reduces repetition)
// ─────────────────────────────────────────────────────────
class _LabeledField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final TextInputAction textInputAction;

  const _LabeledField({
    required this.label,
    required this.controller,
    required this.hintText,
    required this.icon,
    this.textInputAction = TextInputAction.next,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _FieldLabel(label),
        SizedBox(height: 8.h),
        CustomTextField(
          textInputAction: textInputAction,
          controller: controller,
          hintText: hintText,
          prefixIcon: Icon(icon, color: AppColors.sceGreyA0, size: 20),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────
// Shared: Field Label
// ─────────────────────────────────────────────────────────
class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: TextStyle(color: Colors.white70, fontSize: 13.sp),
  );
}

// ─────────────────────────────────────────────────────────
// File Picker Field
// ─────────────────────────────────────────────────────────
class _FilePickerField extends StatelessWidget {
  final File? idFile;
  final String? idFileName;
  final bool isImage;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  const _FilePickerField({
    required this.idFile,
    required this.idFileName,
    required this.isImage,
    required this.onTap,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final hasFile = idFile != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ── Tap row ───────────────────────────────────
        GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 52.h,
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            decoration: BoxDecoration(
              color: hasFile
                  ? AppColors.sceTeal.withOpacity(0.10)
                  : Colors.white.withOpacity(0.06),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: hasFile
                    ? AppColors.sceTeal.withOpacity(0.5)
                    : Colors.white24,
                width: 1.2,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  hasFile
                      ? Icons.check_circle_outline_rounded
                      : Icons.upload_file_outlined,
                  color: hasFile ? AppColors.sceTeal : AppColors.sceGreyA0,
                  size: 20,
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Text(
                    hasFile ? idFileName! : 'Camera, Gallery or PDF file',
                    style: TextStyle(
                      color: hasFile ? Colors.white : Colors.white38,
                      fontSize: 13.sp,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                if (!hasFile)
                  Text(
                    'Upload',
                    style: TextStyle(
                      color: AppColors.sceTeal,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                else ...[
                  GestureDetector(
                    onTap: onTap,
                    child: Icon(
                      Icons.edit_outlined,
                      color: AppColors.sceTeal,
                      size: 16,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  GestureDetector(
                    onTap: onRemove,
                    child: Icon(
                      Icons.close_rounded,
                      color: Colors.white38,
                      size: 16,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),

        // ── Image thumbnail ───────────────────────────
        if (hasFile && isImage) ...[
          SizedBox(height: 10.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: Stack(
              children: [
                Image.file(
                  idFile!,
                  height: 130.h,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 40.h,
                    alignment: Alignment.bottomLeft,
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withOpacity(0.55),
                          Colors.transparent,
                        ],
                      ),
                    ),
                    child: Text(
                      idFileName ?? '',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 11.sp,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],

        // ── Hint ─────────────────────────────────────
        if (!hasFile) ...[
          SizedBox(height: 6.h),
          Text(
            'Accepted: JPG, PNG, PDF — max 5MB',
            style: TextStyle(color: Colors.white24, fontSize: 11.sp),
          ),
        ],
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────
// Bottom Sheet — Picker Options
// ─────────────────────────────────────────────────────────
class _PickerSheet extends StatelessWidget {
  final VoidCallback onCamera;
  final VoidCallback onGallery;
  final VoidCallback onFile;

  const _PickerSheet({
    required this.onCamera,
    required this.onGallery,
    required this.onFile,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2230),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Upload ID / Passport',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            'Choose how you want to provide your document',
            style: TextStyle(color: Colors.white38, fontSize: 12.sp),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20.h),
          Row(
            children: [
              _SheetOption(
                icon: Icons.camera_alt_outlined,
                label: 'Camera',
                onTap: onCamera,
              ),
              SizedBox(width: 10.w),
              _SheetOption(
                icon: Icons.photo_library_outlined,
                label: 'Gallery',
                onTap: onGallery,
              ),
              SizedBox(width: 10.w),
              _SheetOption(
                icon: Icons.insert_drive_file_outlined,
                label: 'Files\n(PDF)',
                onTap: onFile,
              ),
            ],
          ),
          SizedBox(height: 14.h),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Colors.white38,
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

class _SheetOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SheetOption({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 16.h),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.06),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: Colors.white12),
          ),
          child: Column(
            children: [
              Icon(icon, color: AppColors.sceTeal, size: 26),
              SizedBox(height: 8.h),
              Text(
                label,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12.sp,
                  height: 1.3.h,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
