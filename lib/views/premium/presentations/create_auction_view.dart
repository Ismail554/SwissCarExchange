import 'dart:io';
import 'package:go_router/go_router.dart';
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
import 'package:rionydo/core/widgets/widget_snackbar.dart';
import 'package:flutter/cupertino.dart'
    show
        CupertinoDatePicker,
        CupertinoDatePickerMode,
        CupertinoTheme,
        CupertinoThemeData,
        CupertinoTextThemeData,
        showCupertinoModalPopup;
import 'package:rionydo/app.dart';

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
  DateTime? _startDate;
  TimeOfDay? _startTime;
  DateTime? _endDate;
  TimeOfDay? _endTime;

  static const int _maxImages = 20;
  static const int _maxVideoSizeMB = 50;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<CreateAuctionProvider>().fetchAuctionConfig();
      }
    });
  }

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
                  ctx.pop();
                  _pickImageFromCamera();
                },
              ),
              CreateAuctionHelpers.sheetOption(
                icon: Icons.photo_library_outlined,
                label: "Choose from Gallery",
                onTap: () {
                  ctx.pop();
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
      AppSnackBar.error(context, "Maximum $_maxImages images allowed");
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
      AppSnackBar.error(context, "Maximum $_maxImages images allowed");
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
                  ctx.pop();
                  _pickVideoFromSource(ImageSource.camera);
                },
              ),
              CreateAuctionHelpers.sheetOption(
                icon: Icons.video_library_outlined,
                label: "Choose from Gallery",
                onTap: () {
                  ctx.pop();
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
        if (!mounted) return;
        AppSnackBar.error(
          context,
          "Video too large. Max ${_maxVideoSizeMB}MB.",
        );
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

  // Helper to show a beautiful, premium dark-teal Cupertino Date/Time Picker modal on iOS
  Future<DateTime?> _showCupertinoDatePicker({
    required BuildContext context,
    required DateTime initialDateTime,
    required DateTime minimumDate,
    required DateTime maximumDate,
    required CupertinoDatePickerMode mode,
  }) async {
    DateTime selectedDateTime = initialDateTime;
    if (selectedDateTime.isBefore(minimumDate)) {
      selectedDateTime = minimumDate;
    } else if (selectedDateTime.isAfter(maximumDate)) {
      selectedDateTime = maximumDate;
    }

    bool isDonePressed = false;
    await showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 300.h,
          padding: EdgeInsets.only(top: 6.h),
          color: AppColors.sceCardBg,
          child: SafeArea(
            top: false,
            child: Column(
              children: [
                Container(
                  color: AppColors.sceCardBg,
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Text(
                          "Cancel",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          isDonePressed = true;
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          "Done",
                          style: TextStyle(
                            color: AppColors.sceTeal,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(color: Colors.white24, height: 1),
                Expanded(
                  child: CupertinoTheme(
                    data: const CupertinoThemeData(
                      brightness: Brightness.dark,
                      textTheme: CupertinoTextThemeData(
                        dateTimePickerTextStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    child: CupertinoDatePicker(
                      mode: mode,
                      initialDateTime: selectedDateTime,
                      minimumDate: minimumDate,
                      maximumDate: maximumDate,
                      use24hFormat: true,
                      onDateTimeChanged: (DateTime newDateTime) {
                        selectedDateTime = newDateTime;
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
    if (isDonePressed) {
      return selectedDateTime;
    }
    return null;
  }

  Future<void> _pickStartDate() async {
    DateTime? picked;
    if (PlatformUtils.isIOS) {
      picked = await _showCupertinoDatePicker(
        context: context,
        initialDateTime: _startDate ?? DateTime.now(),
        minimumDate: DateTime.now().subtract(const Duration(minutes: 5)),
        maximumDate: DateTime.now().add(const Duration(days: 365)),
        mode: CupertinoDatePickerMode.date,
      );
    } else {
      picked = await showDatePicker(
        context: context,
        initialDate: _startDate ?? DateTime.now(),
        firstDate: DateTime.now().subtract(const Duration(minutes: 5)),
        lastDate: DateTime.now().add(const Duration(days: 365)),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.dark(
                primary: AppColors.sceTeal,
                onPrimary: Colors.black,
                surface: AppColors.sceCardBg,
                onSurface: Colors.white,
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(foregroundColor: AppColors.sceTeal),
              ),
            ),
            child: child!,
          );
        },
      );
    }

    if (picked != null) {
      if (!mounted) return;
      final now = DateTime.now();
      setState(() {
        _startDate = picked;
        // If they select today, make sure any pre-selected start time is not in the past
        if (picked!.year == now.year &&
            picked.month == now.month &&
            picked.day == now.day) {
          if (_startTime != null) {
            final startsAt = DateTime(
              picked.year,
              picked.month,
              picked.day,
              _startTime!.hour,
              _startTime!.minute,
            );
            if (startsAt.isBefore(now.subtract(const Duration(minutes: 5)))) {
              _startTime = null;
              AppSnackBar.error(
                context,
                "Start time reset because it is in the past.",
              );
            }
          }
        }

        // Restrict end date/time range based on the new start date/time
        if (_endDate != null) {
          final provider = Provider.of<CreateAuctionProvider>(
            context,
            listen: false,
          );
          final minHours = provider.minAuctionDurationHours;
          final maxHours = provider.maxAuctionDurationHours;
          final startsAt = DateTime(
            _startDate!.year,
            _startDate!.month,
            _startDate!.day,
            _startTime?.hour ?? 0,
            _startTime?.minute ?? 0,
          );
          final minEndDate = startsAt.add(Duration(hours: minHours));
          final maxEndDate = startsAt.add(Duration(hours: maxHours));
          final firstSelectableDate = DateTime(
            minEndDate.year,
            minEndDate.month,
            minEndDate.day,
          );
          final lastSelectableDate = DateTime(
            maxEndDate.year,
            maxEndDate.month,
            maxEndDate.day,
          );

          if (_endDate!.isBefore(firstSelectableDate) ||
              _endDate!.isAfter(lastSelectableDate)) {
            _endDate = null;
            _endTime = null;
          }
        }
      });
    }
  }

  Future<void> _pickStartTime() async {
    DateTime? pickedDateTime;
    if (PlatformUtils.isIOS) {
      final now = DateTime.now();
      final initialDateTime = DateTime(
        _startDate?.year ?? now.year,
        _startDate?.month ?? now.month,
        _startDate?.day ?? now.day,
        _startTime?.hour ?? now.hour,
        _startTime?.minute ?? now.minute,
      );
      final minimumDate = DateTime(
        _startDate?.year ?? now.year,
        _startDate?.month ?? now.month,
        _startDate?.day ?? now.day,
        0,
        0,
      );
      final maximumDate = DateTime(
        _startDate?.year ?? now.year,
        _startDate?.month ?? now.month,
        _startDate?.day ?? now.day,
        23,
        59,
      );
      pickedDateTime = await _showCupertinoDatePicker(
        context: context,
        initialDateTime: initialDateTime,
        minimumDate: minimumDate,
        maximumDate: maximumDate,
        mode: CupertinoDatePickerMode.time,
      );
    } else {
      final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: _startTime ?? TimeOfDay.now(),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.dark(
                primary: AppColors.sceTeal,
                onPrimary: Colors.black,
                surface: AppColors.sceCardBg,
                onSurface: Colors.white,
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(foregroundColor: AppColors.sceTeal),
              ),
            ),
            child: child!,
          );
        },
      );
      if (picked != null) {
        pickedDateTime = DateTime(
          _startDate?.year ?? DateTime.now().year,
          _startDate?.month ?? DateTime.now().month,
          _startDate?.day ?? DateTime.now().day,
          picked.hour,
          picked.minute,
        );
      }
    }

    if (pickedDateTime != null) {
      if (!mounted) return;
      final picked = TimeOfDay(
        hour: pickedDateTime.hour,
        minute: pickedDateTime.minute,
      );
      final now = DateTime.now();
      // If start date is selected, check if it's today and picked time is in the past
      if (_startDate != null) {
        final chosenStart = DateTime(
          _startDate!.year,
          _startDate!.month,
          _startDate!.day,
          picked.hour,
          picked.minute,
        );
        if (chosenStart.isBefore(now.subtract(const Duration(minutes: 5)))) {
          if (!mounted) return;
          AppSnackBar.error(context, "Start time cannot be in the past.");
          return;
        }

        // Also check if this new start time invalidates currently selected end date/time
        if (_endDate != null && _endTime != null) {
          final provider = Provider.of<CreateAuctionProvider>(
            context,
            listen: false,
          );
          final minHours = provider.minAuctionDurationHours;
          final maxHours = provider.maxAuctionDurationHours;
          final endsAt = DateTime(
            _endDate!.year,
            _endDate!.month,
            _endDate!.day,
            _endTime!.hour,
            _endTime!.minute,
          );
          final duration = endsAt.difference(chosenStart);
          final durationHours = duration.inMinutes / 60.0;
          if (durationHours < minHours || durationHours > maxHours) {
            setState(() {
              _startTime = picked;
              _endDate = null;
              _endTime = null;
            });
            AppSnackBar.error(
              context,
              "Start time updated. End date/time reset because it falls outside the allowed duration range ($minHours - $maxHours hours).",
            );
            return;
          }
        }
      }

      setState(() {
        _startTime = picked;
      });
    }
  }

  void _clearStartTime() {
    setState(() {
      _startTime = null;
    });
  }

  Future<void> _pickEndDate() async {
    if (_startDate == null) {
      if (!mounted) return;
      AppSnackBar.error(context, "Please select a start date first.");
      return;
    }

    final provider = Provider.of<CreateAuctionProvider>(context, listen: false);
    final minHours = provider.minAuctionDurationHours;
    final maxHours = provider.maxAuctionDurationHours;

    final startsAt = DateTime(
      _startDate!.year,
      _startDate!.month,
      _startDate!.day,
      _startTime?.hour ?? 0,
      _startTime?.minute ?? 0,
    );

    final minEndDate = startsAt.add(Duration(hours: minHours));
    final maxEndDate = startsAt.add(Duration(hours: maxHours));

    final firstSelectableDate = DateTime(
      minEndDate.year,
      minEndDate.month,
      minEndDate.day,
    );
    final lastSelectableDate = DateTime(
      maxEndDate.year,
      maxEndDate.month,
      maxEndDate.day,
    );

    DateTime initialDate = _endDate ?? minEndDate;
    if (initialDate.isBefore(firstSelectableDate)) {
      initialDate = firstSelectableDate;
    } else if (initialDate.isAfter(lastSelectableDate)) {
      initialDate = lastSelectableDate;
    }

    DateTime? picked;
    if (PlatformUtils.isIOS) {
      picked = await _showCupertinoDatePicker(
        context: context,
        initialDateTime: initialDate,
        minimumDate: firstSelectableDate,
        maximumDate: lastSelectableDate,
        mode: CupertinoDatePickerMode.date,
      );
    } else {
      picked = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: firstSelectableDate,
        lastDate: lastSelectableDate,
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.dark(
                primary: AppColors.sceTeal,
                onPrimary: Colors.black,
                surface: AppColors.sceCardBg,
                onSurface: Colors.white,
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(foregroundColor: AppColors.sceTeal),
              ),
            ),
            child: child!,
          );
        },
      );
    }

    if (picked != null) {
      if (!mounted) return;
      if (_endTime != null) {
        // Check if the selected end date combined with current end time is valid
        final endsAt = DateTime(
          picked.year,
          picked.month,
          picked.day,
          _endTime!.hour,
          _endTime!.minute,
        );
        final duration = endsAt.difference(startsAt);
        final durationHours = duration.inMinutes / 60.0;
        if (durationHours < minHours || durationHours > maxHours) {
          setState(() {
            _endDate = picked;
            _endTime = null;
          });
          AppSnackBar.error(
            context,
            "End date updated. Please select an end time within the allowed range ($minHours - $maxHours hours).",
          );
          return;
        }
      }

      setState(() {
        _endDate = picked;
      });
    }
  }

  Future<void> _pickEndTime() async {
    if (_endDate == null) {
      if (!mounted) return;
      AppSnackBar.error(context, "Please select an end date first.");
      return;
    }

    DateTime? pickedDateTime;
    if (PlatformUtils.isIOS) {
      final now = DateTime.now();
      final initialDateTime = DateTime(
        _endDate!.year,
        _endDate!.month,
        _endDate!.day,
        _endTime?.hour ?? now.hour,
        _endTime?.minute ?? now.minute,
      );
      final minimumDate = DateTime(
        _endDate!.year,
        _endDate!.month,
        _endDate!.day,
        0,
        0,
      );
      final maximumDate = DateTime(
        _endDate!.year,
        _endDate!.month,
        _endDate!.day,
        23,
        59,
      );
      pickedDateTime = await _showCupertinoDatePicker(
        context: context,
        initialDateTime: initialDateTime,
        minimumDate: minimumDate,
        maximumDate: maximumDate,
        mode: CupertinoDatePickerMode.time,
      );
    } else {
      final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: _endTime ?? TimeOfDay.now(),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.dark(
                primary: AppColors.sceTeal,
                onPrimary: Colors.black,
                surface: AppColors.sceCardBg,
                onSurface: Colors.white,
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(foregroundColor: AppColors.sceTeal),
              ),
            ),
            child: child!,
          );
        },
      );
      if (picked != null) {
        pickedDateTime = DateTime(
          _endDate!.year,
          _endDate!.month,
          _endDate!.day,
          picked.hour,
          picked.minute,
        );
      }
    }

    if (pickedDateTime != null) {
      if (!mounted) return;
      final picked = TimeOfDay(
        hour: pickedDateTime.hour,
        minute: pickedDateTime.minute,
      );
      final startsAt = DateTime(
        _startDate!.year,
        _startDate!.month,
        _startDate!.day,
        _startTime?.hour ?? 0,
        _startTime?.minute ?? 0,
      );
      final endsAt = DateTime(
        _endDate!.year,
        _endDate!.month,
        _endDate!.day,
        picked.hour,
        picked.minute,
      );
      final duration = endsAt.difference(startsAt);
      final durationHours = duration.inMinutes / 60.0;
      final provider = Provider.of<CreateAuctionProvider>(
        context,
        listen: false,
      );
      final minHours = provider.minAuctionDurationHours;
      final maxHours = provider.maxAuctionDurationHours;

      if (durationHours < minHours) {
        if (!mounted) return;
        AppSnackBar.error(
          context,
          "End time must be at least $minHours hours after start time (currently ${durationHours.toStringAsFixed(1)} hours).",
        );
        return;
      }
      if (durationHours > maxHours) {
        if (!mounted) return;
        AppSnackBar.error(
          context,
          "End time must be at most $maxHours hours after start time (currently ${durationHours.toStringAsFixed(1)} hours).",
        );
        return;
      }

      setState(() {
        _endTime = picked;
      });
    }
  }

  void _onPublish() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (_imageFiles.isEmpty) {
        if (!mounted) return;
        AppSnackBar.error(context, "Please add at least one image.");
        return;
      }
      if (_startDate == null) {
        if (!mounted) return;
        AppSnackBar.error(context, "Please select a start date.");
        return;
      }
      if (_endDate == null) {
        if (!mounted) return;
        AppSnackBar.error(context, "Please select an end date.");
        return;
      }
      if (_endTime == null) {
        if (!mounted) return;
        AppSnackBar.error(context, "Please select an end time.");
        return;
      }

      final now = DateTime.now();
      DateTime startsAt;
      if (_startTime == null) {
        if (_startDate!.year == now.year &&
            _startDate!.month == now.month &&
            _startDate!.day == now.day) {
          startsAt = now;
        } else {
          startsAt = DateTime(
            _startDate!.year,
            _startDate!.month,
            _startDate!.day,
            0,
            0,
          );
        }
      } else {
        startsAt = DateTime(
          _startDate!.year,
          _startDate!.month,
          _startDate!.day,
          _startTime!.hour,
          _startTime!.minute,
        );
      }

      if (startsAt.isBefore(now.subtract(const Duration(minutes: 5)))) {
        if (!mounted) return;
        AppSnackBar.error(context, "Start time cannot be in the past.");
        return;
      }

      final endsAt = DateTime(
        _endDate!.year,
        _endDate!.month,
        _endDate!.day,
        _endTime!.hour,
        _endTime!.minute,
      );

      final duration = endsAt.difference(startsAt);
      final durationHours = duration.inMinutes / 60.0;

      final provider = Provider.of<CreateAuctionProvider>(
        context,
        listen: false,
      );
      final minHours = provider.minAuctionDurationHours;
      final maxHours = provider.maxAuctionDurationHours;

      if (durationHours < minHours) {
        if (!mounted) return;
        AppSnackBar.error(
          context,
          "The minimum auction duration is $minHours hours (currently ${durationHours.toStringAsFixed(1)} hours).",
        );
        return;
      }
      if (durationHours > maxHours) {
        if (!mounted) return;
        AppSnackBar.error(
          context,
          "The maximum auction duration is $maxHours hours (currently ${durationHours.toStringAsFixed(1)} hours).",
        );
        return;
      }

      final success = await provider.createAuction(
        context: context,
        title: _titleController.text,
        description: _descriptionController.text,
        brand: _brandController.text,
        model: _modelController.text,
        category: _carCategoryController.text.toLowerCase().replaceAll(
          ' ',
          '_',
        ),
        year: int.tryParse(_yearController.text) ?? 0,
        mileage: int.tryParse(_mileageController.text) ?? 0,
        vin: _vinController.text,
        fuelType: _fuelTypeController.text.toLowerCase(),
        location: _locationController.text,
        reservePrice: _reservePriceController.text,
        buyNowPrice: _buyNowPriceController.text,
        startsAt: startsAt.toUtc().toIso8601String(),
        endsAt: endsAt.toUtc().toIso8601String(),
        images: _imageFiles,
        video: _videoFile,
        document: _documentFiles.isNotEmpty ? _documentFiles.first : null,
      );

      if (success && mounted) {
        context.pop();
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
                startDate: _startDate,
                startTime: _startTime,
                endDate: _endDate,
                endTime: _endTime,
                onSelectStartDate: _pickStartDate,
                onSelectStartTime: _pickStartTime,
                onSelectEndDate: _pickEndDate,
                onSelectEndTime: _pickEndTime,
                onClearStartTime: _clearStartTime,
              ),
              SizedBox(height: 32.h),
              Consumer<CreateAuctionProvider>(
                builder: (context, provider, child) {
                  return CustomButton(
                    text: "Publish Auction",
                    onPressed: _onPublish,
                    isLoading: provider.isLoading,
                    loadingText: "...Uploading",
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
