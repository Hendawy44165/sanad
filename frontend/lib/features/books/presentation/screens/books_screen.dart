import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sanad/core/dependency_injection.dart';
import 'package:sanad/core/theme/app_colors.dart';
import 'package:sanad/l10n/app_localizations.dart';
import '../providers/books_provider.dart';
import '../widgets/books_app_bar.dart';
import '../widgets/books_search_section.dart';
import '../widgets/books_filter_list.dart';
import '../widgets/book_card.dart';

class BooksScreen extends ConsumerStatefulWidget {
  const BooksScreen({super.key});

  @override
  ConsumerState<BooksScreen> createState() => _BooksScreenState();
}

class _BooksScreenState extends ConsumerState<BooksScreen> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      ref.read(getIt<BooksProvider>().notifier).fetchMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final booksState = ref.watch(getIt<BooksProvider>());
    final booksNotifier = ref.read(getIt<BooksProvider>().notifier);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => booksNotifier.refresh(),
          color: AppColors.primary,
          child: booksState.when(
            data: (state) => CustomScrollView(
              controller: _scrollController,
              slivers: [
                const BooksAppBar(),
                BooksSearchSection(
                  onChanged: (query) => booksNotifier.updateSearchQuery(query),
                ),
                BooksFilterList(
                  selectedCategory: state.selectedCategory,
                  onCategorySelected: (category) => booksNotifier.updateFilter(category),
                ),
                if (state.isSearching)
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 32),
                      child: Center(
                        child: CircularProgressIndicator(color: AppColors.primary),
                      ),
                    ),
                  ),
                if (state.books.isNotEmpty) ...[
                  _buildSectionHeader(context, state.books.length),
                  _buildBooksList(state.books),
                  if (state.isFetchingMore)
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 24),
                        child: Center(
                          child: CircularProgressIndicator(color: AppColors.primary),
                        ),
                      ),
                    ),
                ] else if (!state.isSearching)
                  _buildEmptyState(context),
                const SliverToBoxAdapter(child: SizedBox(height: 80)),
              ],
            ),
            loading: () => const CustomScrollView(
              slivers: [
                BooksAppBar(),
                SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  ),
                ),
              ],
            ),
            error: (err, stack) => CustomScrollView(
              slivers: [
                const BooksAppBar(),
                SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, size: 48, color: AppColors.error),
                        const SizedBox(height: 16),
                        Text('${l10n.errorPrefix}$err'),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => booksNotifier.refresh(),
                          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                          child: Text(l10n.retry),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, int count) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      sliver: SliverToBoxAdapter(
        child: Text(
          AppLocalizations.of(context)!.availableBooksCount(count),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textLight,
          ),
        ),
      ),
    );
  }

  Widget _buildBooksList(List books) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final book = books[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: BookCard(book: book),
            );
          },
          childCount: books.length,
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_off_rounded, size: 64, color: AppColors.textLight),
            const SizedBox(height: 16),
            Text(
              l10n.noResultsFound,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.noBooksFoundMatchingCriteria,
              style: const TextStyle(color: AppColors.textLight),
            ),
          ],
        ),
      ),
    );
  }
}
