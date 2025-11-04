import 'package:dartz/dartz.dart';
import 'package:dictionarydox/src/core/error/exceptions.dart';
import 'package:dictionarydox/src/core/error/failures.dart';
import 'package:dictionarydox/src/data/datasources/local/word_local_datasource.dart';
import 'package:dictionarydox/src/data/models/word_model.dart';
import 'package:dictionarydox/src/domain/entities/word.dart';
import 'package:dictionarydox/src/domain/repositories/word_repository.dart';

class WordRepositoryImpl implements WordRepository {
  final WordLocalDataSource localDataSource;

  WordRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, Word>> addWord(Word word) async {
    try {
      final wordModel = WordModel.fromEntity(word);
      final result = await localDataSource.addWord(wordModel);
      return Right(result.toEntity());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Word>> updateWord(Word word) async {
    try {
      final wordModel = WordModel.fromEntity(word);
      final result = await localDataSource.updateWord(wordModel);
      return Right(result.toEntity());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> deleteWord(String wordId) async {
    try {
      await localDataSource.deleteWord(wordId);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Word>> getWord(String wordId) async {
    try {
      final result = await localDataSource.getWord(wordId);
      return Right(result.toEntity());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Word>>> getWordsByUnit(String unitId) async {
    try {
      final result = await localDataSource.getWordsByUnit(unitId);
      return Right(result.map((model) => model.toEntity()).toList());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Word>>> getAllWords() async {
    try {
      final result = await localDataSource.getAllWords();
      return Right(result.map((model) => model.toEntity()).toList());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }
}
