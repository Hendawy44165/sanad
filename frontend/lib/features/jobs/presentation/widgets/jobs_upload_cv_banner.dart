import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:file_picker/file_picker.dart';
import 'package:sanad/core/dependency_injection.dart';
import 'package:sanad/core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../providers/jobs_provider.dart';

/// A banner widget allowing users to upload or update their CV for job matching.
/// 
/// This widget integrates with the [FilePicker] to select documents and uses
/// the [JobsNotifier] to handle the backend upload process.
class JobsUploadCvBanner extends ConsumerWidget {
  /// Creates a [JobsUploadCvBanner] instance.
  const JobsUploadCvBanner({super.key});

  /// Handles the file picking and upload trigger.
  /// 
  /// Side Effects: Triggers [JobsNotifier.uploadCv] on success.
  /// Variables: [context] for snacks. [ref] for notifier access.
  /// Assumptions: [file_picker] has permissions on the device.
  Future<void> _handleUpload(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context)!;
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'docx', 'doc'],
      );

      if (result != null && result.files.single.path != null) {
        final jobsNotifier = ref.read(getIt<JobsProvider>().notifier);
        await jobsNotifier.uploadCv(result.files.single.path!);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.errorPickingFile(e.toString()))),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jobsState = ref.watch(getIt<JobsProvider>());
    final l10n = AppLocalizations.of(context)!;
    final isUploaded = jobsState.value?.cvUrl != null;
    final isLoading = jobsState.value?.isActionLoading == true;

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      sliver: SliverToBoxAdapter(
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.onPrimary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      isUploaded ? LucideIcons.checkCircle : LucideIcons.fileText,
                      color: AppColors.onPrimary,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isUploaded ? l10n.cvUploaded : l10n.uploadCV,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.onPrimary,
                          ),
                        ),
                        Text(
                          isUploaded ? l10n.cvUploadedSubtitle : l10n.uploadCVSubtitle,
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.onPrimary.withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: isLoading ? null : () => _handleUpload(context, ref),
                  icon: isLoading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2, 
                            color: AppColors.primary,
                          ),
                        )
                      : const Icon(LucideIcons.upload, size: 18),
                  label: Text(
                    isLoading 
                        ? l10n.uploading 
                        : (isUploaded ? l10n.updateCV : l10n.uploadCVButton),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.onPrimary,
                    foregroundColor: AppColors.primary,
                    disabledBackgroundColor: AppColors.onPrimary.withValues(alpha: 0.8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
