import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sanad/core/repositories/supabase_repository.dart';
import 'package:sanad/core/theme/app_colors.dart';
import 'package:sanad/features/medications/data/models/medication_alarm.dart';
import 'add_medication_screen.dart';
import '../widgets/medication_card.dart';

/// Screen for managing medication reminders.
class MedicationsScreen extends ConsumerWidget {
  /// Creates a [MedicationsScreen].
  const MedicationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alarmsAsync = ref.watch(medicationAlarmsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      floatingActionButton: _buildFloatingActionButton(context),
      body: RefreshIndicator(
        onRefresh: () async => ref.refresh(medicationAlarmsProvider.future),
        child: _buildBody(alarmsAsync, context),
      ),
    );
  }

  /// Builds the application bar.
  PreferredSizeWidget _buildAppBar() {
    return AppBar(title: const Text('My Medications'), centerTitle: false);
  }

  /// Builds the floating action button for adding new medications.
  Widget _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _navigateToAddScreen(context),
      backgroundColor: AppColors.primary,
      child: const Icon(Icons.add),
    );
  }

  /// Builds the body content based on data state.
  Widget _buildBody(
    AsyncValue<List<MedicationAlarm>> alarmsAsync,
    BuildContext context,
  ) {
    return alarmsAsync.when(
      data: (alarms) => _buildContent(alarms, context),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }

  /// Builds the list or empty state.
  Widget _buildContent(List<MedicationAlarm> alarms, BuildContext context) {
    if (alarms.isEmpty) {
      return _buildEmptyState(context);
    }
    return _buildAlarmsList(alarms);
  }

  /// Builds the empty state view.
  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.medication_outlined,
            size: 64,
            color: AppColors.text.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'No medication reminders',
            style: TextStyle(
              color: AppColors.text.withValues(alpha: 0.6),
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () => _navigateToAddScreen(context),
            child: const Text('Add your first reminder'),
          ),
        ],
      ),
    );
  }

  /// Builds the list of medication alarms.
  Widget _buildAlarmsList(List<MedicationAlarm> alarms) {
    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(24),
      itemCount: alarms.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return MedicationCard(alarm: alarms[index]);
      },
    );
  }

  void _navigateToAddScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddMedicationScreen()),
    );
  }
}
