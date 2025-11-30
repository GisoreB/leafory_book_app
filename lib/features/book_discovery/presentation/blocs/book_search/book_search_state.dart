part of 'book_search_bloc.dart';

sealed class BookSearchState extends Equatable {
  const BookSearchState();

  @override
  List<Object> get props => <Object>[];
}

final class BookSearchInitial extends BookSearchState {}

final class BookSearchLoading extends BookSearchState {}

final class BookSearchLoaded extends BookSearchState {
  const BookSearchLoaded(this.books, {required this.hasReachedMax});

  final List<Book> books;
  final bool hasReachedMax;

  @override
  List<Object> get props => <Object>[books, hasReachedMax];
}

final class BookSearchError extends BookSearchState {
  const BookSearchError(this.message);

  final String message;

  @override
  List<Object> get props => <Object>[message];
}
