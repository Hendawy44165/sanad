import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sanad/core/theme/app_colors.dart';
import 'package:sanad/features/jobs/logic/entities/job_entity.dart';
import 'package:sanad/features/jobs/presentation/widgets/job_card.dart';
import '../../../../l10n/app_localizations.dart';

/// A section on the dashboard displaying featured job opportunities.
///
/// It accepts a list of [JobEntity] and displays them using [JobCard].
class DashboardOpportunities extends StatelessWidget {
  /// The list of featured jobs to display.
  final List<JobEntity> jobs;

  /// Creates a [DashboardOpportunities] instance.
  const DashboardOpportunities({super.key, required this.jobs});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (jobs.isEmpty) return const SliverToBoxAdapter(child: SizedBox.shrink());

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      sliver: SliverToBoxAdapter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.opportunities,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.text),
                ),
                TextButton(
                  onPressed: () => context.go('/jobs'),
                  child: Row(
                    children: [
                      Text(
                        l10n.viewAllJobs,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primary),
                      ),
                      const Icon(Icons.chevron_right, size: 20, color: AppColors.primary),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...jobs.map(
              (job) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: JobCard(job: job, hasCv: true), // For dashboard, assume CV is present for UI consistency or handle properly
              ),
            ),
          ],
        ),
      ),
    );
  }
}
