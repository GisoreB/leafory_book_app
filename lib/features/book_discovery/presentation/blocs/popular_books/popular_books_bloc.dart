import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:leafory/core/error/failures.dart';
import 'package:leafory/features/book_discovery/domain/entities/book.dart';
import 'package:leafory/features/book_discovery/domain/repositories/book_repository.dart';

part 'popular_books_event.dart';
part 'popular_books_state.dart';

class PopularBooksBloc extends Bloc<PopularBooksEvent, PopularBooksState> {
  PopularBooksBloc({required this.bookRepository}) : super(PopularBooksInitial()) {
    on<FetchPopularBooks>(_onFetchPopularBooks);
  }

  final BookRepository bookRepository;

  int _page = 1;
  bool _isFetching = false;

  Future<void> _onFetchPopularBooks(FetchPopularBooks event, Emitter<PopularBooksState> emit) async {
    final PopularBooksState currentState = state;

    if (currentState is PopularBooksLoaded && _isFetching) {
      return;
    }

    if (currentState is PopularBooksInitial) {
      emit(PopularBooksLoading());
    }

    _isFetching = true;

    final (Failure? failure, BookPage? bookPage) = await bookRepository.fetchPopularBooks(page: _page);

    _isFetching = false;

    if (failure != null) {
      emit(PopularBooksError(failure.message));
    } else if (bookPage != null) {
      _page++;

      final List<Book> previousBooks = <Book>[if (currentState is PopularBooksLoaded) ...currentState.books];
      final List<Book> allBooks = previousBooks + bookPage.books;

      emit(PopularBooksLoaded(allBooks, hasReachedMax: !bookPage.hasNext));
    }
  }
}
