import 'package:dictionarydox/src/core/error/exceptions.dart';
import 'package:dictionarydox/src/data/models/word_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

abstract class WordLocalDataSource {
  Future<WordModel> addWord(WordModel word);
  Future<WordModel> updateWord(WordModel word);
  Future<void> deleteWord(String wordId);
  Future<WordModel> getWord(String wordId);
  Future<List<WordModel>> getWordsByUnit(String unitId);
  Future<List<WordModel>> getAllWords();
}

class WordLocalDataSourceImpl implements WordLocalDataSource {
  static const String boxName = 'words';
  final Box<WordModel> box;

  WordLocalDataSourceImpl(this.box);

  @override
  Future<WordModel> addWord(WordModel word) async {
    try {
      await box.put(word.id, word);
      return word;
    } catch (e) {
      throw CacheException('Failed to add word: $e');
    }
  }

  @override
  Future<WordModel> updateWord(WordModel word) async {
    try {
      await box.put(word.id, word);
      return word;
    } catch (e) {
      throw CacheException('Failed to update word: $e');
    }
  }

  @override
  Future<void> deleteWord(String wordId) async {
    try {
      await box.delete(wordId);
    } catch (e) {
      throw CacheException('Failed to delete word: $e');
    }
  }

  @override
  Future<WordModel> getWord(String wordId) async {
    try {
      final word = box.get(wordId);
      if (word == null) {
        throw CacheException('Word not found');
      }
      return word;
    } catch (e) {
      throw CacheException('Failed to get word: $e');
    }
  }

  @override
  Future<List<WordModel>> getWordsByUnit(String unitId) async {
    try {
      return box.values.where((word) => word.unitId == unitId).toList();
    } catch (e) {
      throw CacheException('Failed to get words by unit: $e');
    }
  }

  @override
  Future<List<WordModel>> getAllWords() async {
    try {
      return box.values.toList();
    } catch (e) {
      throw CacheException('Failed to get all words: $e');
    }
  }
}
