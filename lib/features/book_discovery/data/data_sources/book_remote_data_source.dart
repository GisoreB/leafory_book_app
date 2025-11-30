import 'dart:io';

import 'package:dio/dio.dart';
import 'package:leafory/core/error/exceptions.dart';
import 'package:leafory/features/book_discovery/data/models/book_model.dart';

abstract interface class BookRemoteDataSource {
  Future<BookPageModel> fetchPopularBooks(int page);
  Future<BookPageModel> searchBooks(String query, int page);
  Future<BookModel> fetchBookDetails(int bookId);
  Future<List<BookModel>> fetchBooksByIds(List<int> bookIds);
}

class BookRemoteDataSourceImpl implements BookRemoteDataSource {
  const BookRemoteDataSourceImpl({required this.dio});

  final Dio dio;
  final String _baseUrl = 'https://gutendex.com/books';

  @override
  Future<BookPageModel> fetchPopularBooks(int page) async {
    try {
      final Response<dynamic> response = await dio.get(_baseUrl, queryParameters: <String, dynamic>{'page': page});

      if (response.statusCode == HttpStatus.ok) {
        return BookPageModel.fromJson(response.data);
      } else {
        throw const ServerException('Failed to load popular books');
      }
    } on DioException catch (error) {
      throw ServerException(error.message ?? 'An unknown error occurred');
    }
  }

  @override
  Future<BookPageModel> searchBooks(String query, int page) async {
    try {
      final Response<dynamic> response = await dio.get(
        _baseUrl,
        queryParameters: <String, dynamic>{'search': query, 'page': page},
      );

      if (response.statusCode == HttpStatus.ok) {
        return BookPageModel.fromJson(response.data);
      } else {
        throw const ServerException('Failed to search books');
      }
    } on DioException catch (error) {
      throw ServerException(error.message ?? 'An unknown error occurred');
    }
  }

  @override
  Future<BookModel> fetchBookDetails(int bookId) async {
    try {
      final Response<dynamic> response = await dio.get('$_baseUrl/$bookId');

      if (response.statusCode == HttpStatus.ok) {
        return BookModel.fromJson(response.data);
      } else {
        throw const ServerException('Book not found');
      }
    } on DioException catch (error) {
      if (error.response?.statusCode == HttpStatus.notFound) {
        throw const ServerException('Book not found');
      }
      throw ServerException(error.message ?? 'An unknown error occurred');
    }
  }

  @override
  Future<List<BookModel>> fetchBooksByIds(List<int> bookIds) async {
    if (bookIds.isEmpty) {
      return <BookModel>[];
    }

    try {
      final String ids = bookIds.join(',');
      final Response<dynamic> response = await dio.get(_baseUrl, queryParameters: <String, dynamic>{'ids': ids});

      if (response.statusCode == HttpStatus.ok) {
        final List<dynamic> results = response.data['results'] as List<dynamic>;
        return results.map((dynamic bookJson) => BookModel.fromJson(bookJson)).toList();
      } else {
        throw const ServerException('Failed to load books by IDs');
      }
    } on DioException catch (error) {
      throw ServerException(error.message ?? 'An unknown error occurred');
    }
  }
}
