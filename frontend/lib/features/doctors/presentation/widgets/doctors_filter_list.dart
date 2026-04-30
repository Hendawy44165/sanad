import 'package:flutter/material.dart';
import 'package:sanad/core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';

class DoctorsFilterList extends StatelessWidget {
  final String? selectedSpecialty;
  final Function(String?) onSpecialtySelected;

  const DoctorsFilterList({
    super.key,
    required this.selectedSpecialty,
    required this.onSpecialtySelected,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    final filterItems = [
      _FilterItem(label: l10n.all, specialty: null),
      _FilterItem(label: l10n.neurology, specialty: 'Neurology'),
      _FilterItem(label: l10n.physical, specialty: 'Physical Therapy'),
      _FilterItem(label: l10n.occupational, specialty: 'Occupational Therapy'),
      _FilterItem(label: l10n.speech, specialty: 'Speech Therapy'),
    ];

    return SliverToBoxAdapter(
      child: Container(
        height: 40,
        margin: const EdgeInsets.symmetric(vertical: 24),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          itemCount: filterItems.length,
          itemBuilder: (context, index) {
            final item = filterItems[index];
            final isSelected = item.specialty == selectedSpecialty;
            
            return Padding(
              padding: const EdgeInsetsDirectional.only(end: 8),
              child: ChoiceChip(
                label: Text(item.label),
                selected: isSelected,
                onSelected: (_) => onSpecialtySelected(item.specialty),
                selectedColor: AppColors.primary,
                backgroundColor: AppColors.surface,
                labelStyle: TextStyle(
                  color: isSelected ? AppColors.onPrimary : AppColors.text,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: isSelected ? AppColors.primary : AppColors.border,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _FilterItem {
  final String label;
  final String? specialty;

  _FilterItem({required this.label, this.specialty});
}
