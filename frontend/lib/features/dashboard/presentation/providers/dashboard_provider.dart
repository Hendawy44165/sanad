import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sanad/features/books/logic/repositories/books_repository.dart';
import 'package:sanad/features/doctors/logic/repositories/doctors_repository.dart';
import 'package:sanad/features/jobs/logic/repositories/jobs_repository.dart';
import 'dashboard_state.dart';

/// Notifier for the Dashboard feature that aggregates data from various sources.
class DashboardNotifier extends AsyncNotifier<DashboardState> {
  final JobsRepository _jobsRepository;
  final DoctorsRepository _doctorsRepository;
  final BooksRepository _booksRepository;

  /// Creates a [DashboardNotifier] with required repositories.
  DashboardNotifier(this._jobsRepository, this._doctorsRepository, this._booksRepository);

  @override
  Future<DashboardState> build() async {
    return _fetchDashboardData();
  }

  /// Fetches summary data for the dashboard from all relevant repositories.
  Future<DashboardState> _fetchDashboardData() async {
    // Fetch a small amount of data for each section
    final jobsResponse = await _jobsRepository.getJobs(limit: 2);
    final doctorsResponse = await _doctorsRepository.getDoctors(limit: 2);
    final booksResponse = await _booksRepository.getBooks(limit: 2);

    return DashboardState(featuredJobs: jobsResponse.isSuccess ? jobsResponse.data!.jobs : [], featuredDoctors: doctorsResponse.isSuccess ? doctorsResponse.data!.doctors : [], featuredBooks: booksResponse.isSuccess ? booksResponse.data!.books : []);
  }

  /// Refreshes the dashboard data.
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetchDashboardData());
  }
}

/// Provider for the [DashboardNotifier].
typedef DashboardProvider = AsyncNotifierProvider<DashboardNotifier, DashboardState>;
