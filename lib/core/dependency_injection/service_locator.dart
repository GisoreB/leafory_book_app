import 'package:dio/dio.dart';
import 'package:hive_ce/hive.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:leafory/features/book_discovery/data/data_sources/book_local_data_source.dart';
import 'package:leafory/features/book_discovery/data/data_sources/book_remote_data_source.dart';
import 'package:leafory/features/book_discovery/data/repositories/book_repository_impl.dart';
import 'package:leafory/features/book_discovery/domain/entities/book.dart';
import 'package:leafory/features/book_discovery/domain/repositories/book_repository.dart';

class ServiceLocator {
  ServiceLocator._();

  static final ServiceLocator instance = ServiceLocator._();

  late final BookRepository bookRepository;

  void init() {
    final Dio dio = Dio();
    final Box<Book> likedBooksBox = Hive.box<Book>('liked_books');
    final InternetConnection internetConnection = InternetConnection();

    final BookRemoteDataSourceImpl bookRemoteDataSource = BookRemoteDataSourceImpl(dio: dio);
    final BookLocalDataSourceImpl bookLocalDataSource = BookLocalDataSourceImpl(box: likedBooksBox);

    bookRepository = BookRepositoryImpl(
      remoteDataSource: bookRemoteDataSource,
      localDataSource: bookLocalDataSource,
      internetConnection: internetConnection,
    );
  }
}
