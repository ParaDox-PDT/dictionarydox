/// Custom exceptions for the application
class ServerException implements Exception {
  final String message;
  const ServerException([this.message = 'Server error']);
}

class CacheException implements Exception {
  final String message;
  const CacheException([this.message = 'Cache error']);
}

class NetworkException implements Exception {
  final String message;
  const NetworkException([this.message = 'Network error']);
}

class ValidationException implements Exception {
  final String message;
  const ValidationException([this.message = 'Validation error']);
}
