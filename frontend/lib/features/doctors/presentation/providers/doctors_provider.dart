import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'doctors_state.dart';

class DoctorsNotifier extends AsyncNotifier<DoctorsState> {
  @override
  Future<DoctorsState> build() async {
    // Mocking initial data loading
    await Future.delayed(const Duration(milliseconds: 500));
    
    final initialDoctors = [
      Doctor(
        name: 'Dr. Layla Khaled',
        specialty: 'Neurology Specialist',
        rating: 4.9,
        reviews: 120,
        badges: ['Wheelchair Access', 'Sign Language', 'Audio Aids'],
      ),
      Doctor(
        name: 'Dr. Omar Nasser',
        specialty: 'Physical Therapy',
        rating: 4.8,
        reviews: 85,
        badges: ['Wheelchair Access', 'Sign Language'],
      ),
      Doctor(
        name: 'Dr. Sarah Ahmed',
        specialty: 'Occupational Therapy',
        rating: 4.7,
        reviews: 64,
        badges: ['Wheelchair Access', 'Audio Aids'],
      ),
    ];

    return DoctorsState(doctors: initialDoctors);
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

typedef DoctorsProvider = AsyncNotifierProvider<DoctorsNotifier, DoctorsState>;
