import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sanad/core/repositories/supabase_repository.dart';
import 'package:sanad/core/theme/app_colors.dart';
import 'package:sanad/features/doctors/data/models/doctor.dart';
import '../widgets/doctor_card.dart';

/// Screen that displays a list of medical specialists.
class DoctorsScreen extends ConsumerWidget {
  /// Creates a [DoctorsScreen].
  const DoctorsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final doctorsAsync = ref.watch(doctorsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: RefreshIndicator(
        onRefresh: () async => ref.refresh(doctorsProvider.future),
        child: _buildBody(doctorsAsync),
      ),
    );
  }

  /// Builds the application bar.
  PreferredSizeWidget _buildAppBar() {
    return AppBar(title: const Text('Medical Specialists'), centerTitle: false);
  }

  /// Builds the main body content based on the data state.
  Widget _buildBody(AsyncValue<List<Doctor>> doctorsAsync) {
    return doctorsAsync.when(
      data: (doctors) => _buildDoctorsList(doctors),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }

  /// Builds the list of doctors.
  Widget _buildDoctorsList(List<Doctor> doctors) {
    if (doctors.isEmpty) {
      return const Center(child: Text('No doctors found'));
    }
    return GridView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1, // Full width cards on mobile
        mainAxisSpacing: 24,
        childAspectRatio: 0.85, // Adjust based on content
      ),
      itemCount: doctors.length,
      itemBuilder: (context, index) {
        return DoctorCard(doctor: doctors[index]);
      },
    );
  }
}
