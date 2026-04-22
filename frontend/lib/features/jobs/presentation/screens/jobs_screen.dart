import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sanad/core/dependency_injection.dart';
import 'package:sanad/l10n/app_localizations.dart';
import '../providers/jobs_provider.dart';
import '../widgets/jobs_app_bar.dart';
import '../widgets/jobs_search_section.dart';
import '../widgets/jobs_upload_cv_banner.dart';
import '../widgets/jobs_filter_list.dart';
import '../widgets/job_card.dart';

class JobsScreen extends ConsumerWidget {
  const JobsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jobsState = ref.watch(getIt<JobsProvider>());
    final jobsNotifier = ref.read(getIt<JobsProvider>().notifier);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F5F2),
      body: SafeArea(
        child: jobsState.when(
          data: (state) => CustomScrollView(
            slivers: [
              const JobsAppBar(),
              JobsSearchSection(
                onChanged: (query) => jobsNotifier.updateSearchQuery(query),
              ),
              const JobsUploadCvBanner(),
              JobsFilterList(
                selectedFilter: state.selectedFilter,
                onFilterSelected: (filter) => jobsNotifier.updateFilter(filter),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                sliver: SliverToBoxAdapter(
                  child: Text(
                    AppLocalizations.of(context)!.availableJobsCount(state.jobs.length),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(24),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final job = state.jobs[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: JobCard(job: job),
                      );
                    },
                    childCount: state.jobs.length,
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 40)),
            ],
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text('Error: $err')),
        ),
      ),
    );
  }
}
