import 'package:dictionarydox/src/core/storage/storage_service.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Hive-based storage service for mobile platforms
class HiveStorageService<T> implements StorageService {
  late Box<T> _box;
  final String boxName;
  bool _isInitialized = false;

  HiveStorageService(this.boxName);

  @override
  Future<void> init() async {
    if (!_isInitialized) {
      _box = await Hive.openBox<T>(boxName);
      _isInitialized = true;
    }
  }

  @override
  bool containsKey(String key) {
    _ensureInitialized();
    return _box.containsKey(key);
  }

  @override
  Iterable<String> get keys {
    _ensureInitialized();
    return _box.keys.cast<String>();
  }

  @override
  T? get<T>(String key) {
    _ensureInitialized();
    return _box.get(key) as T?;
  }

  @override
  Iterable<T> getAll<T>() {
    _ensureInitialized();
    return _box.values.cast<T>();
  }

  @override
  Future<void> put<E>(String key, E value) async {
    _ensureInitialized();
    await _box.put(key, value as T);
  }

  @override
  Future<void> delete(String key) async {
    _ensureInitialized();
    await _box.delete(key);
  }

  @override
  Future<void> clear() async {
    _ensureInitialized();
    await _box.clear();
  }

  @override
  Future<void> close() async {
    if (_isInitialized) {
      await _box.close();
      _isInitialized = false;
    }
  }

  void _ensureInitialized() {
    if (!_isInitialized) {
      throw StateError('Storage service not initialized. Call init() first.');
    }
  }
}
