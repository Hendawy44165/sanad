import 'package:flutter/material.dart';
import 'package:sanad/core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';

class BooksFilterList extends StatelessWidget {
  final String? selectedCategory;
  final Function(String?) onCategorySelected;

  const BooksFilterList({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    final filterItems = [
      _FilterItem(label: l10n.allFormats, category: null),
      _FilterItem(label: l10n.audioBook, category: 'Audio'),
      _FilterItem(label: l10n.braille, category: 'Braille'),
      _FilterItem(label: l10n.eBook, category: 'E-Book'),
      _FilterItem(label: l10n.largePrint, category: 'Large Print'),
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
            final isSelected = item.category == selectedCategory;
            
            return Padding(
              padding: const EdgeInsetsDirectional.only(end: 8),
              child: ChoiceChip(
                label: Text(item.label),
                selected: isSelected,
                onSelected: (_) => onCategorySelected(item.category),
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
  final String? category;

  _FilterItem({required this.label, this.category});
}
