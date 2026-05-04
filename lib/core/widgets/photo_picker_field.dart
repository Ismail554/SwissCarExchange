import 'dart:io';
import 'dart:ui';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rionydo/app_utils/utils/app_colors.dart';

// ─────────────────────────────────────────────────────────────────────────────
// PhotoPickerField — shows empty upload prompt OR photo preview with edit/remove
// Accepts an optional [networkPhotoUrl] to render the current server photo
// when no new local file has been picked yet.
// ─────────────────────────────────────────────────────────────────────────────
class PhotoPickerField extends StatelessWidget {
  final File? photoFile;
  final String? photoFileName;
  final String? networkPhotoUrl;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  const PhotoPickerField({
    super.key,
    required this.photoFile,
    required this.photoFileName,
    required this.onTap,
    required this.onRemove,
    this.networkPhotoUrl,
  });

  @override
  Widget build(BuildContext context) {
    final hasLocalFile = photoFile != null;
    final hasNetworkPhoto = networkPhotoUrl != null && networkPhotoUrl!.isNotEmpty;
    final teal = AppColors.sceTeal;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          height: (hasLocalFile || hasNetworkPhoto) ? 220.h : 180.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: (hasLocalFile || hasNetworkPhoto)
                  ? teal.withOpacity(0.45)
                  : Colors.white.withOpacity(0.12),
              width: 1.5,
            ),
            color: (hasLocalFile || hasNetworkPhoto)
                ? teal.withOpacity(0.05)
                : Colors.white.withOpacity(0.03),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(19.r),
            child: hasLocalFile
                ? PhotoPreview(
                    photoFile: photoFile!,
                    teal: teal,
                    onEdit: onTap,
                    onRemove: onRemove,
                  )
                : hasNetworkPhoto
                    ? NetworkPhotoPreview(
                        photoUrl: networkPhotoUrl!,
                        teal: teal,
                        onEdit: onTap,
                        onRemove: onRemove,
                      )
                    : UploadPrompt(teal: teal, onTap: onTap),
          ),
        ),
        if (!hasLocalFile && !hasNetworkPhoto) ...[
          SizedBox(height: 12.h),
          Row(
            children: [
              MethodPill(
                icon: Icons.camera_alt_outlined,
                label: 'Camera',
                teal: teal,
                onTap: onTap,
              ),
              SizedBox(width: 8.w),
              MethodPill(
                icon: Icons.photo_library_outlined,
                label: 'Gallery',
                teal: teal,
                onTap: onTap,
              ),
              SizedBox(width: 8.w),
              MethodPill(
                icon: Icons.insert_drive_file_outlined,
                label: 'Files',
                teal: teal,
                onTap: onTap,
              ),
            ],
          ),
          SizedBox(height: 6.h),
          Text(
            'JPG or PNG · max 5 MB',
            style: TextStyle(color: Colors.white24, fontSize: 11.sp),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// PhotoPickerSheet — bottom sheet for Camera / Gallery / Files selection
// ─────────────────────────────────────────────────────────────────────────────
class PhotoPickerSheet extends StatelessWidget {
  final VoidCallback onCamera;
  final VoidCallback onGallery;
  final VoidCallback onFile;

  const PhotoPickerSheet({
    super.key,
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
            'Upload Profile Photo',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            'Choose how you want to provide your photo',
            style: TextStyle(color: Colors.white38, fontSize: 12.sp),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20.h),
          Row(
            children: [
                        _SheetOption(icon: Icons.camera_alt_outlined, label: 'Camera', onTap: onCamera),
              SizedBox(width: 10.w),
              _SheetOption(icon: Icons.photo_library_outlined, label: 'Gallery', onTap: onGallery),
              SizedBox(width: 10.w),
              _SheetOption(icon: Icons.insert_drive_file_outlined, label: 'Files\n(JPG/PNG)', onTap: onFile),
            ],
          ),
          SizedBox(height: 14.h),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.white38, fontSize: 13.sp, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// UploadPrompt — empty state (no photo selected)
// ─────────────────────────────────────────────────────────────────────────────
class UploadPrompt extends StatelessWidget {
  final Color teal;
  final VoidCallback onTap;
  const UploadPrompt({super.key, required this.teal, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 56.w,
            height: 56.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: teal.withOpacity(0.1),
              border: Border.all(color: teal.withOpacity(0.25), width: 1.2),
            ),
            child: Icon(Icons.add_a_photo_outlined, color: teal, size: 24.sp),
          ),
          SizedBox(height: 14.h),
          Text(
            'Tap to upload profile photo',
            style: TextStyle(
              color: Colors.white.withOpacity(0.75),
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 5.h),
          Text(
            'A clear, front-facing photo works best',
            style: TextStyle(color: Colors.white38, fontSize: 12.sp),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// PhotoPreview — local File preview with tap-to-reveal overlay (Change/Remove)
// ─────────────────────────────────────────────────────────────────────────────
class PhotoPreview extends StatefulWidget {
  final File photoFile;
  final Color teal;
  final VoidCallback onEdit;
  final VoidCallback onRemove;

  const PhotoPreview({
    super.key,
    required this.photoFile,
    required this.teal,
    required this.onEdit,
    required this.onRemove,
  });

  @override
  State<PhotoPreview> createState() => _PhotoPreviewState();
}

class _PhotoPreviewState extends State<PhotoPreview> {
  bool _showOverlay = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _showOverlay = !_showOverlay),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.file(widget.photoFile, fit: BoxFit.cover),
          _buildGradient(),
          _buildActions(),
          _buildEditHint(),
        ],
      ),
    );
  }

  Widget _buildGradient() => Positioned.fill(
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, Colors.black.withOpacity(_showOverlay ? 0.65 : 0.3)],
              stops: const [0.4, 1.0],
            ),
          ),
        ),
      );

  Widget _buildActions() => Positioned(
        left: 0, right: 0, bottom: 0,
        child: AnimatedOpacity(
          opacity: _showOverlay ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 200),
          child: Padding(
            padding: EdgeInsets.all(14.r),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _OverlayActionBtn(
                  icon: Icons.edit_outlined,
                  label: 'Change',
                  color: Colors.white,
                  onTap: () { setState(() => _showOverlay = false); widget.onEdit(); },
                ),
                SizedBox(width: 10.w),
                _OverlayActionBtn(
                  icon: Icons.delete_outline_rounded,
                  label: 'Remove',
                  color: const Color(0xFFFF6B6B),
                  onTap: () { setState(() => _showOverlay = false); widget.onRemove(); },
                ),
              ],
            ),
          ),
        ),
      );

  Widget _buildEditHint() => Positioned(
        top: 10.h, right: 10.w,
        child: AnimatedOpacity(
          opacity: _showOverlay ? 0.0 : 1.0,
          duration: const Duration(milliseconds: 200),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.4),
              borderRadius: BorderRadius.circular(99),
              border: Border.all(color: Colors.white12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.touch_app_outlined, color: Colors.white60, size: 13.sp),
                SizedBox(width: 4.w),
                Text('Tap to edit', style: TextStyle(color: Colors.white60, fontSize: 11.sp)),
              ],
            ),
          ),
        ),
      );
}

