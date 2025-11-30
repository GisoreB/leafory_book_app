import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:leafory/core/error/failures.dart';
import 'package:leafory/features/book_discovery/domain/entities/book.dart';
import 'package:leafory/features/book_discovery/presentation/blocs/random_books/random_books_bloc.dart';
import 'package:mocktail/mocktail.dart';

import 'popular_books_bloc_test.dart';

void main() {
  late MockBookRepository mockBookRepository;
  late RandomBooksBloc randomBooksBloc;

  setUp(() {
    mockBookRepository = MockBookRepository();
    randomBooksBloc = RandomBooksBloc(bookRepository: mockBookRepository);
  });

  test('initial state should be RandomBooksInitial', () {
    expect(randomBooksBloc.state, RandomBooksInitial());
  });

  blocTest<RandomBooksBloc, RandomBooksState>(
    'should emit [RandomBooksLoading, RandomBooksLoaded] when successful',
    build: () {
      when(() => mockBookRepository.fetchBooksByIds(any())).thenAnswer((_) async => (null, <Book>[dummyBook1]));

      return randomBooksBloc;
    },
    act: (RandomBooksBloc bloc) => bloc.add(FetchRandomBooks()),
    expect: () => <RandomBooksState>[
      RandomBooksLoading(),
      const RandomBooksLoaded(<Book>[dummyBook1]),
    ],
    verify: (_) {
      verify(() => mockBookRepository.fetchBooksByIds(any(that: isA<List<int>>()))).called(1);
    },
  );

  blocTest<RandomBooksBloc, RandomBooksState>(
    'should emit [RandomBooksLoading, RandomBooksError] when unsuccessful',
    build: () {
      when(
        () => mockBookRepository.fetchBooksByIds(any()),
      ).thenAnswer((_) async => (const ServerFailure('Error'), null));

      return randomBooksBloc;
    },
    act: (RandomBooksBloc bloc) => bloc.add(FetchRandomBooks()),
    expect: () => <RandomBooksState>[RandomBooksLoading(), const RandomBooksError('Error')],
  );
}
