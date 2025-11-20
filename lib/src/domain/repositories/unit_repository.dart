import 'package:dartz/dartz.dart' hide Unit;
import 'package:dictionarydox/src/core/error/failures.dart';
import 'package:dictionarydox/src/domain/entities/unit.dart';

/// Abstract repository for unit operations
abstract class UnitRepository {
  Future<Either<Failure, Unit>> createUnit(Unit unit);
  Future<Either<Failure, Unit>> updateUnit(Unit unit);
  Future<Either<Failure, void>> deleteUnit(String unitId);
  Future<Either<Failure, Unit>> getUnit(String unitId);
  Future<Either<Failure, List<Unit>>> getAllUnits();
  Future<Either<Failure, List<Unit>>> getGlobalUnits();
}
