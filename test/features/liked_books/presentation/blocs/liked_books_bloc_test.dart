import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:leafory/features/book_discovery/domain/entities/book.dart';
import 'package:leafory/features/liked_books/presentation/blocs/liked_books_bloc.dart';

import '../../../book_discovery/presentation/blocs/popular_books_bloc_test.dart';

void main() {
  late MockBookRepository mockBookRepository;
  late LikedBooksBloc likedBooksBloc;

  setUp(() {
    mockBookRepository = MockBookRepository();
    likedBooksBloc = LikedBooksBloc(bookRepository: mockBookRepository);
  });

  setUpAll(() {
    registerFallbackValue(dummyBook1);
  });

  test('initial state should be LikedBooksInitial', () {
    expect(likedBooksBloc.state, LikedBooksInitial());
  });

  blocTest<LikedBooksBloc, LikedBooksState>(
    'should emit [LikedBooksLoaded] when LoadLikedBooks is successful',
    build: () {
      when(() => mockBookRepository.getLikedBooks()).thenAnswer((_) async => (null, <Book>[dummyBook1]));

      return likedBooksBloc;
    },
    act: (LikedBooksBloc bloc) => bloc.add(LoadLikedBooks()),
    expect: () => <LikedBooksState>[
      LikedBooksLoaded(<Book>[dummyBook1]),
    ],
  );

  blocTest<LikedBooksBloc, LikedBooksState>(
    'should call likeBook and then reload books',
    build: () {
      when(() => mockBookRepository.likeBook(any())).thenAnswer((_) async => (null, null));
      when(() => mockBookRepository.getLikedBooks()).thenAnswer((_) async => (null, <Book>[dummyBook1]));

      return likedBooksBloc;
    },
    act: (LikedBooksBloc bloc) => bloc.add(const LikeBook(dummyBook1)),
    expect: () => <LikedBooksState>[
      LikedBooksLoaded(<Book>[dummyBook1]),
    ],
    verify: (_) {
      verify(() => mockBookRepository.likeBook(dummyBook1)).called(1);
      verify(() => mockBookRepository.getLikedBooks()).called(1);
    },
  );
}
