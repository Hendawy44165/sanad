import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sanad/core/repositories/supabase_repository.dart';
import 'package:sanad/core/theme/app_colors.dart';
import 'package:sanad/core/services/notification_service.dart';
import 'package:sanad/features/medications/data/models/medication_alarm.dart';

/// Screen to add a new medication reminder.
class AddMedicationScreen extends ConsumerStatefulWidget {
  /// Creates an [AddMedicationScreen].
  const AddMedicationScreen({super.key});

  @override
  ConsumerState<AddMedicationScreen> createState() =>
      _AddMedicationScreenState();
}

class _AddMedicationScreenState extends ConsumerState<AddMedicationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _dosageController = TextEditingController();
  TimeOfDay _selectedTime = TimeOfDay.now();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  Future<void> _selectTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  Future<void> _saveMedication() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final userId = ref.read(supabaseClientProvider).auth.currentUser?.id;

      if (userId == null) {
        throw Exception('User not logged in');
      }

      final alarm = MedicationAlarm(
        id: '', // Supabase will generate ID
        userId: userId,
        title: _titleController.text,
        dosage: _dosageController.text.isNotEmpty
            ? _dosageController.text
            : null,
        time: _formatTime(_selectedTime),
      );

      final savedAlarm = await ref
          .read(supabaseRepositoryProvider)
          .addMedicationAlarm(alarm);

      // Schedule local notification if alarm is active
      if (savedAlarm.isActive) {
        await ref
            .read(notificationServiceProvider)
            .scheduleAlarm(
              id: savedAlarm.id.hashCode,
              title: 'Medication Reminder',
              body: "It's time to take ${savedAlarm.title}",
              time: _selectedTime,
            );
      }

      // Invalidate the provider to refresh the list
      ref.invalidate(medicationAlarmsProvider);

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text('Add Medication'),
      backgroundColor: Colors.transparent,
      elevation: 0,
      foregroundColor: AppColors.text,
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Form(key: _formKey, child: _buildFormContent()),
    );
  }

  Widget _buildFormContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(),
        const SizedBox(height: 24),
        _buildNameField(),
        const SizedBox(height: 16),
        _buildDosageField(),
        const SizedBox(height: 16),
        _buildTimePicker(),
        const SizedBox(height: 32),
        _buildSaveButton(),
      ],
    );
  }

  Widget _buildSectionTitle() {
    return const Text(
      'Medication Details',
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: AppColors.text,
      ),
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: _titleController,
      decoration: InputDecoration(
        labelText: 'Medication Name',
        hintText: 'e.g., Vitamin D',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        prefixIcon: const Icon(Icons.medication),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter medication name';
        }
        return null;
      },
    );
  }

  Widget _buildDosageField() {
    return TextFormField(
      controller: _dosageController,
      decoration: InputDecoration(
        labelText: 'Dosage (Optional)',
        hintText: 'e.g., 1 tablet, 500mg',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        prefixIcon: const Icon(Icons.scale),
      ),
    );
  }

  Widget _buildTimePicker() {
    return InkWell(
      onTap: () => _selectTime(context),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(Icons.access_time, color: Colors.grey),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Reminder Time',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                Text(
                  _selectedTime.format(context),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _saveMedication,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: _isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Text(
                'Save Reminder',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _dosageController.dispose();
    super.dispose();
  }
}
