import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sanad/core/theme/app_colors.dart';
import 'package:sanad/features/doctors/logic/entities/doctor_entity.dart';
import 'package:sanad/features/doctors/presentation/widgets/doctor_card.dart';
import '../../../../l10n/app_localizations.dart';

/// A section on the dashboard displaying featured doctors.
///
/// It accepts a list of [DoctorEntity] and displays them using [DoctorCard].
class DashboardMedicalNetwork extends StatelessWidget {
  /// The list of featured doctors to display.
  final List<DoctorEntity> doctors;

  /// Creates a [DashboardMedicalNetwork] instance.
  const DashboardMedicalNetwork({super.key, required this.doctors});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (doctors.isEmpty) return const SliverToBoxAdapter(child: SizedBox.shrink());

    return SliverPadding(
      padding: const EdgeInsets.all(24),
      sliver: SliverToBoxAdapter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.medicalNetwork,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.text),
                ),
                TextButton(
                  onPressed: () => context.go('/doctors'),
                  child: Row(
                    children: [
                      Text(
                        l10n.findCare,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primary),
                      ),
                      const Icon(Icons.chevron_right, size: 20, color: AppColors.primary),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...doctors.map(
              (doctor) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: DoctorCard(doctor: doctor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
