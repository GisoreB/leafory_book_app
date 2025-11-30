import 'dart:io';

import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:leafory/features/book_discovery/domain/entities/book.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseService {
  const DatabaseService._();

  static const DatabaseService instance = DatabaseService._();

  Future<void> init() async {
    final Directory appDocumentDir = await getApplicationDocumentsDirectory();
    await Hive.initFlutter(appDocumentDir.path);

    Hive.registerAdapter(BookAdapter());

    await Hive.openBox<Book>('liked_books');
  }
}
