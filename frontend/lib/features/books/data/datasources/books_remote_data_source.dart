import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:sanad/core/constants/codes.dart';
import 'package:sanad/core/constants/api_constants.dart';
import 'package:sanad/core/models/app_exception.dart';
import '../models/book_model.dart';

/// Low-level data source for Store Products API interactions.
/// 
/// This class handles direct HTTP communication for fetching accessible books
/// and products from the store module.
class BooksRemoteDataSource {
  final Dio _dio;
  final ApiConfig _apiConfig;

  /// Creates a [BooksRemoteDataSource] instance.
  /// 
  /// Variables: [_dio] Client for HTTP requests. [_apiConfig] configuration for endpoints.
  BooksRemoteDataSource(this._dio, this._apiConfig);

  /// Fetches a paginated list of books (products) from the server.
  Future<BooksResponse> getBooks({String? query, String? category, int page = 1, int limit = 20}) async {
    final url = _apiConfig.store.products;

    try {
      final response = await _dio.get(url, queryParameters: {if (query != null && query.isNotEmpty) 'q': query, if (category != null && category.isNotEmpty) 'category': category, 'page': page, 'limit': limit});

      final decoded = response.data;

      if (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300) {
        if (decoded['success'] == true) {
          return BooksResponse.fromJson(decoded);
        } else {
          throw const AppException(Codes.unexpectedFailure);
        }
      } else {
        throw const AppException(Codes.unexpectedFailure);
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout || e.type == DioExceptionType.receiveTimeout) {
        throw const AppException(Codes.requestTimeout);
      }
      throw const AppException(Codes.unexpectedFailure);
    } on SocketException {
      throw const AppException(Codes.requestTimeout);
    } on TimeoutException {
      throw const AppException(Codes.requestTimeout);
    } catch (e) {
      if (e is AppException) rethrow;
      throw const AppException(Codes.unexpectedFailure);
    }
  }
}
