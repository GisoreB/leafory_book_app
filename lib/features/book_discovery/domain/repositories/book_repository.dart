import 'package:leafory/core/error/failures.dart';
import 'package:leafory/features/book_discovery/domain/entities/book.dart';

abstract interface class BookRepository {
  Future<(Failure?, BookPage?)> fetchPopularBooks({int page = 1});
  Future<(Failure?, BookPage?)> searchBooks({required String query, int page = 1});
  Future<(Failure?, Book?)> fetchBookDetails(int bookId);
  Future<(Failure?, List<Book>?)> fetchBooksByIds(List<int> bookIds);
  Future<(Failure?, List<Book>?)> getLikedBooks();
  Future<bool> isBookLiked(int bookId);
  Future<(Failure?, void)> likeBook(Book book);
  Future<(Failure?, void)> unlikeBook(int bookId);
}
