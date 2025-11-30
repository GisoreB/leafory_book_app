part of 'random_books_bloc.dart';

sealed class RandomBooksState extends Equatable {
  const RandomBooksState();

  @override
  List<Object> get props => <Object>[];
}

final class RandomBooksInitial extends RandomBooksState {}

final class RandomBooksLoading extends RandomBooksState {}

final class RandomBooksLoaded extends RandomBooksState {
  const RandomBooksLoaded(this.books);

  final List<Book> books;

  @override
  List<Object> get props => <Object>[books];
}

final class RandomBooksError extends RandomBooksState {
  const RandomBooksError(this.message);

  final String message;

  @override
  List<Object> get props => <Object>[message];
}
