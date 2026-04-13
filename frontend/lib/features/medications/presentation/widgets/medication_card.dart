import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sanad/core/repositories/supabase_repository.dart';
import 'package:sanad/core/theme/app_colors.dart';
import 'package:sanad/features/medications/data/models/medication_alarm.dart';

/// Card widget to display a single medication alarm.
class MedicationCard extends ConsumerWidget {
  /// The alarm to display.
  final MedicationAlarm alarm;

  /// Creates a [MedicationCard].
  const MedicationCard({super.key, required this.alarm});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildIcon(),
          const SizedBox(width: 16),
          _buildInfoColumn(),
          _buildStatusColumn(ref),
        ],
      ),
    );
  }

  Widget _buildIcon() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(Icons.medication, color: AppColors.primary),
    );
  }

  Widget _buildInfoColumn() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            alarm.title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.text,
            ),
          ),
          if (alarm.dosage != null)
            Text(
              alarm.dosage!,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.text.withValues(alpha: 0.6),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatusColumn(WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          alarm.time,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.text,
          ),
        ),
        Switch(
          value: alarm.isActive,
          onChanged: (val) async {
            await ref
                .read(supabaseRepositoryProvider)
                .toggleAlarmStatus(alarm.id, val);
            ref.invalidate(medicationAlarmsProvider);
          },
          activeThumbColor: AppColors.primary,
        ),
      ],
    );
  }
}
