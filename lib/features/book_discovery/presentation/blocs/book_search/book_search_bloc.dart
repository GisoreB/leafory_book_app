import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:leafory/core/error/failures.dart';
import 'package:leafory/features/book_discovery/domain/entities/book.dart';
import 'package:leafory/features/book_discovery/domain/repositories/book_repository.dart';
import 'package:stream_transform/stream_transform.dart';

part 'book_search_event.dart';
part 'book_search_state.dart';

EventTransformer<E> debounceDroppable<E>(Duration duration) {
  return (Stream<E> events, Stream<E> Function(E) mapper) {
    return droppable<E>().call(events.debounce(duration), mapper);
  };
}

class BookSearchBloc extends Bloc<BookSearchEvent, BookSearchState> {
  BookSearchBloc({required this.bookRepository}) : super(BookSearchInitial()) {
    on<SearchBooks>(_onSearchBooks, transformer: debounceDroppable(const Duration(milliseconds: 500)));
  }

  final BookRepository bookRepository;

  int _page = 1;
  String _currentQuery = '';

  Future<void> _onSearchBooks(SearchBooks event, Emitter<BookSearchState> emit) async {
    if (event.query.isEmpty) {
      emit(BookSearchInitial());
      _currentQuery = '';
      _page = 1;
      return;
    }

    if (_currentQuery != event.query) {
      _currentQuery = event.query;
      _page = 1;
      emit(BookSearchLoading());
    }

    final BookSearchState currentState = state;

    if (currentState is BookSearchLoaded && currentState.hasReachedMax) {
      return;
    }

    final (Failure? failure, BookPage? bookPage) = await bookRepository.searchBooks(query: _currentQuery, page: _page);

    if (failure != null) {
      emit(BookSearchError(failure.message));
    } else if (bookPage != null) {
      _page++;

      final List<Book> previousBooks = <Book>[if (currentState is BookSearchLoaded) ...currentState.books];
      final List<Book> allBooks = previousBooks + bookPage.books;

      emit(BookSearchLoaded(allBooks, hasReachedMax: !bookPage.hasNext));
    }
  }
}
