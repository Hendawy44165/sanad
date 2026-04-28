import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sanad/core/dependency_injection.dart';
import '../../../../l10n/app_localizations.dart';
import '../providers/doctors_provider.dart';
import '../widgets/doctors_app_bar.dart';
import '../widgets/doctors_search_section.dart';
import '../widgets/doctors_filter_list.dart';
import '../widgets/doctor_card.dart';

class DoctorsScreen extends ConsumerWidget {
  const DoctorsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final doctorsState = ref.watch(getIt<DoctorsProvider>());
    final doctorsNotifier = ref.read(getIt<DoctorsProvider>().notifier);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F5F2),
      body: SafeArea(
        child: doctorsState.when(
          data: (state) => CustomScrollView(
            slivers: [
              const DoctorsAppBar(),
              DoctorsSearchSection(
                onChanged: (query) => doctorsNotifier.updateSearchQuery(query),
              ),
              DoctorsFilterList(
                selectedFilter: state.selectedFilter,
                onFilterSelected: (filter) => doctorsNotifier.updateFilter(filter),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(24),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final doctor = state.doctors[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: DoctorCard(doctor: doctor),
                      );
                    },
                    childCount: state.doctors.length,
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 40)),
            ],
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text('${l10n.errorPrefix}$err')),
        ),
      ),
    );
  }
}
