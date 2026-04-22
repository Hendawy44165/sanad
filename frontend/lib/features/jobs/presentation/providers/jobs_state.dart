class Job {
  final String title;
  final String company;
  final String description;
  final List<String> tags;
  final bool isVerified;

  Job({
    required this.title,
    required this.company,
    required this.description,
    required this.tags,
    this.isVerified = true,
  });
}

class JobsState {
  final List<Job> jobs;
  final String searchQuery;
  final String selectedFilter;

  JobsState({
    required this.jobs,
    this.searchQuery = '',
    this.selectedFilter = 'All Jobs',
  });

  JobsState copyWith({
    List<Job>? jobs,
    String? searchQuery,
    String? selectedFilter,
  }) {
    return JobsState(
      jobs: jobs ?? this.jobs,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedFilter: selectedFilter ?? this.selectedFilter,
    );
  }
}
