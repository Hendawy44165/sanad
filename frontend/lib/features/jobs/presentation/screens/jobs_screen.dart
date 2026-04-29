import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sanad/core/dependency_injection.dart';
import 'package:sanad/core/theme/app_colors.dart';
import 'package:sanad/l10n/app_localizations.dart';
import '../providers/jobs_provider.dart';
import '../widgets/jobs_app_bar.dart';
import '../widgets/jobs_search_section.dart';
import '../widgets/jobs_upload_cv_banner.dart';
import '../widgets/jobs_filter_list.dart';
import '../widgets/job_card.dart';

/// The primary screen for browsing and searching available jobs with infinite scrolling.
/// 
/// This screen implements a [ScrollController] to detect when the user reaches the
/// bottom of the list, triggering a fetch for the next page of results.
class JobsScreen extends ConsumerStatefulWidget {
  /// Creates a [JobsScreen] instance.
  const JobsScreen({super.key});

  @override
  ConsumerState<JobsScreen> createState() => _JobsScreenState();
}

class _JobsScreenState extends ConsumerState<JobsScreen> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// Listener callback for scroll events.
  /// 
  /// Side Effects: Triggers [fetchMore] when near the bottom of the scroll view.
  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      ref.read(getIt<JobsProvider>().notifier).fetchMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final jobsState = ref.watch(getIt<JobsProvider>());
    final jobsNotifier = ref.read(getIt<JobsProvider>().notifier);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => jobsNotifier.refresh(),
          color: AppColors.primary,
          child: jobsState.when(
            data: (state) => CustomScrollView(
              controller: _scrollController,
              slivers: [
                const JobsAppBar(),
                JobsSearchSection(
                  onChanged: (query) => jobsNotifier.updateSearchQuery(query),
                ),
                const JobsUploadCvBanner(),
                JobsFilterList(
                  selectedType: state.selectedType,
                  onTypeSelected: (type) => jobsNotifier.updateFilter(type),
                ),
                if (state.isSearching)
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 32),
                      child: Center(
                        child: CircularProgressIndicator(color: AppColors.primary),
                      ),
                    ),
                  ),
                if (state.jobs.isNotEmpty) ...[
                  _buildSectionHeader(context, state.jobs.length),
                  _buildJobsList(state.jobs, state.cvUrl != null),
                  if (state.isFetchingMore)
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 24),
                        child: Center(
                          child: CircularProgressIndicator(color: AppColors.primary),
                        ),
                      ),
                    ),
                ] else if (!state.isSearching)
                  _buildEmptyState(context),
                const SliverToBoxAdapter(child: SizedBox(height: 80)),
              ],
            ),
            loading: () => const CustomScrollView(
              slivers: [
                JobsAppBar(),
                SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  ),
                ),
              ],
            ),
            error: (err, stack) => CustomScrollView(
              slivers: [
                const JobsAppBar(),
                SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, size: 48, color: AppColors.error),
                        const SizedBox(height: 16),
                        Text('${l10n.errorPrefix}$err'),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => jobsNotifier.refresh(),
                          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                          child: Text(l10n.retry),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Builds a header showing the count of results found.
  Widget _buildSectionHeader(BuildContext context, int count) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      sliver: SliverToBoxAdapter(
        child: Text(
          AppLocalizations.of(context)!.availableJobsCount(count),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textLight,
          ),
        ),
      ),
    );
  }

  /// Builds the vertical list of [JobCard] widgets.
  Widget _buildJobsList(List jobs, bool hasCv) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final job = jobs[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: JobCard(job: job, hasCv: hasCv),
            );
          },
          childCount: jobs.length,
        ),
      ),
    );
  }

  /// Builds the placeholder UI when no jobs match the criteria.
  Widget _buildEmptyState(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_off_rounded, size: 64, color: AppColors.textLight),
            const SizedBox(height: 16),
            Text(
              l10n.noResultsFound,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.noJobsFoundMatchingCriteria,
              style: const TextStyle(color: AppColors.textLight),
            ),
          ],
        ),
      ),
    );
  }
}
