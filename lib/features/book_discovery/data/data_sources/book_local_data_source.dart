import 'package:hive_ce/hive.dart';
import 'package:leafory/core/error/exceptions.dart';
import 'package:leafory/features/book_discovery/domain/entities/book.dart';

abstract interface class BookLocalDataSource {
  Future<void> likeBook(Book book);
  Future<void> unlikeBook(int bookId);
  Future<bool> isBookLiked(int bookId);
  Future<List<Book>> getLikedBooks();
}

class BookLocalDataSourceImpl implements BookLocalDataSource {
  const BookLocalDataSourceImpl({required this.box});

  final Box<Book> box;

  @override
  Future<List<Book>> getLikedBooks() async {
    try {
      return box.values.toList();
    } catch (error) {
      throw DatabaseException(error.toString());
    }
  }

  @override
  Future<bool> isBookLiked(int bookId) async => box.containsKey(bookId);

  @override
  Future<void> likeBook(Book book) async {
    try {
      await box.put(book.id, book);
    } catch (error) {
      throw DatabaseException(error.toString());
    }
  }

  @override
  Future<void> unlikeBook(int bookId) async {
    try {
      await box.delete(bookId);
    } catch (error) {
      throw DatabaseException(error.toString());
    }
  }
}
