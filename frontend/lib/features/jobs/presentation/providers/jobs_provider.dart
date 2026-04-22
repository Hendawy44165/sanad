import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'jobs_state.dart';

class JobsNotifier extends AsyncNotifier<JobsState> {
  @override
  Future<JobsState> build() async {
    // Mocking initial data loading
    await Future.delayed(const Duration(milliseconds: 500));
    
    final initialJobs = [
      Job(
        title: 'Senior UX Researcher',
        company: 'TechFlow Innovations',
        description: 'Research user experiences for accessibility-focused products. Work fully remote.',
        tags: ['Remote', 'Full-Time'],
      ),
      Job(
        title: 'Accessibility Specialist',
        company: 'Global Health Corp',
        description: 'Audit and improve digital accessibility across health platforms.',
        tags: ['Hybrid', 'Contract'],
      ),
      Job(
        title: 'Remote Data Analyst',
        company: 'DataMind Labs',
        description: 'Analyze datasets and create reports. Flexible hours, adaptive tools provided.',
        tags: ['Remote', 'Part-Time'],
      ),
    ];

    return JobsState(jobs: initialJobs);
  }

  void updateSearchQuery(String query) {
    if (state.value == null) return;
    state = AsyncValue.data(state.value!.copyWith(searchQuery: query));
  }

  void updateFilter(String filter) {
    if (state.value == null) return;
    state = AsyncValue.data(state.value!.copyWith(selectedFilter: filter));
  }
}

typedef JobsProvider = AsyncNotifierProvider<JobsNotifier, JobsState>;
