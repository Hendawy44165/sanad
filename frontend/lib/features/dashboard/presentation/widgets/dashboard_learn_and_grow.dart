import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sanad/core/theme/app_colors.dart';
import 'package:sanad/features/books/logic/entities/book_entity.dart';
import 'package:sanad/features/books/presentation/widgets/book_card.dart';
import '../../../../l10n/app_localizations.dart';

/// A section on the dashboard displaying featured books and resources.
///
/// It accepts a list of [BookEntity] and displays them using [BookCard].
class DashboardLearnAndGrow extends StatelessWidget {
  /// The list of featured books to display.
  final List<BookEntity> books;

  /// Creates a [DashboardLearnAndGrow] instance.
  const DashboardLearnAndGrow({super.key, required this.books});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (books.isEmpty) return const SliverToBoxAdapter(child: SizedBox.shrink());

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
                  l10n.learnAndGrow,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.text),
                ),
                TextButton(
                  onPressed: () => context.go('/books'),
                  child: Row(
                    children: [
                      Text(
                        l10n.browseBooks,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primary),
                      ),
                      const Icon(Icons.chevron_right, size: 20, color: AppColors.primary),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...books.map(
              (book) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: BookCard(book: book),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
