import 'dart:convert';

import 'package:dictionarydox/src/core/storage/storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// SharedPreferences-based storage service for web platform
class WebStorageService implements StorageService {
  late SharedPreferences _prefs;
  final String prefix;
  final dynamic Function(Map<String, dynamic>) fromJson;
  final Map<String, dynamic> Function(dynamic) toJson;
  bool _isInitialized = false;

  WebStorageService({
    required this.prefix,
    required this.fromJson,
    required this.toJson,
  });

  @override
  Future<void> init() async {
    if (!_isInitialized) {
      _prefs = await SharedPreferences.getInstance();
      _isInitialized = true;
    }
  }

  @override
  bool containsKey(String key) {
    _ensureInitialized();
    return _prefs.containsKey(_prefixedKey(key));
  }

  @override
  Iterable<String> get keys {
    _ensureInitialized();
    return _prefs
        .getKeys()
        .where((key) => key.startsWith('$prefix:'))
        .map((key) => key.substring(prefix.length + 1));
  }

  @override
  T? get<T>(String key) {
    _ensureInitialized();
    final jsonString = _prefs.getString(_prefixedKey(key));
    if (jsonString == null) return null;

    try {
      final decoded = jsonDecode(jsonString);
      return fromJson(decoded as Map<String, dynamic>) as T;
    } catch (e) {
      return null;
    }
  }

  @override
  Iterable<T> getAll<T>() {
    _ensureInitialized();
    final items = <T>[];

    for (final key in keys) {
      final item = get<T>(key);
      if (item != null) {
        items.add(item);
      }
    }

    return items;
  }

  @override
  Future<void> put<T>(String key, T value) async {
    _ensureInitialized();
    final json = toJson(value);
    final jsonString = jsonEncode(json);
    await _prefs.setString(_prefixedKey(key), jsonString);
  }

  @override
  Future<void> delete(String key) async {
    _ensureInitialized();
    await _prefs.remove(_prefixedKey(key));
  }

  @override
  Future<void> clear() async {
    _ensureInitialized();
    final keysToRemove = keys.toList();
    for (final key in keysToRemove) {
      await _prefs.remove(_prefixedKey(key));
    }
  }

  @override
  Future<void> close() async {
    // SharedPreferences doesn't need to be closed
    _isInitialized = false;
  }

  String _prefixedKey(String key) => '$prefix:$key';

  void _ensureInitialized() {
    if (!_isInitialized) {
      throw StateError('Storage service not initialized. Call init() first.');
    }
  }
}
