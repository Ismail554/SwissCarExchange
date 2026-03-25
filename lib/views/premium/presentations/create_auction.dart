import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rionydo/core/constants/font_manager.dart';
import 'package:rionydo/core/utils/app_colors.dart';
import 'package:rionydo/core/widgets/common_background.dart';
import 'package:rionydo/core/widgets/custom_back_button.dart';
import 'package:rionydo/core/widgets/custom_button.dart';
import 'package:rionydo/core/widgets/custom_text_field.dart';

class CreateAuction extends StatefulWidget {
  const CreateAuction({super.key});

  @override
  State<CreateAuction> createState() => _CreateAuctionState();
}

class _CreateAuctionState extends State<CreateAuction> {
  final _formKey = GlobalKey<FormState>();
  final _imagePicker = ImagePicker();

  // Controllers
  final _titleController = TextEditingController();
  final _brandController = TextEditingController();
  final _modelController = TextEditingController();
  final _yearController = TextEditingController();
  final _mileageController = TextEditingController();
  final _vinController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _reservePriceController = TextEditingController();
  final _buyNowPriceController = TextEditingController();

  // State
  final List<File> _imageFiles = [];
  File? _videoFile;
  List<File> _documentFiles = [];
  String _selectedDuration = '';

  static const int _maxImages = 20;
  static const int _maxVideoSizeMB = 50;

  @override
  void dispose() {
    _titleController.dispose();
    _brandController.dispose();
    _modelController.dispose();
    _yearController.dispose();
    _mileageController.dispose();
    _vinController.dispose();
    _descriptionController.dispose();
    _reservePriceController.dispose();
    _buyNowPriceController.dispose();
    super.dispose();
  }

  // ═══════════════════════════════════════════════
  // PICKER LOGIC
  // ═══════════════════════════════════════════════

  /// Shows a bottom sheet to choose between Camera and Gallery
  void _pickImages() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.sceCardBg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _sheetHandle(),
              SizedBox(height: 16.h),
              Text(
                "Add Images",
                style: FontManager.heading3(color: Colors.white),
              ),
              SizedBox(height: 16.h),
              _sheetOption(
                icon: Icons.camera_alt_outlined,
                label: "Take Photo",
                onTap: () {
                  Navigator.pop(ctx);
                  _pickImageFromCamera();
                },
              ),
              _sheetOption(
                icon: Icons.photo_library_outlined,
                label: "Choose from Gallery",
                onTap: () {
                  Navigator.pop(ctx);
                  _pickImagesFromGallery();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickImageFromCamera() async {
    if (_imageFiles.length >= _maxImages) {
      _showLimitSnackbar("Maximum $_maxImages images allowed");
      return;
    }

    final XFile? photo = await _imagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
      maxWidth: 1920,
      maxHeight: 1920,
    );

    if (photo != null) {
      setState(() => _imageFiles.add(File(photo.path)));
    }
  }

  Future<void> _pickImagesFromGallery() async {
    final remaining = _maxImages - _imageFiles.length;
    if (remaining <= 0) {
      _showLimitSnackbar("Maximum $_maxImages images allowed");
      return;
    }

    final List<XFile> photos = await _imagePicker.pickMultiImage(
      imageQuality: 85,
      maxWidth: 1920,
      maxHeight: 1920,
    );

    if (photos.isNotEmpty) {
      final toAdd = photos.take(remaining).map((x) => File(x.path)).toList();
      setState(() => _imageFiles.addAll(toAdd));

      if (photos.length > remaining) {
        _showLimitSnackbar(
          "Only $remaining more image(s) could be added (max $_maxImages)",
        );
      }
    }
  }

  /// Video picker — allows gallery or camera, enforces 50 MB limit
  void _pickVideo() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.sceCardBg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _sheetHandle(),
              SizedBox(height: 16.h),
              Text(
                "Showcase Video",
                style: FontManager.heading3(color: Colors.white),
              ),
              SizedBox(height: 16.h),
              _sheetOption(
                icon: Icons.videocam_outlined,
                label: "Record Video",
                onTap: () {
                  Navigator.pop(ctx);
                  _pickVideoFromSource(ImageSource.camera);
                },
              ),
              _sheetOption(
                icon: Icons.video_library_outlined,
                label: "Choose from Gallery",
                onTap: () {
                  Navigator.pop(ctx);
                  _pickVideoFromSource(ImageSource.gallery);
                },
              ),
              if (_videoFile != null)
                _sheetOption(
                  icon: Icons.delete_outline,
                  label: "Remove Current Video",
                  color: AppColors.errorRed,
                  onTap: () {
                    Navigator.pop(ctx);
                    setState(() => _videoFile = null);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickVideoFromSource(ImageSource source) async {
    final XFile? video = await _imagePicker.pickVideo(
      source: source,
      maxDuration: const Duration(minutes: 5),
    );

    if (video != null) {
      final file = File(video.path);
      final sizeInBytes = await file.length();
      final sizeInMB = sizeInBytes / (1024 * 1024);

      if (sizeInMB > _maxVideoSizeMB) {
        if (mounted) {
          _showLimitSnackbar(
            "Video too large (${sizeInMB.toStringAsFixed(1)} MB). Max ${_maxVideoSizeMB} MB.",
          );
        }
        return;
      }

      setState(() => _videoFile = file);
    }
  }

  /// Document picker — PDF, DOC, DOCX, XLS, XLSX, images
  Future<void> _pickDocuments() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: [
        'pdf',
        'doc',
        'docx',
        'xls',
        'xlsx',
        'jpg',
        'jpeg',
        'png',
        'webp',
      ],
    );

    if (result != null && result.files.isNotEmpty) {
      final files = result.files
          .where((f) => f.path != null)
          .map((f) => File(f.path!))
          .toList();
      setState(() => _documentFiles.addAll(files));
    }
  }

  void _showLimitSnackbar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: FontManager.bodySmall(color: Colors.white),
        ),
        backgroundColor: AppColors.errorRed,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  // ═══════════════════════════════════════════════
  // BUILD
  // ═══════════════════════════════════════════════

