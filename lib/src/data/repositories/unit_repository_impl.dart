import 'package:dartz/dartz.dart' hide Unit;
import 'package:dictionarydox/src/core/error/exceptions.dart';
import 'package:dictionarydox/src/core/error/failures.dart';
import 'package:dictionarydox/src/data/datasources/local/unit_local_datasource.dart';
import 'package:dictionarydox/src/data/datasources/local/word_local_datasource.dart';
import 'package:dictionarydox/src/data/datasources/remote/unit_remote_datasource.dart';
import 'package:dictionarydox/src/data/models/unit_model.dart';
import 'package:dictionarydox/src/domain/entities/unit.dart';
import 'package:dictionarydox/src/domain/repositories/unit_repository.dart';

class UnitRepositoryImpl implements UnitRepository {
  final UnitLocalDataSource localDataSource;
  final WordLocalDataSource wordLocalDataSource;
  final UnitRemoteDataSource remoteDataSource;

  UnitRepositoryImpl({
    required this.localDataSource,
    required this.wordLocalDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, Unit>> createUnit(Unit unit) async {
    try {
      final unitModel = UnitModel.fromEntity(unit);
      final result = await localDataSource.createUnit(unitModel);
      return Right(result.toEntity());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateUnit(Unit unit) async {
    try {
      final unitModel = UnitModel.fromEntity(unit);
      final result = await localDataSource.updateUnit(unitModel);
      return Right(result.toEntity());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> deleteUnit(String unitId) async {
    try {
      await localDataSource.deleteUnit(unitId);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Unit>> getUnit(String unitId) async {
    try {
      final result = await localDataSource.getUnit(unitId);
      return Right(result.toEntity());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Unit>>> getAllUnits() async {
    try {
      final units = await localDataSource.getAllUnits();

      // Calculate word count for each unit
      final unitsWithCount = <Unit>[];
      for (final unitModel in units) {
        final words = await wordLocalDataSource.getWordsByUnit(unitModel.id);
        final unit = unitModel.toEntity().copyWith(wordCount: words.length);
        unitsWithCount.add(unit);
      }

      return Right(unitsWithCount);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Unit>>> getGlobalUnits() async {
    try {
      final units = await remoteDataSource.getGlobalUnits();
      
      // Convert to domain entities
      final unitEntities = units.map((model) => model.toEntity()).toList();
      
      return Right(unitEntities);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Failed to fetch global units: $e'));
    }
  }
}
