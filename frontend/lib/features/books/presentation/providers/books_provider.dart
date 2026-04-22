import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'books_state.dart';

class BooksNotifier extends AsyncNotifier<BooksState> {
  @override
  Future<BooksState> build() async {
    // Mocking initial data loading
    await Future.delayed(const Duration(milliseconds: 500));
    
    final initialBooks = [
      Book(
        title: 'The Art of Possibility',
        author: 'Rosamund Stone Zander',
        category: 'Personal Growth',
        formats: ['Audio Book', 'Braille', 'Large Print'],
      ),
      Book(
        title: 'A Still Small Voice',
        author: 'Echo Bodine',
        category: 'Spirituality',
        formats: ['Audio Book', 'Large Print', 'E-Book'],
      ),
      Book(
        title: 'The Brain That Changes Itself',
        author: 'Norman Doidge',
        category: 'Neuroscience',
        formats: ['Audio Book', 'Braille'],
      ),
    ];

    return BooksState(books: initialBooks);
  }

  void updateSearchQuery(String query) {
    if (state.value == null) return;
    state = AsyncValue.data(state.value!.copyWith(searchQuery: query));
  }

  void updateFilter(String filter) {
    if (state.value == null) return;
    state = AsyncValue.data(state.value!.copyWith(selectedFilter: filter));
  }
}

typedef BooksProvider = AsyncNotifierProvider<BooksNotifier, BooksState>;
