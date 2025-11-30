part of 'random_books_bloc.dart';

sealed class RandomBooksEvent extends Equatable {
  const RandomBooksEvent();

  @override
  List<Object> get props => <Object>[];
}

final class FetchRandomBooks extends RandomBooksEvent {}
