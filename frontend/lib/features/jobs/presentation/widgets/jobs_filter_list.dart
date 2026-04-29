import 'package:flutter/material.dart';
import 'package:sanad/core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../logic/entities/job_entity.dart';

/// A horizontal scrollable list of filter chips for job types.
/// 
/// This widget allows users to quickly toggle between different employment
/// types (Full-Time, Contract, etc.). It updates the UI instantly via
/// client-side filtering.
class JobsFilterList extends StatelessWidget {
  /// The currently active filter type.
  final JobType? selectedType;
  
  /// Callback triggered when a new filter is selected.
  final Function(JobType?) onTypeSelected;

  /// Creates a [JobsFilterList] instance.
  /// 
  /// Side Effects: None.
  /// Variables: [selectedType] Current active state. [onTypeSelected] Change handler.
  const JobsFilterList({
    super.key,
    required this.selectedType,
    required this.onTypeSelected,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    // Define the available filter options
    final filterItems = [
      _FilterItem(label: l10n.allJobs, type: null),
      _FilterItem(label: l10n.fullTime, type: JobType.fullTime),
      _FilterItem(label: l10n.contract, type: JobType.contract),
      _FilterItem(label: l10n.partTime, type: JobType.partTime),
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
            final isSelected = item.type == selectedType;
            
            return Padding(
              padding: const EdgeInsetsDirectional.only(end: 8),
              child: ChoiceChip(
                label: Text(item.label),
                selected: isSelected,
                onSelected: (_) => onTypeSelected(item.type),
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

/// Private helper class to represent a filter option.
class _FilterItem {
  final String label;
  final JobType? type;

  _FilterItem({required this.label, this.type});
}
