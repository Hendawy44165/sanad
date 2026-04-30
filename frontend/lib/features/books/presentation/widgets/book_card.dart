import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:sanad/core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../logic/entities/book_entity.dart';

class BookCard extends StatelessWidget {
  final BookEntity book;

  const BookCard({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 70,
                height: 90,
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  borderRadius: BorderRadius.circular(8),
                  image: book.thumbnailUrl != null ? DecorationImage(image: NetworkImage(book.thumbnailUrl!), fit: BoxFit.cover) : null,
                ),
                child: book.thumbnailUrl == null ? const Icon(LucideIcons.book, color: AppColors.primary, size: 30) : null,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      book.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.text),
                    ),
                    if (book.brand != null) Text(book.brand!, style: const TextStyle(fontSize: 14, color: AppColors.textLight)),
                    const SizedBox(height: 8),
                    Text(
                      '${book.price} ${book.currency}',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.primary),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (book.description != null && book.description!.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              book.description!,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 14, color: AppColors.textLight, height: 1.5),
            ),
          ],
          const SizedBox(height: 16),
          _buildTags(context),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.bookRequestSuccess)));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onPrimary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(AppLocalizations.of(context)!.requestBookShort, style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTags(BuildContext context) {
    final tags = [book.category, if (!book.inStock) 'Out of Stock', ...book.accessibilityTags];

    if (tags.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: tags
          .map(
            (tag) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(color: AppColors.inputFill, borderRadius: BorderRadius.circular(20)),
              child: Text(tag, style: const TextStyle(fontSize: 12, color: AppColors.textLight)),
            ),
          )
          .toList(),
    );
  }
}
