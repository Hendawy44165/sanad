import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';

class JobsFilterList extends StatelessWidget {
  final String selectedFilter;
  final Function(String) onFilterSelected;

  const JobsFilterList({
    super.key,
    required this.selectedFilter,
    required this.onFilterSelected,
  });

  @override
  Widget build(BuildContext context) {
    final filters = [
      AppLocalizations.of(context)!.allJobs,
      AppLocalizations.of(context)!.remote,
      AppLocalizations.of(context)!.fullTime,
      AppLocalizations.of(context)!.hybrid,
      AppLocalizations.of(context)!.contract,
    ];

    return SliverPadding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      sliver: SliverToBoxAdapter(
        child: SizedBox(
          height: 40,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemCount: filters.length,
            itemBuilder: (context, index) {
              final filter = filters[index];
              final isSelected = filter == selectedFilter || (index == 0 && selectedFilter == 'All Jobs');
              
              return Container(
                margin: const EdgeInsetsDirectional.only(end: 8),
                child: GestureDetector(
                  onTap: () => onFilterSelected(filter),
                  child: Chip(
                    label: Text(
                      filter,
                      style: TextStyle(
                        color: isSelected ? Colors.white : const Color(0xFF1E293B),
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    backgroundColor: isSelected
                        ? const Color(0xFF004D40)
                        : Colors.white,
                    side: BorderSide(
                      color: isSelected
                          ? const Color(0xFF004D40)
                          : const Color(0xFFE2E8F0),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
