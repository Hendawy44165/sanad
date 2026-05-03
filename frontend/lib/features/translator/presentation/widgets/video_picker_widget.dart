import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sanad/core/theme/app_colors.dart';
import 'package:sanad/l10n/app_localizations.dart';

/// Widget for selecting a video from the gallery or recording a live one.
///
/// Description: Provides a live camera preview for recording, and a gallery picker.
class VideoPickerWidget extends StatefulWidget {
  /// The local file path of the currently selected video, if any.
  final String? selectedVideoPath;

  /// Callback triggered when a video file is successfully picked or recorded.
  final ValueChanged<String> onVideoSelected;

  /// Callback triggered to clear the current selection.
  final VoidCallback onClear;

  /// Creates a [VideoPickerWidget].
  const VideoPickerWidget({super.key, this.selectedVideoPath, required this.onVideoSelected, required this.onClear});

  @override
  State<VideoPickerWidget> createState() => _VideoPickerWidgetState();
}

class _VideoPickerWidgetState extends State<VideoPickerWidget> {
  CameraController? _cameraController;
  bool _isCameraInitialized = false;
  bool _isRecording = false;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  /// Initializes the live camera feed for recording.
  ///
  /// Description: Looks for a front-facing camera and initializes the [CameraController].
  /// Side Effects: Prompts user for camera permissions on first use.
  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isNotEmpty) {
        // Use front camera if available
        final camera = cameras.firstWhere((c) => c.lensDirection == CameraLensDirection.front, orElse: () => cameras.first);

        _cameraController = CameraController(camera, ResolutionPreset.medium, enableAudio: false);

        await _cameraController!.initialize();
        if (mounted) {
          setState(() {
            _isCameraInitialized = true;
          });
        }
      }
    } catch (e) {
      debugPrint('Error initializing camera: $e');
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  /// Toggles video recording state.
  ///
  /// Description: Starts or stops recording using the initialized camera.
  /// Side Effects: Saves video file to disk and calls [onVideoSelected] when done.
  Future<void> _toggleRecording() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) return;

    if (_isRecording) {
      final file = await _cameraController!.stopVideoRecording();
      setState(() {
        _isRecording = false;
      });
      widget.onVideoSelected(file.path);
    } else {
      await _cameraController!.startVideoRecording();
      setState(() {
        _isRecording = true;
      });
    }
  }

  /// Opens the device's image picker to choose a video from the gallery.
  Future<void> _pickGalleryVideo() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      widget.onVideoSelected(pickedFile.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        Container(
          height: 320,
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 15, offset: const Offset(0, 5))],
          ),
          child: widget.selectedVideoPath != null
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.video_file, size: 64, color: AppColors.primary),
                    const SizedBox(height: 16),
                    Text(
                      l10n.videoSelected,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.text),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Text(
                        widget.selectedVideoPath!.split('/').last,
                        style: const TextStyle(fontSize: 14, color: AppColors.textLight),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 24),
                    OutlinedButton.icon(
                      onPressed: widget.onClear,
                      icon: const Icon(Icons.clear, color: AppColors.error),
                      label: Text(l10n.removeVideo, style: const TextStyle(color: AppColors.error)),
                      style: OutlinedButton.styleFrom(side: const BorderSide(color: AppColors.error)),
                    ),
                  ],
                )
              : _isCameraInitialized
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Center(child: CameraPreview(_cameraController!)),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.primary.withOpacity(0.1)),
                      child: const Icon(Icons.sign_language, size: 50, color: AppColors.primary),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Ready',
                      style: TextStyle(fontSize: 18, color: AppColors.primary.withOpacity(0.7), fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
        ),
        const SizedBox(height: 40),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                IconButton(
                  onPressed: widget.selectedVideoPath != null || _isRecording ? null : _pickGalleryVideo,
                  icon: const Icon(Icons.photo_library),
                  color: AppColors.primary,
                  iconSize: 28,
                  style: IconButton.styleFrom(backgroundColor: AppColors.primary.withOpacity(0.1), padding: const EdgeInsets.all(16)),
                ),
                const SizedBox(height: 8),
                Text(l10n.chooseFromGallery, style: const TextStyle(color: AppColors.textLight, fontSize: 12)),
              ],
            ),
            const SizedBox(width: 40),
            GestureDetector(
              onTap: widget.selectedVideoPath != null ? null : _toggleRecording,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(color: widget.selectedVideoPath != null ? Colors.grey : AppColors.primary, shape: BoxShape.circle),
                child: Icon(_isRecording ? Icons.stop : Icons.videocam, size: 36, color: Colors.white),
              ),
            ),
            const SizedBox(width: 40),
            const SizedBox(width: 60), // Visual balance for the gallery button
          ],
        ),
      ],
    );
  }
}
