import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:leafory/features/book_discovery/domain/entities/book.dart';
import 'package:leafory/features/book_discovery/presentation/blocs/book_search/book_search_bloc.dart';
import 'package:mocktail/mocktail.dart';

import 'popular_books_bloc_test.dart';

void main() {
  late MockBookRepository mockBookRepository;
  late BookSearchBloc bookSearchBloc;

  const String dummyQuery = 'test';

  const BookPage dummyBookPage = BookPage(books: <Book>[dummyBook1], hasNext: false);

  setUp(() {
    mockBookRepository = MockBookRepository();
    bookSearchBloc = BookSearchBloc(bookRepository: mockBookRepository);
  });

  test('initial state should be BookSearchInitial', () {
    expect(bookSearchBloc.state, BookSearchInitial());
  });

  blocTest<BookSearchBloc, BookSearchState>(
    'should emit [BookSearchLoading, BookSearchLoaded] when SearchBooks is added and successful',
    build: () {
      when(
        () => mockBookRepository.searchBooks(
          query: any(named: 'query'),
          page: any(named: 'page'),
        ),
      ).thenAnswer((_) async => (null, dummyBookPage));

      return bookSearchBloc;
    },
    act: (BookSearchBloc bloc) => bloc.add(const SearchBooks(dummyQuery)),
    wait: const Duration(milliseconds: 500),
    expect: () => <BookSearchState>[
      BookSearchLoading(),
      const BookSearchLoaded(<Book>[dummyBook1], hasReachedMax: true),
    ],
  );

  blocTest<BookSearchBloc, BookSearchState>(
    'should emit [BookSearchInitial] when SearchBooks is added with an empty query',
    build: () => bookSearchBloc,
    act: (BookSearchBloc bloc) => bloc.add(const SearchBooks('')),
    wait: const Duration(milliseconds: 500),
    expect: () => <BookSearchState>[BookSearchInitial()],
  );
}
