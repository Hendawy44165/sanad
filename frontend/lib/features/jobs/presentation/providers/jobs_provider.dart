import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sanad/core/constants/codes.dart';
import '../../logic/repositories/jobs_repository.dart';
import '../../logic/entities/job_entity.dart';
import 'jobs_state.dart';

/// Notifier for the Jobs feature that handles data fetching, pagination, and state transitions.
/// 
/// This notifier implements infinite scrolling by tracking the current page and fetching
/// subsequent pages as the user scrolls. It also maintains a local cache for instant filtering.
class JobsNotifier extends AsyncNotifier<JobsState> {
  final JobsRepository _repository;
  Timer? _searchDebounce;

  /// Injects the required repository via constructor.
  /// 
  /// Variables: [_repository] used for API interactions.
  JobsNotifier(this._repository);

  /// Initializes the state by fetching the first page of jobs.
  /// 
  /// Side Effects: Updates [state] with the initial list and pagination metadata.
  /// Assumptions: The repository is properly configured in the DI container.
  @override
  Future<JobsState> build() async {
    final response = await _repository.getJobs(page: 1);
    
    if (response.isSuccess) {
      final listEntity = response.data!;
      return JobsState(
        allJobs: listEntity.jobs,
        jobs: listEntity.jobs,
        currentPage: 1,
        hasNextPage: listEntity.hasNext,
      );
    }
    return JobsState(error: response.errorCode);
  }

  /// Fetches the next page of jobs if available.
  /// 
  /// Description: Increments the page count and appends new results to the existing lists.
  /// Side Effects: Sets [isFetchingMore] to true, updates [allJobs], [jobs], and [currentPage].
  /// Assumptions: [state.value] is initialized and [hasNextPage] is true.
  Future<void> fetchMore() async {
    final oldState = state.value;
    if (oldState == null || oldState.isFetchingMore || !oldState.hasNextPage) return;

    state = AsyncValue.data(oldState.copyWith(isFetchingMore: true));

    final nextPage = oldState.currentPage + 1;
    final response = await _repository.getJobs(
      query: oldState.searchQuery,
      page: nextPage,
    );

    if (response.isSuccess) {
      final listEntity = response.data!;
      final newAllJobs = [...oldState.allJobs, ...listEntity.jobs];
      
      state = AsyncValue.data(oldState.copyWith(
        allJobs: newAllJobs,
        jobs: _applyLocalFilters(newAllJobs, oldState.selectedType),
        currentPage: nextPage,
        hasNextPage: listEntity.hasNext,
        isFetchingMore: false,
      ));
    } else {
      state = AsyncValue.data(oldState.copyWith(
        isFetchingMore: false,
        error: response.errorCode ?? Codes.unknown,
      ));
    }
  }

  /// Debounces and executes a new search query, resetting pagination.
  /// 
  /// Description: Cancels existing timers and resets to page 1 for the new query.
  /// Side Effects: Sets [isSearching] to true, updates all data lists.
  /// Variables: [query] The text to search for.
  void updateSearchQuery(String query) {
    _searchDebounce?.cancel();
    
    final oldState = state.value;
    if (oldState == null) return;

    state = AsyncValue.data(oldState.copyWith(
      isSearching: true, 
      searchQuery: query,
    ));

    _searchDebounce = Timer(const Duration(milliseconds: 500), () async {
      final response = await _repository.getJobs(query: query, page: 1);
      
      if (response.isSuccess) {
        final listEntity = response.data!;
        state = AsyncValue.data(oldState.copyWith(
          allJobs: listEntity.jobs,
          jobs: _applyLocalFilters(listEntity.jobs, oldState.selectedType),
          currentPage: 1,
          hasNextPage: listEntity.hasNext,
          isSearching: false,
        ));
      } else {
        state = AsyncValue.data(oldState.copyWith(
          isSearching: false,
          error: response.errorCode ?? Codes.unknown,
        ));
      }
    });
  }

  /// Filters the current list of jobs on the client side.
  /// 
  /// Description: Filters [allJobs] by the provided [JobType].
  /// Side Effects: Updates [jobs] and [selectedType] in the state.
  /// Variables: [type] The employment type to filter for.
  Future<void> updateFilter(JobType? type) async {
    final oldState = state.value;
    if (oldState == null) return;
    
    final filteredJobs = _applyLocalFilters(oldState.allJobs, type);

    state = AsyncValue.data(oldState.copyWith(
      jobs: filteredJobs,
      selectedType: type,
    ));
  }

  /// Helper to filter a list of jobs based on type.
  List<JobEntity> _applyLocalFilters(List<JobEntity> list, JobType? type) {
    if (type == null) return list;
    return list.where((job) => job.type == type).toList();
  }

  /// Manages CV file upload and updates the [cvPath].
  Future<void> uploadCv(String filePath) async {
    final oldState = state.value;
    if (oldState == null) return;

    state = AsyncValue.data(oldState.copyWith(isActionLoading: true));
    
    final response = await _repository.uploadCv(filePath);
    
    if (response.isSuccess) {
      state = AsyncValue.data(oldState.copyWith(
        cvPath: response.data,
        isActionLoading: false,
      ));
    } else {
      state = AsyncValue.data(oldState.copyWith(
        isActionLoading: false,
        error: response.errorCode ?? Codes.unknown,
      ));
    }
  }

  /// Resets the error code in the state.
  void clearError() {
    final oldState = state.value;
    if (oldState == null) return;
    state = AsyncValue.data(oldState.copyWith(error: null));
  }

  /// Forces a re-fetch of the first page, resetting all pagination.
  Future<void> refresh() async {
    state = const AsyncLoading();
    final response = await _repository.getJobs(page: 1);
    
    if (response.isSuccess) {
      final listEntity = response.data!;
      state = AsyncValue.data(JobsState(
        allJobs: listEntity.jobs,
        jobs: listEntity.jobs,
        currentPage: 1,
        hasNextPage: listEntity.hasNext,
      ));
    } else {
      state = AsyncValue.data(JobsState(error: response.errorCode));
    }
  }
}

/// Typedef for the global Jobs notifier provider.
typedef JobsProvider = AsyncNotifierProvider<JobsNotifier, JobsState>;
