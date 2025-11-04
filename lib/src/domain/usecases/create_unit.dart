import 'package:dartz/dartz.dart' hide Unit;
import 'package:dictionarydox/src/core/error/failures.dart';
import 'package:dictionarydox/src/domain/entities/unit.dart';
import 'package:dictionarydox/src/domain/repositories/unit_repository.dart';

class CreateUnit {
  final UnitRepository repository;

  CreateUnit(this.repository);

  Future<Either<Failure, Unit>> call(Unit unit) async {
    return await repository.createUnit(unit);
  }
}
