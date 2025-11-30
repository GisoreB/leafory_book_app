import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:leafory/core/error/exceptions.dart';
import 'package:leafory/core/error/failures.dart';
import 'package:leafory/features/book_discovery/data/data_sources/book_local_data_source.dart';
import 'package:leafory/features/book_discovery/data/data_sources/book_remote_data_source.dart';
import 'package:leafory/features/book_discovery/data/models/book_model.dart';
import 'package:leafory/features/book_discovery/domain/entities/book.dart';
import 'package:leafory/features/book_discovery/domain/repositories/book_repository.dart';

class BookRepositoryImpl implements BookRepository {
  const BookRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.internetConnection,
  });

  final BookRemoteDataSource remoteDataSource;
  final BookLocalDataSource localDataSource;
  final InternetConnection internetConnection;

  @override
  Future<(Failure?, BookPage?)> fetchPopularBooks({int page = 1}) async {
    if (!await internetConnection.hasInternetAccess) {
      return (const ConnectionFailure('No Internet Connection'), null);
    }

    try {
      final BookPageModel bookPageModel = await remoteDataSource.fetchPopularBooks(page);
      return (null, bookPageModel.toEntity());
    } on ServerException catch (error) {
      return (ServerFailure(error.message), null);
    }
  }

  @override
  Future<(Failure?, BookPage?)> searchBooks({required String query, int page = 1}) async {
    if (!await internetConnection.hasInternetAccess) {
      return (const ConnectionFailure('No Internet Connection'), null);
    }

    try {
      final BookPageModel bookPageModel = await remoteDataSource.searchBooks(query, page);
      return (null, bookPageModel.toEntity());
    } on ServerException catch (error) {
      return (ServerFailure(error.message), null);
    }
  }

  @override
  Future<(Failure?, Book?)> fetchBookDetails(int bookId) async {
    if (!await internetConnection.hasInternetAccess) {
      return (const ConnectionFailure('No Internet Connection'), null);
    }

    try {
      final BookModel bookModel = await remoteDataSource.fetchBookDetails(bookId);
      return (null, bookModel.toEntity());
    } on ServerException catch (error) {
      return (ServerFailure(error.message), null);
    }
  }

  @override
  Future<(Failure?, List<Book>?)> fetchBooksByIds(List<int> bookIds) async {
    if (!await internetConnection.hasInternetAccess) {
      return (const ConnectionFailure('No Internet Connection'), null);
    }

    try {
      final List<BookModel> bookModels = await remoteDataSource.fetchBooksByIds(bookIds);
      return (null, bookModels.map((BookModel model) => model.toEntity()).toList());
    } on ServerException catch (error) {
      return (ServerFailure(error.message), null);
    }
  }

  @override
  Future<(Failure?, List<Book>?)> getLikedBooks() async {
    try {
      return (null, await localDataSource.getLikedBooks());
    } on DatabaseException catch (error) {
      return (DatabaseFailure(error.message), null);
    }
  }

  @override
  Future<bool> isBookLiked(int bookId) async => await localDataSource.isBookLiked(bookId);

  @override
  Future<(Failure?, void)> likeBook(Book book) async {
    try {
      await localDataSource.likeBook(book);
      return (null, null);
    } on DatabaseException catch (error) {
      return (DatabaseFailure(error.message), null);
    }
  }

  @override
  Future<(Failure?, void)> unlikeBook(int bookId) async {
    try {
      await localDataSource.unlikeBook(bookId);
      return (null, null);
    } on DatabaseException catch (error) {
      return (DatabaseFailure(error.message), null);
    }
  }
}
