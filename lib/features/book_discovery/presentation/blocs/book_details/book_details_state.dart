part of 'book_details_bloc.dart';

sealed class BookDetailsState extends Equatable {
  const BookDetailsState();

  @override
  List<Object> get props => <Object>[];
}

final class BookDetailsInitial extends BookDetailsState {}

final class BookDetailsLoading extends BookDetailsState {}

final class BookDetailsLoaded extends BookDetailsState {
  const BookDetailsLoaded(this.book);

  final Book book;

  @override
  List<Object> get props => <Object>[book];
}

final class BookDetailsError extends BookDetailsState {
  const BookDetailsError(this.message);

  final String message;

  @override
  List<Object> get props => <Object>[message];
}
