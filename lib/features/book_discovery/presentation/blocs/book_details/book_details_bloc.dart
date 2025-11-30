import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:leafory/core/error/failures.dart';
import 'package:leafory/features/book_discovery/domain/entities/book.dart';
import 'package:leafory/features/book_discovery/domain/repositories/book_repository.dart';

part 'book_details_event.dart';
part 'book_details_state.dart';

class BookDetailsBloc extends Bloc<BookDetailsEvent, BookDetailsState> {
  BookDetailsBloc({required this.bookRepository}) : super(BookDetailsInitial()) {
    on<FetchBookDetails>(_onFetchBookDetails);
  }

  final BookRepository bookRepository;

  Future<void> _onFetchBookDetails(FetchBookDetails event, Emitter<BookDetailsState> emit) async {
    emit(BookDetailsLoading());

    final (Failure? failure, Book? book) = await bookRepository.fetchBookDetails(event.bookId);

    if (failure != null) {
      emit(BookDetailsError(failure.message));
    } else if (book != null) {
      emit(BookDetailsLoaded(book));
    }
  }
}