// ─────────────────────────────────────────────────────────────────────────────
// NetworkPhotoPreview — shows existing server photo URL with edit/remove
// ─────────────────────────────────────────────────────────────────────────────
class NetworkPhotoPreview extends StatefulWidget {
  final String photoUrl;
  final Color teal;
  final VoidCallback onEdit;
  final VoidCallback onRemove;

  const NetworkPhotoPreview({
    super.key,
    required this.photoUrl,
    required this.teal,
    required this.onEdit,
    required this.onRemove,
  });

  @override
  State<NetworkPhotoPreview> createState() => _NetworkPhotoPreviewState();
}

class _NetworkPhotoPreviewState extends State<NetworkPhotoPreview> {
  bool _showOverlay = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _showOverlay = !_showOverlay),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            widget.photoUrl,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Center(
              child: Icon(Icons.broken_image_outlined, color: Colors.white38, size: 40.sp),
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(_showOverlay ? 0.65 : 0.3)],
                  stops: const [0.4, 1.0],
                ),
              ),
            ),
          ),
          Positioned(
            left: 0, right: 0, bottom: 0,
            child: AnimatedOpacity(
              opacity: _showOverlay ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: Padding(
                padding: EdgeInsets.all(14.r),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _OverlayActionBtn(
                      icon: Icons.edit_outlined,
                      label: 'Change',
                      color: Colors.white,
                      onTap: () { setState(() => _showOverlay = false); widget.onEdit(); },
                    ),
                    SizedBox(width: 10.w),
                    _OverlayActionBtn(
                      icon: Icons.delete_outline_rounded,
                      label: 'Remove',
                      color: const Color(0xFFFF6B6B),
                      onTap: () { setState(() => _showOverlay = false); widget.onRemove(); },
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 10.h, right: 10.w,
            child: AnimatedOpacity(
              opacity: _showOverlay ? 0.0 : 1.0,
              duration: const Duration(milliseconds: 200),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(99),
                  border: Border.all(color: Colors.white12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.touch_app_outlined, color: Colors.white60, size: 13.sp),
                    SizedBox(width: 4.w),
                    Text('Tap to edit', style: TextStyle(color: Colors.white60, fontSize: 11.sp)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// MethodPill — Camera / Gallery / Files selector pill
// ─────────────────────────────────────────────────────────────────────────────
class MethodPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color teal;
  final VoidCallback onTap;

  const MethodPill({
    super.key,
    required this.icon,
    required this.label,
    required this.teal,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.04),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: Colors.white.withOpacity(0.08)),
          ),
          child: Column(
            children: [
              Icon(icon, color: teal, size: 20.sp),
              SizedBox(height: 6.h),
              Text(
                label,
                style: TextStyle(color: Colors.white60, fontSize: 11.sp, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _OverlayActionBtn — Change / Remove pill inside photo preview overlay
// (private to this file — used by PhotoPreview & NetworkPhotoPreview)
// ─────────────────────────────────────────────────────────────────────────────
class _OverlayActionBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _OverlayActionBtn({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(99),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 9.h),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(99),
              border: Border.all(color: color.withOpacity(0.35), width: 1),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: color, size: 15.sp),
                SizedBox(width: 6.w),
                Text(label, style: TextStyle(color: color, fontSize: 13.sp, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// showPhotoPicker — convenience function to show the bottom sheet
// ─────────────────────────────────────────────────────────────────────────────
Future<void> showPhotoPicker({
  required BuildContext context,
  required void Function(ImageSource) onPickFromSource,
  required Future<void> Function() onPickFromFiles,
}) async {
  await showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (_) => PhotoPickerSheet(
      onCamera: () => onPickFromSource(ImageSource.camera),
      onGallery: () => onPickFromSource(ImageSource.gallery),
      onFile: onPickFromFiles,
    ),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// pickPhotoFromFiles — convenience function for file picker
// ─────────────────────────────────────────────────────────────────────────────
Future<({File file, String name})?> pickPhotoFromFiles() async {
  final result = await FilePicker.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['jpg', 'jpeg', 'png'],
  );
  if (result != null && result.files.single.path != null) {
    final f = result.files.single;
    return (file: File(f.path!), name: f.name);
  }
  return null;
}

// ─────────────────────────────────────────────────────────────────────────────
// _SheetOption — individual option tile inside PhotoPickerSheet
// (private to this file)
// ─────────────────────────────────────────────────────────────────────────────
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
