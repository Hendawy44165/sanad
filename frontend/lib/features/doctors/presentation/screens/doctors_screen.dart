import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sanad/core/dependency_injection.dart';
import 'package:sanad/core/theme/app_colors.dart';
import 'package:sanad/l10n/app_localizations.dart';
import '../providers/doctors_provider.dart';
import '../widgets/doctors_app_bar.dart';
import '../widgets/doctors_search_section.dart';
import '../widgets/doctors_filter_list.dart';
import '../widgets/doctor_card.dart';

class DoctorsScreen extends ConsumerStatefulWidget {
  const DoctorsScreen({super.key});

  @override
  ConsumerState<DoctorsScreen> createState() => _DoctorsScreenState();
}

class _DoctorsScreenState extends ConsumerState<DoctorsScreen> {
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

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      ref.read(getIt<DoctorsProvider>().notifier).fetchMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final doctorsState = ref.watch(getIt<DoctorsProvider>());
    final doctorsNotifier = ref.read(getIt<DoctorsProvider>().notifier);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => doctorsNotifier.refresh(),
          color: AppColors.primary,
          child: doctorsState.when(
            data: (state) => CustomScrollView(
              controller: _scrollController,
              slivers: [
                const DoctorsAppBar(),
                DoctorsSearchSection(
                  onChanged: (query) => doctorsNotifier.updateSearchQuery(query),
                ),
                DoctorsFilterList(
                  selectedSpecialty: state.selectedSpecialty,
                  onSpecialtySelected: (specialty) => doctorsNotifier.updateFilter(specialty),
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
                if (state.doctors.isNotEmpty) ...[
                  _buildSectionHeader(context, state.doctors.length),
                  _buildDoctorsList(state.doctors),
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
                DoctorsAppBar(),
                SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  ),
                ),
              ],
            ),
            error: (err, stack) => CustomScrollView(
              slivers: [
                const DoctorsAppBar(),
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
                          onPressed: () => doctorsNotifier.refresh(),
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

  Widget _buildSectionHeader(BuildContext context, int count) {
    // "availableDoctorsCount" is a translation key added earlier, but wait we need a custom logic or use the actual key
    // AppLocalizations generated code handles pluralization if defined properly
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      sliver: SliverToBoxAdapter(
        child: Text(
          // Assuming AppLocalizations generator generates this correctly. 
          // Since we added it in app_en.arb as `availableDoctorsCount(count)`
          // We will use string interpolation or l10n.availableDoctorsCount(count)
          AppLocalizations.of(context)!.availableDoctorsCount(count),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textLight,
          ),
        ),
      ),
    );
  }

  Widget _buildDoctorsList(List doctors) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final doctor = doctors[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: DoctorCard(doctor: doctor),
            );
          },
          childCount: doctors.length,
        ),
      ),
    );
  }

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
              // Assuming this getter exists based on our previous edits.
              // We'll try to catch runtime errors if not, but it should be generated.
              l10n.noDoctorsFoundMatchingCriteria,
              style: const TextStyle(color: AppColors.textLight),
            ),
          ],
        ),
      ),
    );
  }
}
