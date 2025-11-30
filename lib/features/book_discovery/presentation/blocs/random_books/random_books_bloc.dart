import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:leafory/core/error/failures.dart';
import 'package:leafory/features/book_discovery/domain/entities/book.dart';
import 'package:leafory/features/book_discovery/domain/repositories/book_repository.dart';

part 'random_books_event.dart';
part 'random_books_state.dart';

class RandomBooksBloc extends Bloc<RandomBooksEvent, RandomBooksState> {
  RandomBooksBloc({required this.bookRepository}) : super(RandomBooksInitial()) {
    on<FetchRandomBooks>(_onFetchRandomBooks);
  }

  final BookRepository bookRepository;

  Future<void> _onFetchRandomBooks(FetchRandomBooks event, Emitter<RandomBooksState> emit) async {
    emit(RandomBooksLoading());

    final Random random = Random();
    final List<int> randomizedBookIds = List<int>.generate(8, (int index) => random.nextInt(4000) + 1);

    final (Failure? failure, List<Book>? books) = await bookRepository.fetchBooksByIds(randomizedBookIds);

    if (failure != null) {
      emit(RandomBooksError(failure.message));
    } else if (books != null) {
      emit(RandomBooksLoaded(books));
    }
  }
}
