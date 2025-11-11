/// Abstract storage service interface
/// This allows us to use different storage implementations for different platforms
abstract class StorageService {
  /// Initialize the storage service
  Future<void> init();

  /// Check if a key exists
  bool containsKey(String key);

  /// Get all keys
  Iterable<String> get keys;

  /// Get a value by key
  T? get<T>(String key);

  /// Get all values
  Iterable<T> getAll<T>();

  /// Put a value with key
  Future<void> put<T>(String key, T value);

  /// Delete a value by key
  Future<void> delete(String key);

  /// Clear all data
  Future<void> clear();

  /// Close/dispose the storage
  Future<void> close();
}
