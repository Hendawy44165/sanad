import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../l10n/app_localizations.dart';

class BooksFilterList extends StatelessWidget {
  final String selectedFilter;
  final Function(String) onFilterSelected;

  const BooksFilterList({
    super.key,
    required this.selectedFilter,
    required this.onFilterSelected,
  });

  @override
  Widget build(BuildContext context) {
    final filters = [
      AppLocalizations.of(context)!.allFormats,
      AppLocalizations.of(context)!.audioBook,
      AppLocalizations.of(context)!.braille,
      AppLocalizations.of(context)!.largePrint,
      AppLocalizations.of(context)!.eBook,
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
              final isSelected = filter == selectedFilter || (index == 0 && selectedFilter == 'All Formats');
              
              return Container(
                margin: const EdgeInsetsDirectional.only(end: 8),
                child: GestureDetector(
                  onTap: () => onFilterSelected(filter),
                  child: Chip(
                    avatar: index == 1
                        ? Icon(LucideIcons.headphones, size: 14, color: isSelected ? Colors.white : const Color(0xFF64748B))
                        : index == 2
                        ? Icon(LucideIcons.type, size: 14, color: isSelected ? Colors.white : const Color(0xFF64748B))
                        : null,
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
