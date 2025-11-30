import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:leafory/core/error/failures.dart';
import 'package:leafory/features/book_discovery/domain/entities/book.dart';
import 'package:leafory/features/book_discovery/domain/repositories/book_repository.dart';

part 'liked_books_event.dart';
part 'liked_books_state.dart';

class LikedBooksBloc extends Bloc<LikedBooksEvent, LikedBooksState> {
  LikedBooksBloc({required this.bookRepository}) : super(LikedBooksInitial()) {
    on<LoadLikedBooks>(_onLoadLikedBooks);
    on<LikeBook>(_onLikeBook);
    on<UnlikeBook>(_onUnlikeBook);
  }

  final BookRepository bookRepository;

  Future<void> _onLoadLikedBooks(LoadLikedBooks event, Emitter<LikedBooksState> emit) async {
    final (Failure? failure, List<Book>? books) = await bookRepository.getLikedBooks();

    if (failure != null) {
      emit(LikedBooksError(failure.message));
    } else if (books != null) {
      emit(LikedBooksLoaded(books));
    }
  }

  Future<void> _onLikeBook(LikeBook event, Emitter<LikedBooksState> emit) async {
    final (Failure? failure, _) = await bookRepository.likeBook(event.book);

    if (failure != null) {
      emit(LikedBooksError(failure.message));
    } else {
      add(LoadLikedBooks());
    }
  }

  Future<void> _onUnlikeBook(UnlikeBook event, Emitter<LikedBooksState> emit) async {
    final (Failure? failure, _) = await bookRepository.unlikeBook(event.bookId);

    if (failure != null) {
      emit(LikedBooksError(failure.message));
    } else {
      add(LoadLikedBooks());
    }
  }
}
