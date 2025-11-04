import 'package:dartz/dartz.dart';
import 'package:dictionarydox/src/core/error/failures.dart';
import 'package:dictionarydox/src/domain/entities/word.dart';

/// Abstract repository for word operations
abstract class WordRepository {
  Future<Either<Failure, Word>> addWord(Word word);
  Future<Either<Failure, Word>> updateWord(Word word);
  Future<Either<Failure, void>> deleteWord(String wordId);
  Future<Either<Failure, Word>> getWord(String wordId);
  Future<Either<Failure, List<Word>>> getWordsByUnit(String unitId);
  Future<Either<Failure, List<Word>>> getAllWords();
}
