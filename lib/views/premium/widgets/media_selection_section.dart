import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rionydo/core/utils/app_colors.dart';
import 'section_header.dart';
import 'create_auction_helpers.dart';

class MediaSelectionSection extends StatelessWidget {
  final List<File> imageFiles;
  final File? videoFile;
  final List<File> documentFiles;
  final int maxImages;
  final int maxVideoSizeMB;
  final VoidCallback onPickImages;
  final VoidCallback onPickVideo;
  final VoidCallback onPickDocuments;
  final Function(int) onRemoveImage;
  final VoidCallback onRemoveVideo;
  final Function(int) onRemoveDocument;

  const MediaSelectionSection({
    super.key,
    required this.imageFiles,
    required this.videoFile,
    required this.documentFiles,
    required this.maxImages,
    required this.maxVideoSizeMB,
    required this.onPickImages,
    required this.onPickVideo,
    required this.onPickDocuments,
    required this.onRemoveImage,
    required this.onRemoveVideo,
    required this.onRemoveDocument,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AuctionSectionHeader(title: "MEDIA & DOCUMENTS"),
        SizedBox(height: 16.h),

        // ── IMAGES ──
        CreateAuctionHelpers.mediaSubLabel(
          Icons.image_outlined,
          "Images (${imageFiles.length}/$maxImages)",
        ),
        SizedBox(height: 10.h),
        _buildImagePicker(),
        SizedBox(height: 20.h),

        // ── VIDEO ──
        CreateAuctionHelpers.mediaSubLabel(Icons.videocam_outlined, "Showcase Video"),
        SizedBox(height: 10.h),
        _buildVideoSection(),
        SizedBox(height: 20.h),

        // ── DOCUMENTS ──
        CreateAuctionHelpers.mediaSubLabel(
          Icons.description_outlined,
          "Documents (Inspection, Service)",
        ),
        SizedBox(height: 10.h),
        _buildDocumentsSection(),
      ],
    );
  }

  Widget _buildImagePicker() {
    return Wrap(
      spacing: 10.w,
      runSpacing: 10.h,
      children: [
        ...imageFiles.asMap().entries.map((e) => _buildImageTile(e.key, e.value)),
        if (imageFiles.length < maxImages)
          GestureDetector(
            onTap: onPickImages,
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
                  const Text(
                    "Add",
                    style: TextStyle(
                      color: AppColors.sceGreyA0,
                      fontSize: 10,
                    ),
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
            onTap: () => onRemoveImage(index),
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

  Widget _buildVideoSection() {
    if (videoFile != null) {
      return CreateAuctionHelpers.selectedFileCard(
        icon: Icons.videocam,
        fileName: videoFile!.path.split(Platform.pathSeparator).last,
        sizeString: "${(videoFile!.lengthSync() / (1024 * 1024)).toStringAsFixed(1)} MB",
        onRemove: onRemoveVideo,
        onReplace: onPickVideo,
      );
    }

    return CreateAuctionHelpers.uploadButton(
      icon: Icons.cloud_upload_outlined,
      label: "Upload Video",
      subtitle: "Max ${maxVideoSizeMB}MB • MP4, MOV",
      onTap: onPickVideo,
    );
  }

  Widget _buildDocumentsSection() {
    return Column(
      children: [
        ...documentFiles.asMap().entries.map(
          (e) => Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: CreateAuctionHelpers.selectedFileCard(
              icon: _docIcon(e.value.path),
              fileName: e.value.path.split(Platform.pathSeparator).last,
              sizeString: "${(e.value.lengthSync() / (1024 * 1024)).toStringAsFixed(1)} MB",
              onRemove: () => onRemoveDocument(e.key),
            ),
          ),
        ),
        CreateAuctionHelpers.uploadButton(
          icon: Icons.cloud_upload_outlined,
          label: "Upload Documents",
          subtitle: "PDF, DOC, DOCX, XLS, Images",
          onTap: onPickDocuments,
        ),
      ],
    );
  }

  // Helper inside since it's specific to this list
  IconData _docIcon(String path) {
    final ext = path.split('.').last.toLowerCase();
    switch (ext) {
      case 'pdf': return Icons.picture_as_pdf;
      case 'doc':
      case 'docx': return Icons.article_outlined;
      case 'xls':
      case 'xlsx': return Icons.table_chart_outlined;
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'webp': return Icons.image_outlined;
      default: return Icons.insert_drive_file_outlined;
    }
  }
}
