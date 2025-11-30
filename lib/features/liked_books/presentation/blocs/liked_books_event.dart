part of 'liked_books_bloc.dart';

sealed class LikedBooksEvent extends Equatable {
  const LikedBooksEvent();

  @override
  List<Object> get props => <Object>[];
}

final class LoadLikedBooks extends LikedBooksEvent {}

final class LikeBook extends LikedBooksEvent {
  const LikeBook(this.book);

  final Book book;

  @override
  List<Object> get props => <Object>[book];
}

final class UnlikeBook extends LikedBooksEvent {
  const UnlikeBook(this.bookId);

  final int bookId;

  @override
  List<Object> get props => <Object>[bookId];
}
