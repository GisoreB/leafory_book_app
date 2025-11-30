import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:leafory/core/error/failures.dart';
import 'package:leafory/features/book_discovery/presentation/blocs/book_details/book_details_bloc.dart';

import 'popular_books_bloc_test.dart';

void main() {
  late MockBookRepository mockBookRepository;
  late BookDetailsBloc bookDetailsBloc;

  const int dummyBookId = 1;

  setUp(() {
    mockBookRepository = MockBookRepository();
    bookDetailsBloc = BookDetailsBloc(bookRepository: mockBookRepository);
  });

  test('initial state should be BookDetailsInitial', () {
    expect(bookDetailsBloc.state, BookDetailsInitial());
  });

  blocTest<BookDetailsBloc, BookDetailsState>(
    'should emit [BookDetailsLoading, BookDetailsLoaded] when successful',
    build: () {
      when(() => mockBookRepository.fetchBookDetails(any())).thenAnswer((_) async => (null, dummyBook1));

      return bookDetailsBloc;
    },
    act: (BookDetailsBloc bloc) => bloc.add(const FetchBookDetails(dummyBookId)),
    expect: () => <BookDetailsState>[BookDetailsLoading(), const BookDetailsLoaded(dummyBook1)],
  );

  blocTest<BookDetailsBloc, BookDetailsState>(
    'should emit [BookDetailsLoading, BookDetailsError] when unsuccessful',
    build: () {
      when(
        () => mockBookRepository.fetchBookDetails(any()),
      ).thenAnswer((_) async => (const ServerFailure('Error'), null));

      return bookDetailsBloc;
    },
    act: (BookDetailsBloc bloc) => bloc.add(const FetchBookDetails(dummyBookId)),
    expect: () => <BookDetailsState>[BookDetailsLoading(), const BookDetailsError('Error')],
  );
}
