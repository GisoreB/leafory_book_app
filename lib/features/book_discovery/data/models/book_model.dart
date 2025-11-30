import 'package:leafory/features/book_discovery/domain/entities/book.dart';

class BookModel {
  const BookModel({
    required this.id,
    required this.title,
    required this.authors,
    required this.formats,
    required this.downloadCount,
    required this.languages,
    required this.copyright,
    required this.summaries,
  });

  factory BookModel.fromJson(Map<String, dynamic> json) {
    return BookModel(
      id: json['id'],
      title: json['title'],
      authors: List<AuthorModel>.from(
        (json['authors'] as List<dynamic>).map((dynamic author) => AuthorModel.fromJson(author)),
      ),
      formats: FormatsModel.fromJson(json['formats']),
      downloadCount: json['download_count'],
      languages: List<String>.from(json['languages']),
      copyright: json['copyright'],
      summaries: List<String>.from(json['summaries']),
    );
  }

  final int id;
  final String title;
  final List<AuthorModel> authors;
  final FormatsModel formats;
  final int downloadCount;
  final List<String> languages;
  final bool? copyright;
  final List<String> summaries;

  Book toEntity() {
    return Book(
      id: id,
      title: title,
      author: authors.isNotEmpty ? authors.first.name : 'Unknown Author',
      imageUrl: formats.imageUrl,
      downloadCount: downloadCount,
      languages: languages,
      isCopyrighted: copyright,
      summaries: summaries,
    );
  }
}

class AuthorModel {
  const AuthorModel({required this.name});

  factory AuthorModel.fromJson(Map<String, dynamic> json) {
    return AuthorModel(name: json['name']);
  }

  final String name;
}

class FormatsModel {
  const FormatsModel({required this.imageUrl});

  factory FormatsModel.fromJson(Map<String, dynamic> json) {
    return FormatsModel(imageUrl: json['image/jpeg'] ?? '');
  }

  final String imageUrl;
}

class BookPageModel {
  const BookPageModel({required this.books, required this.hasNext});

  factory BookPageModel.fromJson(Map<String, dynamic> json) {
    return BookPageModel(
      books: List<BookModel>.from((json['results'] as List<dynamic>).map((dynamic book) => BookModel.fromJson(book))),
      hasNext: json['next'] != null,
    );
  }

  final List<BookModel> books;
  final bool hasNext;

  BookPage toEntity() {
    return BookPage(books: books.map((BookModel bookModel) => bookModel.toEntity()).toList(), hasNext: hasNext);
  }
}