  @override
  Widget build(BuildContext context) {
    return CommonBackground(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const CustomBackButton(),
        title: Text(
          "Create Auction",
          style: FontManager.displaySmall(color: Colors.white),
        ),
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16.h),

              // ── VEHICLE INFORMATION ──
              _buildSectionHeader("VEHICLE INFORMATION"),
              SizedBox(height: 12.h),

              CustomTextField(
                hintText: "Auction Title",
                controller: _titleController,
              ),
              SizedBox(height: 12.h),

              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      hintText: "Brand",
                      controller: _brandController,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: CustomTextField(
                      hintText: "Model",
                      controller: _modelController,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),

              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      hintText: "Year",
                      controller: _yearController,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: CustomTextField(
                      hintText: "Mileage (km)",
                      controller: _mileageController,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),

              CustomTextField(
                hintText: "VIN Number",
                controller: _vinController,
              ),
              SizedBox(height: 12.h),

              _buildDescriptionField(),
              SizedBox(height: 28.h),

              // ── MEDIA & DOCUMENTS ──
              _buildSectionHeader("MEDIA & DOCUMENTS"),
              SizedBox(height: 16.h),

              _buildMediaSubLabel(
                Icons.image_outlined,
                "Images (${_imageFiles.length}/$_maxImages)",
              ),
              SizedBox(height: 10.h),
              _buildImagePicker(),
              SizedBox(height: 20.h),

              _buildMediaSubLabel(Icons.videocam_outlined, "Showcase Video"),
              SizedBox(height: 10.h),
              _buildVideoSection(),
              SizedBox(height: 20.h),

              _buildMediaSubLabel(
                Icons.description_outlined,
                "Documents (Inspection, Service)",
              ),
              SizedBox(height: 10.h),
              _buildDocumentsSection(),
              SizedBox(height: 28.h),

              // ── PRICING & DURATION ──
              _buildSectionHeader("PRICING & DURATION"),
              SizedBox(height: 12.h),

              Text(
                "Reserve Price (Minimum)",
                style: FontManager.bodySmall(color: AppColors.sceGreyA0),
              ),
              SizedBox(height: 8.h),
              _buildPriceField(
                controller: _reservePriceController,
                hint: "CHF",
              ),
              SizedBox(height: 16.h),

              Text(
                "Buy Now Price (Optional)",
                style: FontManager.bodySmall(color: AppColors.sceGreyA0),
              ),
              SizedBox(height: 8.h),
              _buildPriceField(controller: _buyNowPriceController, hint: "CHF"),
              SizedBox(height: 16.h),

              Text(
                "Auction Duration",
                style: FontManager.bodySmall(color: AppColors.sceGreyA0),
              ),
              SizedBox(height: 8.h),
              _buildDurationPicker(),
              SizedBox(height: 32.h),

              // ── PUBLISH BUTTON ──
              CustomButton(text: "🔒  Publish Auction", onPressed: _onPublish),
              SizedBox(height: 32.h),
            ],
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════
  // SECTION WIDGETS
  // ═══════════════════════════════════════════════

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: FontManager.labelSmall(color: AppColors.sceGreyA0).copyWith(
        letterSpacing: 1.5,
        fontSize: 11.sp,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildMediaSubLabel(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, color: AppColors.sceGreyA0, size: 18.sp),
        SizedBox(width: 6.w),
        Text(label, style: FontManager.bodySmall(color: AppColors.sceGreyA0)),
      ],
    );
  }

  Widget _buildDescriptionField() {
    return TextFormField(
      controller: _descriptionController,
      maxLines: 4,
      style: const TextStyle(color: Colors.white, fontSize: 14),
      decoration: InputDecoration(
        hintText: "Description",
        hintStyle: TextStyle(color: AppColors.sceGreyA0, fontSize: 14.sp),
        filled: true,
        fillColor: Colors.white.withOpacity(0.04),
        contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.08)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(
            color: AppColors.sceOnboardingGold,
            width: 1.5,
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════
  // IMAGE PICKER UI
  // ═══════════════════════════════════════════════

  Widget _buildImagePicker() {
    return Wrap(
      spacing: 10.w,
      runSpacing: 10.h,
      children: [
        ..._imageFiles.asMap().entries.map(
          (e) => _buildImageTile(e.key, e.value),
        ),
        if (_imageFiles.length < _maxImages)
          GestureDetector(
            onTap: _pickImages,
            child: Container(
              width: 72.w,
              height: 72.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: Colors.white.withOpacity(0.12),
                  width: 1.5,
                ),
                color: Colors.white.withOpacity(0.04),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add, color: AppColors.sceGreyA0, size: 24.sp),
                  SizedBox(height: 2.h),
                  Text(
                    "Add",
                    style: FontManager.labelSmall(
                      color: AppColors.sceGreyA0,
                    ).copyWith(fontSize: 10.sp),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildImageTile(int index, File file) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12.r),
          child: Container(
            width: 72.w,
            height: 72.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Image.file(file, fit: BoxFit.cover),
          ),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: () => setState(() => _imageFiles.removeAt(index)),
            child: Container(
              padding: const EdgeInsets.all(3),
              decoration: const BoxDecoration(
                color: Colors.black54,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.close, color: Colors.white, size: 12.sp),
            ),
          ),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════
  // VIDEO SECTION
  // ═══════════════════════════════════════════════

  Widget _buildVideoSection() {
    if (_videoFile != null) {
      return _buildSelectedFileCard(
        icon: Icons.videocam,
        fileName: _videoFile!.path.split(Platform.pathSeparator).last,
        fileSize: _videoFile!.lengthSync(),
        onRemove: () => setState(() => _videoFile = null),
        onReplace: _pickVideo,
      );
    }

    return _buildUploadButton(
      icon: Icons.cloud_upload_outlined,
      label: "Upload Video",
      subtitle: "Max ${_maxVideoSizeMB}MB • MP4, MOV",
      onTap: _pickVideo,
    );
  }

  // ═══════════════════════════════════════════════
  // DOCUMENTS SECTION
  // ═══════════════════════════════════════════════

  Widget _buildDocumentsSection() {
    return Column(
      children: [
        ..._documentFiles.asMap().entries.map(
          (e) => Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: _buildSelectedFileCard(
              icon: _docIcon(e.value.path),
              fileName: e.value.path.split(Platform.pathSeparator).last,
              fileSize: e.value.lengthSync(),
              onRemove: () => setState(() => _documentFiles.removeAt(e.key)),
            ),
          ),
        ),
        _buildUploadButton(
          icon: Icons.cloud_upload_outlined,
          label: "Upload Documents",
          subtitle: "PDF, DOC, DOCX, XLS, Images",
          onTap: _pickDocuments,
        ),
      ],
    );
  }

  IconData _docIcon(String path) {
    final ext = path.split('.').last.toLowerCase();
    switch (ext) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'doc':
      case 'docx':
        return Icons.article_outlined;
      case 'xls':
      case 'xlsx':
        return Icons.table_chart_outlined;
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'webp':
        return Icons.image_outlined;
      default:
        return Icons.insert_drive_file_outlined;
    }
  }

  // ═══════════════════════════════════════════════
  // SHARED WIDGETS
  // ═══════════════════════════════════════════════

  /// Card showing a selected file with name, size, and remove action
  Widget _buildSelectedFileCard({
    required IconData icon,
    required String fileName,
    required int fileSize,
    required VoidCallback onRemove,
    VoidCallback? onReplace,
  }) {
    final sizeMB = (fileSize / (1024 * 1024)).toStringAsFixed(1);
    return GestureDetector(
      onTap: onReplace,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: AppColors.sceTealStatBg,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.sceTeal.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: AppColors.sceTeal.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(icon, color: AppColors.sceTeal, size: 22.sp),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fileName,
                    style: FontManager.labelMedium(
                      color: Colors.white,
                    ).copyWith(fontSize: 13.sp),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    "$sizeMB MB",
                    style: FontManager.labelSmall(
                      color: AppColors.sceGreyA0,
                    ).copyWith(fontSize: 11.sp),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: onRemove,
              child: Container(
                padding: EdgeInsets.all(6.w),
                decoration: BoxDecoration(
                  color: AppColors.errorRed.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.close,
                  color: AppColors.errorRed,
                  size: 16.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    String? subtitle,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 14.h),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.04),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.white.withOpacity(0.08)),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: AppColors.sceGreyA0, size: 20.sp),
                SizedBox(width: 8.w),
                Text(
                  label,
                  style: FontManager.labelMedium(color: AppColors.sceGreyA0),
                ),
              ],
            ),
            if (subtitle != null) ...[
              SizedBox(height: 4.h),
              Text(
                subtitle,
                style: FontManager.labelSmall(
                  color: AppColors.sceGreyA0,
                ).copyWith(fontSize: 10.sp),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════
  // PRICE & DURATION
  // ═══════════════════════════════════════════════

  Widget _buildPriceField({
    required TextEditingController controller,
    required String hint,
  }) {
    return CustomTextField(
      hintText: hint,
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      textInputAction: TextInputAction.done,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
      ],
      prefixIcon: Padding(
        padding: EdgeInsets.only(left: 16.w, right: 8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "\$",
              style: FontManager.bodyMedium(color: AppColors.sceGreyA0),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDurationPicker() {
    return GestureDetector(
      onTap: () => _showDurationSheet(),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.04),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.white.withOpacity(0.08)),
        ),
        child: Row(
          children: [
            Icon(Icons.schedule, color: AppColors.sceGreyA0, size: 20.sp),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                _selectedDuration.isEmpty
                    ? "Select duration"
                    : _selectedDuration,
                style: FontManager.bodySmall(
                  color: _selectedDuration.isEmpty
                      ? AppColors.sceGreyA0
                      : Colors.white,
                ),
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppColors.sceGreyA0,
              size: 22.sp,
            ),
          ],
        ),
      ),
    );
  }

  void _showDurationSheet() {
    final durations = ["3 Days", "5 Days", "7 Days", "10 Days", "14 Days"];
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.sceCardBg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 16.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _sheetHandle(),
                SizedBox(height: 16.h),
                Text(
                  "Auction Duration",
                  style: FontManager.heading3(color: Colors.white),
                ),
                SizedBox(height: 8.h),
                ...durations.map(
                  (d) => ListTile(
                    title: Text(
                      d,
                      style: FontManager.bodyMedium(
                        color: _selectedDuration == d
                            ? AppColors.sceTeal
                            : Colors.white,
                      ),
                    ),
                    trailing: _selectedDuration == d
                        ? Icon(
                            Icons.check_circle,
                            color: AppColors.sceTeal,
                            size: 22.sp,
                          )
                        : null,
                    onTap: () {
                      setState(() => _selectedDuration = d);
                      Navigator.pop(ctx);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ═══════════════════════════════════════════════
  // SHARED BOTTOM SHEET HELPERS
  // ═══════════════════════════════════════════════

  Widget _sheetHandle() {
    return Container(
      width: 40.w,
      height: 4.h,
      decoration: BoxDecoration(
        color: Colors.white24,
        borderRadius: BorderRadius.circular(2.r),
      ),
    );
  }

  Widget _sheetOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? color,
  }) {
    final c = color ?? Colors.white;
    return ListTile(
      leading: Icon(icon, color: c, size: 24.sp),
      title: Text(label, style: FontManager.bodyMedium(color: c)),
      onTap: onTap,
    );
  }

  // ═══════════════════════════════════════════════
  // PUBLISH
  // ═══════════════════════════════════════════════

  void _onPublish() {
    if (_formKey.currentState?.validate() ?? false) {
      // TODO: Submit auction data
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Auction published successfully!",
            style: FontManager.bodySmall(color: Colors.white),
          ),
          backgroundColor: AppColors.sceTeal,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }
}
