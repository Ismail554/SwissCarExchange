import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import 'package:rionydo/app_utils/constants/font_manager.dart';
import 'package:rionydo/app_utils/utils/app_colors.dart';
import 'package:rionydo/core/widgets/common_background.dart';
import 'package:rionydo/core/widgets/custom_back_button.dart';
import 'package:rionydo/core/widgets/custom_button.dart';
import '../widgets/create_auction_helpers.dart';
import '../widgets/vehicle_info_fields.dart';
import '../widgets/media_selection_section.dart';
import '../widgets/pricing_duration_section.dart';
import 'package:rionydo/controllers/auctions/create_auctions_provider.dart';

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
  final _carCategoryController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _reservePriceController = TextEditingController();
  final _buyNowPriceController = TextEditingController();
  final _fuelTypeController = TextEditingController();
  final _locationController = TextEditingController();

  // State
  final List<File> _imageFiles = [];
  File? _videoFile;
  final List<File> _documentFiles = [];
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
    _carCategoryController.dispose();
    _descriptionController.dispose();
    _reservePriceController.dispose();
    _buyNowPriceController.dispose();
    _fuelTypeController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  // ═══════════════════════════════════════════════
  // PICKER LOGIC
  // ═══════════════════════════════════════════════

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
              CreateAuctionHelpers.sheetHandle(),
              SizedBox(height: 16.h),
              Text(
                "Add Images",
                style: FontManager.heading3(color: Colors.white),
              ),
              SizedBox(height: 16.h),
              CreateAuctionHelpers.sheetOption(
                icon: Icons.camera_alt_outlined,
                label: "Take Photo",
                onTap: () {
                  Navigator.pop(ctx);
                  _pickImageFromCamera();
                },
              ),
              CreateAuctionHelpers.sheetOption(
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
    );
    if (photo != null) setState(() => _imageFiles.add(File(photo.path)));
  }

  Future<void> _pickImagesFromGallery() async {
    final remaining = _maxImages - _imageFiles.length;
    if (remaining <= 0) {
      _showLimitSnackbar("Maximum $_maxImages images allowed");
      return;
    }
    final List<XFile> photos = await _imagePicker.pickMultiImage(
      imageQuality: 85,
    );
    if (photos.isNotEmpty) {
      setState(
        () =>
            _imageFiles.addAll(photos.take(remaining).map((x) => File(x.path))),
      );
    }
  }

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
              CreateAuctionHelpers.sheetHandle(),
              SizedBox(height: 16.h),
              Text(
                "Showcase Video",
                style: FontManager.heading3(color: Colors.white),
              ),
              SizedBox(height: 16.h),
              CreateAuctionHelpers.sheetOption(
                icon: Icons.videocam_outlined,
                label: "Record Video",
                onTap: () {
                  Navigator.pop(ctx);
                  _pickVideoFromSource(ImageSource.camera);
                },
              ),
              CreateAuctionHelpers.sheetOption(
                icon: Icons.video_library_outlined,
                label: "Choose from Gallery",
                onTap: () {
                  Navigator.pop(ctx);
                  _pickVideoFromSource(ImageSource.gallery);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickVideoFromSource(ImageSource source) async {
    final XFile? video = await _imagePicker.pickVideo(source: source);
    if (video != null) {
      final file = File(video.path);
      if (file.lengthSync() / (1024 * 1024) > _maxVideoSizeMB) {
        _showLimitSnackbar("Video too large. Max ${_maxVideoSizeMB}MB.");
        return;
      }
      setState(() => _videoFile = file);
    }
  }

  Future<void> _pickDocuments() async {
    final result = await FilePicker.pickFiles(
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
      ],
    );
    if (result != null) {
      setState(
        () => _documentFiles.addAll(
          result.files.where((f) => f.path != null).map((f) => File(f.path!)),
        ),
      );
    }
  }

  void _showLimitSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: FontManager.bodySmall(color: Colors.white),
        ),
        backgroundColor: AppColors.errorRed,
        behavior: SnackBarBehavior.floating,
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
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 16.h),
            CreateAuctionHelpers.sheetHandle(),
            SizedBox(height: 16.h),
            Text(
              "Auction Duration",
              style: FontManager.heading3(color: Colors.white),
            ),
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
                    ? Icon(Icons.check_circle, color: AppColors.sceTeal)
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
  }

  void _onPublish() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (_imageFiles.isEmpty) {
        _showLimitSnackbar("Please add at least one image.");
        return;
      }
      if (_selectedDuration.isEmpty) {
        _showLimitSnackbar("Please select auction duration.");
        return;
      }

      final provider = Provider.of<CreateAuctionProvider>(context, listen: false);

      // Calculate dates
      final startsAt = DateTime.now().toUtc();
      final days = int.tryParse(_selectedDuration.split(' ')[0]) ?? 3;
      final endsAt = startsAt.add(Duration(days: days));

      final success = await provider.createAuction(
        context: context,
        title: _titleController.text,
        description: _descriptionController.text,
        brand: _brandController.text,
        model: _modelController.text,
        category: _carCategoryController.text.toLowerCase().replaceAll(' ', '_'),
        year: int.tryParse(_yearController.text) ?? 0,
        mileage: int.tryParse(_mileageController.text) ?? 0,
        vin: _vinController.text,
        fuelType: _fuelTypeController.text,
        location: _locationController.text,
        reservePrice: _reservePriceController.text,
        buyNowPrice: _buyNowPriceController.text,
        startsAt: startsAt.toIso8601String(),
        endsAt: endsAt.toIso8601String(),
        images: _imageFiles,
        video: _videoFile,
        document: _documentFiles.isNotEmpty ? _documentFiles.first : null,
      );

      if (success && mounted) {
        Navigator.pop(context);
      }
    }
  }

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
            children: [
              SizedBox(height: 16.h),
              VehicleInfoFields(
                titleController: _titleController,
                brandController: _brandController,
                modelController: _modelController,
                yearController: _yearController,
                mileageController: _mileageController,
                vinController: _vinController,
                carCategoryController: _carCategoryController,
                descriptionController: _descriptionController,
                fuelTypeController: _fuelTypeController,
                locationController: _locationController,
              ),
              SizedBox(height: 28.h),
              MediaSelectionSection(
                imageFiles: _imageFiles,
                videoFile: _videoFile,
                documentFiles: _documentFiles,
                maxImages: _maxImages,
                maxVideoSizeMB: _maxVideoSizeMB,
                onPickImages: _pickImages,
                onPickVideo: _pickVideo,
                onPickDocuments: _pickDocuments,
                onRemoveImage: (i) => setState(() => _imageFiles.removeAt(i)),
                onRemoveVideo: () => setState(() => _videoFile = null),
                onRemoveDocument: (i) =>
                    setState(() => _documentFiles.removeAt(i)),
              ),
              SizedBox(height: 28.h),
              PricingDurationSection(
                reservePriceController: _reservePriceController,
                buyNowPriceController: _buyNowPriceController,
                selectedDuration: _selectedDuration,
                onSelectDuration: _showDurationSheet,
              ),
              SizedBox(height: 32.h),
              Consumer<CreateAuctionProvider>(
                builder: (context, provider, child) {
                  return CustomButton(
                    text: "🔒  Publish Auction",
                    onPressed: _onPublish,
                    isLoading: provider.isLoading,
                  );
                },
              ),
              SizedBox(height: 32.h),
            ],
          ),
        ),
      ),
    );
  }
}
