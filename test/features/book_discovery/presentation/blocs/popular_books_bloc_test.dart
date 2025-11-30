import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:leafory/core/error/failures.dart';
import 'package:leafory/features/book_discovery/domain/entities/book.dart';
import 'package:leafory/features/book_discovery/domain/repositories/book_repository.dart';
import 'package:leafory/features/book_discovery/presentation/blocs/popular_books/popular_books_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockBookRepository extends Mock implements BookRepository {}

const Book dummyBook1 = Book(
  id: 1,
  title: 'Test Book',
  author: 'Test Author',
  imageUrl: 'test.jpg',
  downloadCount: 100,
  languages: <String>['en'],
  isCopyrighted: false,
  summaries: <String>['summary'],
);
const Book dummyBook2 = Book(
  id: 2,
  title: 'Test Book',
  author: 'Test Author',
  imageUrl: 'test.jpg',
  downloadCount: 200,
  languages: <String>['en'],
  isCopyrighted: false,
  summaries: <String>['summary'],
);

const BookPage dummyBookPage1 = BookPage(books: <Book>[dummyBook1], hasNext: true);
const BookPage dummyBookPage2 = BookPage(books: <Book>[dummyBook2], hasNext: false);

void main() {
  late MockBookRepository mockBookRepository;
  late PopularBooksBloc popularBooksBloc;

  setUp(() {
    mockBookRepository = MockBookRepository();
    popularBooksBloc = PopularBooksBloc(bookRepository: mockBookRepository);
  });

  test('initial state should be PopularBooksInitial', () {
    expect(popularBooksBloc.state, PopularBooksInitial());
  });

  blocTest<PopularBooksBloc, PopularBooksState>(
    'should emit [PopularBooksLoading, PopularBooksLoaded] when data is gotten successfully',
    build: () {
      when(() => mockBookRepository.fetchPopularBooks(page: 1)).thenAnswer((_) async => (null, dummyBookPage1));

      return popularBooksBloc;
    },
    act: (PopularBooksBloc bloc) => bloc.add(FetchPopularBooks()),
    expect: () => <PopularBooksState>[
      PopularBooksLoading(),
      const PopularBooksLoaded(<Book>[dummyBook1], hasReachedMax: false),
    ],
    verify: (_) {
      verify(() => mockBookRepository.fetchPopularBooks(page: 1)).called(1);
    },
  );

  blocTest<PopularBooksBloc, PopularBooksState>(
    'should emit [PopularBooksLoading, PopularBooksError] when getting data fails',
    build: () {
      when(
        () => mockBookRepository.fetchPopularBooks(page: 1),
      ).thenAnswer((_) async => (const ServerFailure('API Error'), null));

      return popularBooksBloc;
    },
    act: (PopularBooksBloc bloc) => bloc.add(FetchPopularBooks()),
    expect: () => <PopularBooksState>[PopularBooksLoading(), const PopularBooksError('API Error')],
  );

  blocTest<PopularBooksBloc, PopularBooksState>(
    'should fetch next page and emit combined list when FetchPopularBooks is called again',
    build: () {
      when(() => mockBookRepository.fetchPopularBooks(page: 1)).thenAnswer((_) async => (null, dummyBookPage1));
      when(() => mockBookRepository.fetchPopularBooks(page: 2)).thenAnswer((_) async => (null, dummyBookPage2));

      return popularBooksBloc;
    },
    act: (PopularBooksBloc bloc) async {
      bloc.add(FetchPopularBooks());
      await Future<dynamic>.delayed(Duration.zero);
      bloc.add(FetchPopularBooks());
    },
    expect: () => <PopularBooksState>[
      PopularBooksLoading(),
      const PopularBooksLoaded(<Book>[dummyBook1], hasReachedMax: false),
      const PopularBooksLoaded(<Book>[dummyBook1, dummyBook2], hasReachedMax: true),
    ],
    verify: (_) {
      verify(() => mockBookRepository.fetchPopularBooks(page: 1)).called(1);
      verify(() => mockBookRepository.fetchPopularBooks(page: 2)).called(1);
    },
  );
}
