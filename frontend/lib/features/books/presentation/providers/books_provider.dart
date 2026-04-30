import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sanad/core/constants/codes.dart';
import '../../logic/repositories/books_repository.dart';
import '../../logic/entities/book_entity.dart';
import 'books_state.dart';

class BooksNotifier extends AsyncNotifier<BooksState> {
  final BooksRepository _repository;
  Timer? _searchDebounce;

  BooksNotifier(this._repository);

  @override
  Future<BooksState> build() async {
    final response = await _repository.getBooks();

    if (response.isSuccess) {
      final listEntity = response.data!;
      return BooksState(allBooks: listEntity.books, books: listEntity.books, currentPage: 1, hasNextPage: listEntity.hasNextPage);
    }
    return BooksState(error: response.errorCode);
  }

  Future<void> fetchMore() async {
    final oldState = state.value;
    if (oldState == null || oldState.isFetchingMore || !oldState.hasNextPage) return;

    state = AsyncValue.data(oldState.copyWith(isFetchingMore: true));

    final nextPage = oldState.currentPage + 1;
    final response = await _repository.getBooks(query: oldState.searchQuery, category: oldState.selectedCategory, page: nextPage);

    if (response.isSuccess) {
      final listEntity = response.data!;
      final newAllBooks = [...oldState.allBooks, ...listEntity.books];

      state = AsyncValue.data(oldState.copyWith(
        allBooks: newAllBooks,
        books: _applyLocalFilters(newAllBooks, oldState.selectedCategory),
        currentPage: nextPage,
        hasNextPage: listEntity.hasNextPage,
        isFetchingMore: false,
      ));
    } else {
      state = AsyncValue.data(oldState.copyWith(isFetchingMore: false, error: response.errorCode ?? Codes.unknown));
    }
  }

  void updateSearchQuery(String query) {
    _searchDebounce?.cancel();

    final oldState = state.value;
    if (oldState == null) return;

    state = AsyncValue.data(oldState.copyWith(isSearching: true, searchQuery: query));

    _searchDebounce = Timer(const Duration(milliseconds: 500), () async {
      final response = await _repository.getBooks(query: query, category: oldState.selectedCategory, page: 1);

      if (response.isSuccess) {
        final listEntity = response.data!;
        state = AsyncValue.data(oldState.copyWith(
          allBooks: listEntity.books,
          books: _applyLocalFilters(listEntity.books, oldState.selectedCategory),
          currentPage: 1,
          hasNextPage: listEntity.hasNextPage,
          isSearching: false,
        ));
      } else {
        state = AsyncValue.data(oldState.copyWith(isSearching: false, error: response.errorCode ?? Codes.unknown));
      }
    });
  }

  Future<void> updateFilter(String? category) async {
    final oldState = state.value;
    if (oldState == null) return;

    final filteredBooks = _applyLocalFilters(oldState.allBooks, category);

    state = AsyncValue.data(oldState.copyWith(books: filteredBooks, selectedCategory: category, clearCategory: category == null));
  }

  List<BookEntity> _applyLocalFilters(List<BookEntity> list, String? category) {
    if (category == null) return list;
    return list.where((book) => book.category == category).toList();
  }

  void clearError() {
    final oldState = state.value;
    if (oldState == null) return;
    state = AsyncValue.data(oldState.copyWith(error: null));
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    final response = await _repository.getBooks(page: 1);

    if (response.isSuccess) {
      final listEntity = response.data!;
      state = AsyncValue.data(BooksState(allBooks: listEntity.books, books: listEntity.books, currentPage: 1, hasNextPage: listEntity.hasNextPage));
    } else {
      state = AsyncValue.data(BooksState(error: response.errorCode));
    }
  }
}

typedef BooksProvider = AsyncNotifierProvider<BooksNotifier, BooksState>;
