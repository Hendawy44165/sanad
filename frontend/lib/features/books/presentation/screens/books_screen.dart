import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sanad/core/dependency_injection.dart';
import '../providers/books_provider.dart';
import '../widgets/books_app_bar.dart';
import '../widgets/books_search_section.dart';
import '../widgets/books_formats_banner.dart';
import '../widgets/books_filter_list.dart';
import '../widgets/book_card.dart';

class BooksScreen extends ConsumerWidget {
  const BooksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final booksState = ref.watch(getIt<BooksProvider>());
    final booksNotifier = ref.read(getIt<BooksProvider>().notifier);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F5F2),
      body: SafeArea(
        child: booksState.when(
          data: (state) => CustomScrollView(
            slivers: [
              const BooksAppBar(),
              BooksSearchSection(
                onChanged: (query) => booksNotifier.updateSearchQuery(query),
              ),
              const BooksFormatsBanner(),
              BooksFilterList(
                selectedFilter: state.selectedFilter,
                onFilterSelected: (filter) => booksNotifier.updateFilter(filter),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final book = state.books[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: BookCard(book: book),
                      );
                    },
                    childCount: state.books.length,
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 40)),
            ],
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text('Error: $err')),
        ),
      ),
    );
  }
}
