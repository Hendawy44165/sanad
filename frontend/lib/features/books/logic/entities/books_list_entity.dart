import 'book_entity.dart';

/// Thin wrapper for paginated books list.
class BooksListEntity {
  final List<BookEntity> books;
  final int totalCount;
  final bool hasNextPage;

  BooksListEntity({
    required this.books,
    required this.totalCount,
    required this.hasNextPage,
  });
}
