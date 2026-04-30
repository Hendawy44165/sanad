import 'package:sanad/core/constants/codes.dart';
import '../../logic/entities/job_entity.dart';

/// Represents the UI state for the Jobs feature.
///
/// This state handles paginated data, search results, and filtering logic.
class JobsState {
  /// The complete list of jobs fetched from the API across all pages.
  final List<JobEntity> allJobs;

  /// The list of jobs currently being displayed in the UI (filtered).
  final List<JobEntity> jobs;

  /// The user's current search string.
  final String searchQuery;

  /// The currently active employment type filter.
  final JobType? selectedType;

  /// The remote URL to the user's active CV on the server.
  final String? cvUrl;

  /// Any error code returned by the repository.
  final Codes? error;

  /// The current page number for pagination.
  final int currentPage;

  /// Indicates if more pages are available on the server.
  final bool hasNextPage;

  /// Indicates if an asynchronous action (like CV upload) is pending.
  final bool isActionLoading;

  /// Indicates if a search or initial load is in progress.
  final bool isSearching;

  /// Indicates if the next page of results is currently being fetched.
  final bool isFetchingMore;

  JobsState({this.allJobs = const [], this.jobs = const [], this.searchQuery = '', this.selectedType, this.cvUrl, this.error, this.currentPage = 1, this.hasNextPage = true, this.isActionLoading = false, this.isSearching = false, this.isFetchingMore = false});

  /// Returns a copy of the state with updated fields.
  JobsState copyWith({
    List<JobEntity>? allJobs,
    List<JobEntity>? jobs,
    String? searchQuery,
    JobType? selectedType,
    bool clearType = false,
    String? cvUrl,
    Codes? error,
    int? currentPage,
    bool? hasNextPage,
    bool? isActionLoading,
    bool? isSearching,
    bool? isFetchingMore,
  }) {
    return JobsState(
      allJobs: allJobs ?? this.allJobs,
      jobs: jobs ?? this.jobs,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedType: clearType ? null : (selectedType ?? this.selectedType),
      cvUrl: cvUrl ?? this.cvUrl,
      error: error,
      currentPage: currentPage ?? this.currentPage,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      isActionLoading: isActionLoading ?? this.isActionLoading,
      isSearching: isSearching ?? this.isSearching,
      isFetchingMore: isFetchingMore ?? this.isFetchingMore,
    );
  }
}
