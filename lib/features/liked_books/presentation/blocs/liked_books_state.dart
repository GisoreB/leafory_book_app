part of 'liked_books_bloc.dart';

sealed class LikedBooksState extends Equatable {
  const LikedBooksState();

  @override
  List<Object> get props => <Object>[];
}

final class LikedBooksInitial extends LikedBooksState {}

final class LikedBooksLoading extends LikedBooksState {}

final class LikedBooksLoaded extends LikedBooksState {
  LikedBooksLoaded(this.books) : likedBookIds = books.map((Book book) => book.id).toSet();

  final List<Book> books;
  final Set<int> likedBookIds;

  @override
  List<Object> get props => <Object>[books, likedBookIds];
}

final class LikedBooksError extends LikedBooksState {
  const LikedBooksError(this.message);

  final String message;

  @override
  List<Object> get props => <Object>[message];
}
