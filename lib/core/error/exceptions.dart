class ServerException implements Exception {
  const ServerException(this.message);

  final String message;
}

class DatabaseException implements Exception {
  const DatabaseException(this.message);

  final String message;
}
