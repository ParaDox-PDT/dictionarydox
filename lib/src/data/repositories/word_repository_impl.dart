import 'package:dartz/dartz.dart';
import 'package:dictionarydox/src/core/error/exceptions.dart';
import 'package:dictionarydox/src/core/error/failures.dart';
import 'package:dictionarydox/src/data/datasources/local/word_local_datasource.dart';
import 'package:dictionarydox/src/data/datasources/remote/word_remote_datasource.dart';
import 'package:dictionarydox/src/data/models/word_model.dart';
import 'package:dictionarydox/src/domain/entities/word.dart';
import 'package:dictionarydox/src/domain/repositories/unit_repository.dart';
import 'package:dictionarydox/src/domain/repositories/word_repository.dart';

class WordRepositoryImpl implements WordRepository {
  final WordLocalDataSource localDataSource;
  final WordRemoteDataSource remoteDataSource;
  final UnitRepository unitRepository;

  WordRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.unitRepository,
  });

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
      // Check if unit is global by trying to get it
      // If unit is global (isGlobal == true), fetch words from Firebase
      // Otherwise, fetch from local storage
      final unitResult = await unitRepository.getUnit(unitId);
      
      return await unitResult.fold(
        // If unit not found in local, try Firebase (might be global unit)
        (failure) async {
          try {
            // Try to fetch from Firebase (for global units)
            final words = await remoteDataSource.getWordsByUnitId(unitId);
            return Right(words.map((model) => model.toEntity()).toList());
          } on ServerException catch (e) {
            return Left(ServerFailure(e.message));
          }
        },
        // Unit found - check if it's global
        (unit) async {
          if (unit.isGlobal) {
            // Fetch from Firebase for global units
            try {
              final words =
                  await remoteDataSource.getWordsByUnitId(unitId);
              return Right(words.map((model) => model.toEntity()).toList());
            } on ServerException catch (e) {
              return Left(ServerFailure(e.message));
            }
          } else {
            // Fetch from local storage for user's own units
            try {
              final result = await localDataSource.getWordsByUnit(unitId);
              return Right(result.map((model) => model.toEntity()).toList());
            } on CacheException catch (e) {
              return Left(CacheFailure(e.message));
            }
          }
        },
      );
    } catch (e) {
      return Left(ServerFailure('Failed to get words: $e'));
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
