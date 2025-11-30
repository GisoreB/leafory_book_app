part of 'book_details_bloc.dart';

sealed class BookDetailsEvent extends Equatable {
  const BookDetailsEvent();

  @override
  List<Object> get props => <Object>[];
}

final class FetchBookDetails extends BookDetailsEvent {
  const FetchBookDetails(this.bookId);

  final int bookId;

  @override
  List<Object> get props => <Object>[bookId];
}
