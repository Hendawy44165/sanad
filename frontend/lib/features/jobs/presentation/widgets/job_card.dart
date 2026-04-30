import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:sanad/core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../logic/entities/job_entity.dart';

/// A premium card widget for displaying job information to the user.
///
/// This widget presents a summary of a [JobEntity], including its title,
/// company, type, and location. It allows users to launch an external
/// application link if they have uploaded their CV.
class JobCard extends StatelessWidget {
  /// The job data to be displayed.
  final JobEntity job;

  /// Whether the current user has a CV on file.
  /// Determines if the "Apply Now" action is enabled.
  final bool hasCv;

  /// Creates a [JobCard] instance.
  ///
  /// Side Effects: None.
  /// Variables: [job] The source entity. [hasCv] Boolean gate for applications.
  const JobCard({super.key, required this.job, required this.hasCv});

  /// Logic to launch the job's application URL.
  ///
  /// Side Effects: Triggers external browser/app if [job.applyUrl] is valid.
  /// Variables: [context] used for snackbars.
  /// Assumptions: [url_launcher] package is correctly configured for the target OS.
  Future<void> _handleApply(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;

    if (!hasCv) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.uploadCV)));
      return;
    }

    if (job.applyUrl == null || job.applyUrl!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.applicationLinkUnavailable)));
      return;
    }

    final uri = Uri.parse(job.applyUrl!);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.couldNotOpenLink)));
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.couldNotOpenLink)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: AppColors.secondary, borderRadius: BorderRadius.circular(12)),
                child: const Icon(LucideIcons.briefcase, color: AppColors.primary),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      job.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.text),
                    ),
                    Text(job.company, style: const TextStyle(fontSize: 14, color: AppColors.textLight)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            job.description,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 14, color: AppColors.textLight, height: 1.5),
          ),
          const SizedBox(height: 16),
          _buildTags(context),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _handleApply(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onPrimary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(AppLocalizations.of(context)!.applyNow, style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the horizontal list of metadata tags (Remote, Type, Location).
  ///
  /// Variables: [context] for localization.
  Widget _buildTags(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final tags = [if (job.isRemote) l10n.remote, _getEmploymentTypeLabel(job.type, l10n), if (job.location != null) job.location!];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: tags
          .map(
            (tag) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(color: AppColors.inputFill, borderRadius: BorderRadius.circular(20)),
              child: Text(tag, style: const TextStyle(fontSize: 12, color: AppColors.textLight)),
            ),
          )
          .toList(),
    );
  }

  /// Maps the [JobType] enum to a localized string.
  ///
  /// Variables: [type] The source enum. [l10n] Localization source.
  String _getEmploymentTypeLabel(JobType type, AppLocalizations l10n) {
    switch (type) {
      case JobType.fullTime:
        return l10n.fullTime;
      case JobType.partTime:
        return l10n.partTime;
      case JobType.contract:
        return l10n.contract;
      case JobType.internship:
        return l10n.internship;
      case JobType.temporary:
        return l10n.temporary;
    }
  }
}
