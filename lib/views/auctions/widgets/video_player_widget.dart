import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:rionydo/app_utils/utils/app_colors.dart';

/// A self-contained play-button / inline-video-player overlay.
///
/// Place this inside a [Positioned.fill] within the image carousel [Stack].
/// - Initially shows a centered play button.
/// - On tap it loads and plays the video **inline** (no full-screen navigation).
/// - A close button in the top-right lets the user dismiss back to images.
class VideoPlayButton extends StatefulWidget {
  final String videoUrl;

  const VideoPlayButton({super.key, required this.videoUrl});

  @override
  State<VideoPlayButton> createState() => _VideoPlayButtonState();
}

class _VideoPlayButtonState extends State<VideoPlayButton> {
  bool _showPlayer = false;
  bool _isLoading = false;
  String? _errorMessage;

  VideoPlayerController? _videoController;
  ChewieController? _chewieController;

  // ── Lifecycle ──────────────────────────────────────────────────────────

  @override
  void dispose() {
    _disposeControllers();
    super.dispose();
  }

  void _disposeControllers() {
    debugPrint('🎬 VIDEO: _disposeControllers()');
    _videoController?.removeListener(_onVideoStateChange);
    _chewieController?.dispose();
    _videoController?.dispose();
    _videoController = null;
    _chewieController = null;
  }

  // ── Initialisation ────────────────────────────────────────────────────

  Future<void> _startPlayer() async {
    setState(() {
      _showPlayer = true;
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final url = widget.videoUrl.trim();
      debugPrint('🎬 VIDEO: _startPlayer() — URL = "$url"');

      if (url.isEmpty) {
        debugPrint('🎬 VIDEO: ERROR — URL is empty!');
        if (mounted) {
          setState(() {
            _isLoading = false;
            _errorMessage = 'Video URL is empty.';
          });
        }
        return;
      }

      final uri = Uri.tryParse(url);
      if (uri == null || !uri.hasScheme) {
        debugPrint('🎬 VIDEO: ERROR — Invalid URI: "$url"');
        if (mounted) {
          setState(() {
            _isLoading = false;
            _errorMessage = 'Invalid video URL format.';
          });
        }
        return;
      }

      debugPrint('🎬 VIDEO: Parsed URI = $uri (scheme=${uri.scheme})');

      final controller = VideoPlayerController.networkUrl(uri);
      _videoController = controller;
      controller.addListener(_onVideoStateChange);

      debugPrint('🎬 VIDEO: Calling controller.initialize()...');
      await controller.initialize();

      if (!mounted) {
        debugPrint('🎬 VIDEO: Widget disposed during init — aborting.');
        controller.dispose();
        return;
      }

      debugPrint(
        '🎬 VIDEO: ✅ Initialized — '
        'size=${controller.value.size}, '
        'duration=${controller.value.duration}, '
        'aspectRatio=${controller.value.aspectRatio}',
      );

      final chewie = ChewieController(
        videoPlayerController: controller,
        autoPlay: true,
        looping: false,
        // Let the player fill the available space without hard-coding an
        // aspect ratio — this avoids black bars in the carousel area.
        aspectRatio: controller.value.aspectRatio > 0
            ? controller.value.aspectRatio
            : 16 / 9,
        allowFullScreen: false,
        showControlsOnInitialize: true,
        errorBuilder: (context, errorMessage) {
          debugPrint('🎬 VIDEO: Chewie errorBuilder — $errorMessage');
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline,
                    color: AppColors.sceGrey99, size: 40.sp),
                SizedBox(height: 8.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Text(
                    errorMessage,
                    style:
                        TextStyle(color: AppColors.sceGrey99, fontSize: 12.sp),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          );
        },
        materialProgressColors: ChewieProgressColors(
          playedColor: AppColors.sceTeal,
          handleColor: AppColors.sceTeal,
          backgroundColor: Colors.white24,
          bufferedColor: Colors.white38,
        ),
      );

      if (mounted) {
        debugPrint('🎬 VIDEO: ChewieController ready — showing player.');
        setState(() {
          _chewieController = chewie;
          _isLoading = false;
        });
      }
    } catch (e, stack) {
      debugPrint('🎬 VIDEO: ❌ Exception: $e');
      debugPrint('🎬 VIDEO: Stack trace:\n$stack');
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Could not load video.\n$e';
        });
      }
    }
  }

  void _onVideoStateChange() {
    final c = _videoController;
    if (c == null) return;
    if (c.value.hasError) {
      debugPrint('🎬 VIDEO: ❌ Playback error: ${c.value.errorDescription}');
      if (mounted) {
        setState(() {
          _errorMessage = c.value.errorDescription ?? 'Playback error';
          _isLoading = false;
        });
      }
    }
    if (c.value.isBuffering) {
      debugPrint(
        '🎬 VIDEO: Buffering — pos=${c.value.position}, dur=${c.value.duration}',
      );
    }
  }

  void _closePlayer() {
    debugPrint('🎬 VIDEO: _closePlayer() — returning to image view.');
    _disposeControllers();
    if (mounted) {
      setState(() {
        _showPlayer = false;
        _isLoading = false;
        _errorMessage = null;
      });
    }
  }

  void _retry() {
    debugPrint('🎬 VIDEO: Retry tapped.');
    _disposeControllers();
    _startPlayer();
  }

  // ── Build ─────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    // When not playing, show the centered play button only.
    if (!_showPlayer) {
      return Center(
        child: GestureDetector(
          onTap: () {
            debugPrint('🎬 VIDEO: Play button tapped.');
            _startPlayer();
          },
          child: Container(
            height: 56.w,
            width: 56.w,
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.55),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.3),
                width: 1.5,
              ),
            ),
            child: Icon(
              Icons.play_arrow_rounded,
              color: Colors.white,
              size: 34.sp,
            ),
          ),
        ),
      );
    }

    // When playing, fill the entire parent area with the player.
    return Container(
      color: Colors.black,
      child: Stack(
        children: [
          // Video / loading / error content
          Positioned.fill(child: _buildPlayerContent()),

          // Close button — top-right
          Positioned(
            top: 8.h,
            right: 8.w,
            child: SafeArea(
              child: GestureDetector(
                onTap: _closePlayer,
                child: Container(
                  padding: EdgeInsets.all(6.w),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.6),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 20.sp,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerContent() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.sceTeal),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, color: AppColors.sceGrey99, size: 40.sp),
              SizedBox(height: 8.h),
              Text(
                _errorMessage!,
                style: TextStyle(color: AppColors.sceGrey99, fontSize: 12.sp),
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 12.h),
              GestureDetector(
                onTap: _retry,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.refresh, color: AppColors.sceTeal, size: 18.sp),
                    SizedBox(width: 4.w),
                    Text(
                      'Retry',
                      style:
                          TextStyle(color: AppColors.sceTeal, fontSize: 13.sp),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_chewieController != null) {
      return Center(child: Chewie(controller: _chewieController!));
    }

    return const SizedBox.shrink();
  }
}
