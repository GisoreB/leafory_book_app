part of 'popular_books_bloc.dart';

sealed class PopularBooksState extends Equatable {
  const PopularBooksState();

  @override
  List<Object> get props => <Object>[];
}

final class PopularBooksInitial extends PopularBooksState {}

final class PopularBooksLoading extends PopularBooksState {}

final class PopularBooksLoaded extends PopularBooksState {
  const PopularBooksLoaded(this.books, {required this.hasReachedMax});

  final List<Book> books;
  final bool hasReachedMax;

  @override
  List<Object> get props => <Object>[books, hasReachedMax];
}

final class PopularBooksError extends PopularBooksState {
  const PopularBooksError(this.message);

  final String message;

  @override
  List<Object> get props => <Object>[message];
}
