part of 'popular_books_bloc.dart';

sealed class PopularBooksEvent extends Equatable {
  const PopularBooksEvent();

  @override
  List<Object> get props => <Object>[];
}

final class FetchPopularBooks extends PopularBooksEvent {}
