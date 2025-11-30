part of 'book_search_bloc.dart';

sealed class BookSearchEvent extends Equatable {
  const BookSearchEvent();

  @override
  List<Object> get props => <Object>[];
}

final class SearchBooks extends BookSearchEvent {
  const SearchBooks(this.query);

  final String query;

  @override
  List<Object> get props => <Object>[query];
}
