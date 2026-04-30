import 'package:sanad/features/books/data/datasources/books_remote_data_source.dart';
import 'package:sanad/features/books/logic/entities/book_entity.dart';
import 'package:sanad/features/books/logic/entities/books_list_entity.dart';
import 'package:sanad/core/models/response_model.dart';
import 'package:sanad/core/models/app_exception.dart';
import 'package:sanad/core/constants/codes.dart';

/// Repository for the Books feature.
class BooksRepository {
  final BooksRemoteDataSource _remoteDataSource;

  BooksRepository(this._remoteDataSource);

  Future<ResponseModel<BooksListEntity>> getBooks({String? query, String? category, int page = 1, int limit = 20}) async {
    try {
      final response = await _remoteDataSource.getBooks(query: query, category: category, page: page, limit: limit);

      final entities = response.books.map((m) => BookEntity.fromModel(m)).toList();
      return ResponseModel.success(BooksListEntity(books: entities, totalCount: response.total, hasNextPage: response.hasNext));
    } on AppException catch (e) {
      return ResponseModel.failure(e.code);
    } catch (e) {
      return const ResponseModel.failure(Codes.unknown);
    }
  }
}
