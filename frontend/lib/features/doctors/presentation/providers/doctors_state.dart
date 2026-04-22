class Doctor {
  final String name;
  final String specialty;
  final double rating;
  final int reviews;
  final List<String> badges;

  Doctor({
    required this.name,
    required this.specialty,
    required this.rating,
    required this.reviews,
    required this.badges,
  });
}

class DoctorsState {
  final List<Doctor> doctors;
  final String searchQuery;
  final String selectedFilter;

  DoctorsState({
    required this.doctors,
    this.searchQuery = '',
    this.selectedFilter = 'All',
  });

  DoctorsState copyWith({
    List<Doctor>? doctors,
    String? searchQuery,
    String? selectedFilter,
  }) {
    return DoctorsState(
      doctors: doctors ?? this.doctors,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedFilter: selectedFilter ?? this.selectedFilter,
    );
  }
}
