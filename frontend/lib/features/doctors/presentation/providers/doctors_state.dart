import 'package:sanad/core/constants/codes.dart';
import '../../logic/entities/doctor_entity.dart';

/// Represents the UI state for the Doctors feature.
class DoctorsState {
  final List<DoctorEntity> allDoctors;
  final List<DoctorEntity> doctors;
  final String searchQuery;
  final String? selectedSpecialty;
  final Codes? error;
  final int currentPage;
  final bool hasNextPage;
  final bool isSearching;
  final bool isFetchingMore;

  DoctorsState({
    this.allDoctors = const [],
    this.doctors = const [],
    this.searchQuery = '',
    this.selectedSpecialty,
    this.error,
    this.currentPage = 1,
    this.hasNextPage = true,
    this.isSearching = false,
    this.isFetchingMore = false,
  });

  DoctorsState copyWith({
    List<DoctorEntity>? allDoctors,
    List<DoctorEntity>? doctors,
    String? searchQuery,
    String? selectedSpecialty,
    bool clearSpecialty = false,
    Codes? error,
    int? currentPage,
    bool? hasNextPage,
    bool? isSearching,
    bool? isFetchingMore,
  }) {
    return DoctorsState(
      allDoctors: allDoctors ?? this.allDoctors,
      doctors: doctors ?? this.doctors,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedSpecialty: clearSpecialty ? null : (selectedSpecialty ?? this.selectedSpecialty),
      error: error,
      currentPage: currentPage ?? this.currentPage,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      isSearching: isSearching ?? this.isSearching,
      isFetchingMore: isFetchingMore ?? this.isFetchingMore,
    );
  }
}
