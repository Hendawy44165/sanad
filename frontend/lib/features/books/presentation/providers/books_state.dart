class Book {
  final String title;
  final String author;
  final String category;
  final List<String> formats;

  Book({
    required this.title,
    required this.author,
    required this.category,
    required this.formats,
  });
}

class BooksState {
  final List<Book> books;
  final String searchQuery;
  final String selectedFilter;

  BooksState({
    required this.books,
    this.searchQuery = '',
    this.selectedFilter = 'All Formats',
  });

  BooksState copyWith({
    List<Book>? books,
    String? searchQuery,
    String? selectedFilter,
  }) {
    return BooksState(
      books: books ?? this.books,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedFilter: selectedFilter ?? this.selectedFilter,
    );
  }
}
