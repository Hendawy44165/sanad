import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:sanad/core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import 'profile_card.dart';
import 'profile_section_label.dart';

class CvSection extends StatelessWidget {
  final bool cvUploaded;
  final Function onUpload;

  const CvSection({super.key, required this.cvUploaded, required this.onUpload});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ProfileCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProfileSectionLabel(label: l10n.myCV, icon: LucideIcons.fileText),
          const SizedBox(height: 16),
          // CV status row
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: cvUploaded ? AppColors.secondary : AppColors.background, borderRadius: BorderRadius.circular(16)),
            child: Row(
              children: [
                Icon(cvUploaded ? LucideIcons.checkCircle : LucideIcons.fileUp, color: cvUploaded ? AppColors.primary : AppColors.textLight, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cvUploaded ? l10n.cvUploaded : l10n.noCvUploaded,
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: cvUploaded ? AppColors.primary : AppColors.text),
                      ),
                      Text(cvUploaded ? l10n.cvUploadedSubtitle : l10n.noCvSubtitle, style: const TextStyle(fontSize: 12, color: AppColors.textLight)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Upload / Re-upload button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => onUpload(),
              icon: const Icon(LucideIcons.upload, size: 18),
              label: Text(cvUploaded ? l10n.reuploadCV : l10n.uploadCVButton, style: const TextStyle(fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onPrimary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
