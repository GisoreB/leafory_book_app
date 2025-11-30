import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:mocktail/mocktail.dart';
import 'package:leafory/core/error/exceptions.dart';
import 'package:leafory/core/error/failures.dart';
import 'package:leafory/features/book_discovery/data/data_sources/book_local_data_source.dart';
import 'package:leafory/features/book_discovery/data/data_sources/book_remote_data_source.dart';
import 'package:leafory/features/book_discovery/data/models/book_model.dart';
import 'package:leafory/features/book_discovery/data/repositories/book_repository_impl.dart';
import 'package:leafory/features/book_discovery/domain/entities/book.dart';

class MockBookRemoteDataSource extends Mock implements BookRemoteDataSource {}

class MockBookLocalDataSource extends Mock implements BookLocalDataSource {}

class MockInternetConnection extends Mock implements InternetConnection {}

void main() {
  late MockBookRemoteDataSource mockRemoteDataSource;
  late MockBookLocalDataSource mockLocalDataSource;
  late MockInternetConnection mockInternetConnection;
  late BookRepositoryImpl repository;

  const BookModel dummyBookModel = BookModel(
    id: 1,
    title: 'Test Book',
    authors: <AuthorModel>[AuthorModel(name: 'Test Author')],
    formats: FormatsModel(imageUrl: 'test.jpg'),
    downloadCount: 100,
    languages: <String>['en'],
    copyright: false,
    summaries: <String>['summary'],
  );

  final Book dummyBookEntity = dummyBookModel.toEntity();

  const BookPageModel dummyBookPageModel = BookPageModel(books: <BookModel>[dummyBookModel], hasNext: true);

  final BookPage dummyBookPageEntity = dummyBookPageModel.toEntity();

  setUp(() {
    mockRemoteDataSource = MockBookRemoteDataSource();
    mockLocalDataSource = MockBookLocalDataSource();
    mockInternetConnection = MockInternetConnection();
    repository = BookRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      internetConnection: mockInternetConnection,
    );
  });

  setUpAll(() {
    registerFallbackValue(dummyBookEntity);
  });

  group('fetchPopularBooks', () {
    test('should return BookPage when the call to remote data source is successful', () async {
      when(() => mockInternetConnection.hasInternetAccess).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.fetchPopularBooks(any())).thenAnswer((_) async => dummyBookPageModel);

      final (Failure? failure, BookPage? result) = await repository.fetchPopularBooks(page: 1);

      expect(failure, null);
      expect(result, dummyBookPageEntity);
      verify(() => mockRemoteDataSource.fetchPopularBooks(1)).called(1);
      verifyNoMoreInteractions(mockRemoteDataSource);
    });

    test('should return ServerFailure when the call to remote data source is unsuccessful', () async {
      when(() => mockInternetConnection.hasInternetAccess).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.fetchPopularBooks(any())).thenThrow(const ServerException('API Error'));

      final (Failure? failure, BookPage? result) = await repository.fetchPopularBooks(page: 1);

      expect(failure, const ServerFailure('API Error'));
      expect(result, null);
    });

    test('should return ConnectionFailure when the device is offline', () async {
      when(() => mockInternetConnection.hasInternetAccess).thenAnswer((_) async => false);

      final (Failure? failure, BookPage? result) = await repository.fetchPopularBooks(page: 1);

      expect(failure, const ConnectionFailure('No Internet Connection'));
      expect(result, null);
      verifyZeroInteractions(mockRemoteDataSource);
    });
  });

  group('searchBooks', () {
    const String dummyQuery = 'test';

    test('should return BookPage when the call to remote data source is successful', () async {
      when(() => mockInternetConnection.hasInternetAccess).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.searchBooks(any(), any())).thenAnswer((_) async => dummyBookPageModel);

      final (Failure? failure, BookPage? result) = await repository.searchBooks(query: dummyQuery, page: 1);

      expect(failure, null);
      expect(result, dummyBookPageEntity);
      verify(() => mockRemoteDataSource.searchBooks(dummyQuery, 1)).called(1);
    });
  });

  group('fetchBookDetails', () {
    const int dummyBookId = 1;

    test('should return Book entity when the call is successful', () async {
      when(() => mockInternetConnection.hasInternetAccess).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.fetchBookDetails(any())).thenAnswer((_) async => dummyBookModel);

      final (Failure? failure, Book? result) = await repository.fetchBookDetails(dummyBookId);

      expect(failure, null);
      expect(result, dummyBookEntity);
      verify(() => mockRemoteDataSource.fetchBookDetails(dummyBookId)).called(1);
    });
  });

  group('fetchBooksByIds', () {
    final List<int> dummyBookIds = <int>[1, 2];
    final List<BookModel> dummyBookModels = <BookModel>[dummyBookModel];
    final List<Book> dummyBookEntities = <Book>[dummyBookEntity];

    test('should return list of books when call is successful', () async {
      when(() => mockInternetConnection.hasInternetAccess).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.fetchBooksByIds(any())).thenAnswer((_) async => dummyBookModels);

      final (Failure? failure, List<Book>? result) = await repository.fetchBooksByIds(dummyBookIds);

      expect(failure, null);
      expect(result, dummyBookEntities);
      verify(() => mockRemoteDataSource.fetchBooksByIds(dummyBookIds)).called(1);
    });
  });

  group('getLikedBooks', () {
    test('should return list of liked books from local data source', () async {
      final List<Book> dummyLikedBooks = <Book>[dummyBookEntity];

      when(() => mockLocalDataSource.getLikedBooks()).thenAnswer((_) async => dummyLikedBooks);

      final (Failure? failure, List<Book>? result) = await repository.getLikedBooks();

      expect(failure, null);
      expect(result, dummyLikedBooks);
      verify(() => mockLocalDataSource.getLikedBooks()).called(1);
    });
  });

  group('isBookLiked', () {
    const int dummyBookId = 1;

    test('should return boolean status from local data source', () async {
      when(() => mockLocalDataSource.isBookLiked(any())).thenAnswer((_) async => true);

      final bool result = await repository.isBookLiked(dummyBookId);

      expect(result, true);
      verify(() => mockLocalDataSource.isBookLiked(dummyBookId)).called(1);
    });
  });

  group('likeBook', () {
    test('should call localDataSource.likeBook and return success record', () async {
      when(() => mockLocalDataSource.likeBook(any())).thenAnswer((_) async => Future<dynamic>.value());

      final (Failure?, void) result = await repository.likeBook(dummyBookEntity);

      expect(result, (null, null));
      verify(() => mockLocalDataSource.likeBook(dummyBookEntity)).called(1);
    });
  });

  group('unlikeBook', () {
    const int dummyBookId = 1;

    test('should call localDataSource.unlikeBook and return success record', () async {
      when(() => mockLocalDataSource.unlikeBook(any())).thenAnswer((_) async => Future<dynamic>.value());

      final (Failure?, void) result = await repository.unlikeBook(dummyBookId);

      expect(result, (null, null));
      verify(() => mockLocalDataSource.unlikeBook(dummyBookId)).called(1);
    });
  });
}
