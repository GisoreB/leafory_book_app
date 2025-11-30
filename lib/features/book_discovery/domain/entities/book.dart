import 'package:equatable/equatable.dart';
import 'package:hive_ce/hive.dart';

part 'book.g.dart';

@HiveType(typeId: 0)
class Book extends Equatable {
  const Book({
    required this.id,
    required this.title,
    required this.author,
    required this.imageUrl,
    required this.downloadCount,
    required this.languages,
    required this.isCopyrighted,
    required this.summaries,
  });

  @HiveField(0)
  final int id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String author;

  @HiveField(3)
  final String imageUrl;

  @HiveField(4)
  final int downloadCount;

  @HiveField(5)
  final List<String> languages;

  @HiveField(6)
  final bool? isCopyrighted;

  @HiveField(7)
  final List<String> summaries;

  @override
  List<Object?> get props => <Object?>[id, title, author, imageUrl, downloadCount, languages, isCopyrighted, summaries];
}

class BookPage extends Equatable {
  const BookPage({required this.books, required this.hasNext});

  final List<Book> books;
  final bool hasNext;

  @override
  List<Object?> get props => <Object?>[books, hasNext];
}
