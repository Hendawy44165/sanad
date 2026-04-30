import 'package:sanad/core/constants/codes.dart';
import '../../logic/entities/book_entity.dart';

/// Represents the UI state for the Books feature.
class BooksState {
  final List<BookEntity> allBooks;
  final List<BookEntity> books;
  final String searchQuery;
  final String? selectedCategory;
  final Codes? error;
  final int currentPage;
  final bool hasNextPage;
  final bool isSearching;
  final bool isFetchingMore;

  BooksState({
    this.allBooks = const [],
    this.books = const [],
    this.searchQuery = '',
    this.selectedCategory,
    this.error,
    this.currentPage = 1,
    this.hasNextPage = true,
    this.isSearching = false,
    this.isFetchingMore = false,
  });

  BooksState copyWith({
    List<BookEntity>? allBooks,
    List<BookEntity>? books,
    String? searchQuery,
    String? selectedCategory,
    bool clearCategory = false,
    Codes? error,
    int? currentPage,
    bool? hasNextPage,
    bool? isSearching,
    bool? isFetchingMore,
  }) {
    return BooksState(
      allBooks: allBooks ?? this.allBooks,
      books: books ?? this.books,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategory: clearCategory ? null : (selectedCategory ?? this.selectedCategory),
      error: error,
      currentPage: currentPage ?? this.currentPage,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      isSearching: isSearching ?? this.isSearching,
      isFetchingMore: isFetchingMore ?? this.isFetchingMore,
    );
  }
}
