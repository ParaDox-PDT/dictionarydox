import 'package:dictionarydox/src/core/error/exceptions.dart';
import 'package:dictionarydox/src/core/storage/storage_service.dart';
import 'package:dictionarydox/src/data/models/word_model.dart';

abstract class WordLocalDataSource {
  Future<WordModel> addWord(WordModel word);
  Future<WordModel> updateWord(WordModel word);
  Future<void> deleteWord(String wordId);
  Future<WordModel> getWord(String wordId);
  Future<List<WordModel>> getWordsByUnit(String unitId);
  Future<List<WordModel>> getAllWords();
}

class WordLocalDataSourceImpl implements WordLocalDataSource {
  final StorageService storage;

  WordLocalDataSourceImpl(this.storage);

  @override
  Future<WordModel> addWord(WordModel word) async {
    try {
      await storage.put(word.id, word);
      return word;
    } catch (e) {
      throw CacheException('Failed to add word: $e');
    }
  }

  @override
  Future<WordModel> updateWord(WordModel word) async {
    try {
      await storage.put(word.id, word);
      return word;
    } catch (e) {
      throw CacheException('Failed to update word: $e');
    }
  }

  @override
  Future<void> deleteWord(String wordId) async {
    try {
      await storage.delete(wordId);
    } catch (e) {
      throw CacheException('Failed to delete word: $e');
    }
  }

  @override
  Future<WordModel> getWord(String wordId) async {
    try {
      final word = storage.get<WordModel>(wordId);
      if (word == null) {
        throw const CacheException('Word not found');
      }
      return word;
    } catch (e) {
      throw CacheException('Failed to get word: $e');
    }
  }

  @override
  Future<List<WordModel>> getWordsByUnit(String unitId) async {
    try {
      return storage
          .getAll<WordModel>()
          .where((word) => word.unitId == unitId)
          .toList();
    } catch (e) {
      throw CacheException('Failed to get words by unit: $e');
    }
  }

  @override
  Future<List<WordModel>> getAllWords() async {
    try {
      return storage.getAll<WordModel>().toList();
    } catch (e) {
      throw CacheException('Failed to get all words: $e');
    }
  }
}
