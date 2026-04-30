import 'package:sanad/features/jobs/logic/entities/job_entity.dart';
import 'package:sanad/features/doctors/logic/entities/doctor_entity.dart';
import 'package:sanad/features/books/logic/entities/book_entity.dart';

/// Represents the UI state for the Dashboard feature.
/// 
/// This state aggregates data from multiple features to provide a summary
/// view on the main screen.
class DashboardState {
  /// Featured jobs to display on the dashboard.
  final List<JobEntity> featuredJobs;
  
  /// Featured doctors to display on the dashboard.
  final List<DoctorEntity> featuredDoctors;
  
  /// Featured books/products to display on the dashboard.
  final List<BookEntity> featuredBooks;

  /// Creates a [DashboardState] instance.
  DashboardState({
    this.featuredJobs = const [],
    this.featuredDoctors = const [],
    this.featuredBooks = const [],
  });

  /// Returns a copy of the state with updated fields.
  DashboardState copyWith({
    List<JobEntity>? featuredJobs,
    List<DoctorEntity>? featuredDoctors,
    List<BookEntity>? featuredBooks,
  }) {
    return DashboardState(
      featuredJobs: featuredJobs ?? this.featuredJobs,
      featuredDoctors: featuredDoctors ?? this.featuredDoctors,
      featuredBooks: featuredBooks ?? this.featuredBooks,
    );
  }
}
