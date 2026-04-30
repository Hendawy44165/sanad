import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sanad/core/constants/codes.dart';
import '../../logic/repositories/doctors_repository.dart';
import '../../logic/entities/doctor_entity.dart';
import 'doctors_state.dart';

class DoctorsNotifier extends AsyncNotifier<DoctorsState> {
  final DoctorsRepository _repository;
  Timer? _searchDebounce;

  DoctorsNotifier(this._repository);

  @override
  Future<DoctorsState> build() async {
    final response = await _repository.getDoctors();

    if (response.isSuccess) {
      final listEntity = response.data!;
      return DoctorsState(allDoctors: listEntity.doctors, doctors: listEntity.doctors, currentPage: 1, hasNextPage: listEntity.hasNextPage);
    }
    return DoctorsState(error: response.errorCode);
  }

  Future<void> fetchMore() async {
    final oldState = state.value;
    if (oldState == null || oldState.isFetchingMore || !oldState.hasNextPage) return;

    state = AsyncValue.data(oldState.copyWith(isFetchingMore: true));

    final nextPage = oldState.currentPage + 1;
    final response = await _repository.getDoctors(query: oldState.searchQuery, specialty: oldState.selectedSpecialty, page: nextPage);

    if (response.isSuccess) {
      final listEntity = response.data!;
      final newAllDoctors = [...oldState.allDoctors, ...listEntity.doctors];

      state = AsyncValue.data(oldState.copyWith(allDoctors: newAllDoctors, doctors: _applyLocalFilters(newAllDoctors, oldState.selectedSpecialty), currentPage: nextPage, hasNextPage: listEntity.hasNextPage, isFetchingMore: false));
    } else {
      state = AsyncValue.data(oldState.copyWith(isFetchingMore: false, error: response.errorCode ?? Codes.unknown));
    }
  }

  void updateSearchQuery(String query) {
    _searchDebounce?.cancel();

    final oldState = state.value;
    if (oldState == null) return;

    state = AsyncValue.data(oldState.copyWith(isSearching: true, searchQuery: query));

    _searchDebounce = Timer(const Duration(milliseconds: 500), () async {
      final response = await _repository.getDoctors(query: query, specialty: oldState.selectedSpecialty, page: 1);

      if (response.isSuccess) {
        final listEntity = response.data!;
        state = AsyncValue.data(oldState.copyWith(allDoctors: listEntity.doctors, doctors: _applyLocalFilters(listEntity.doctors, oldState.selectedSpecialty), currentPage: 1, hasNextPage: listEntity.hasNextPage, isSearching: false));
      } else {
        state = AsyncValue.data(oldState.copyWith(isSearching: false, error: response.errorCode ?? Codes.unknown));
      }
    });
  }

  Future<void> updateFilter(String? specialty) async {
    final oldState = state.value;
    if (oldState == null) return;

    final filteredDoctors = _applyLocalFilters(oldState.allDoctors, specialty);

    state = AsyncValue.data(oldState.copyWith(doctors: filteredDoctors, selectedSpecialty: specialty, clearSpecialty: specialty == null));
  }

  List<DoctorEntity> _applyLocalFilters(List<DoctorEntity> list, String? specialty) {
    if (specialty == null) return list;
    return list.where((doctor) => doctor.specialty == specialty).toList();
  }

  void clearError() {
    final oldState = state.value;
    if (oldState == null) return;
    state = AsyncValue.data(oldState.copyWith(error: null));
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    final response = await _repository.getDoctors(page: 1);

    if (response.isSuccess) {
      final listEntity = response.data!;
      state = AsyncValue.data(DoctorsState(allDoctors: listEntity.doctors, doctors: listEntity.doctors, currentPage: 1, hasNextPage: listEntity.hasNextPage));
    } else {
      state = AsyncValue.data(DoctorsState(error: response.errorCode));
    }
  }
}

typedef DoctorsProvider = AsyncNotifierProvider<DoctorsNotifier, DoctorsState>;
