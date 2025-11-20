import 'package:dartz/dartz.dart' hide Unit;
import 'package:dictionarydox/src/core/error/failures.dart';
import 'package:dictionarydox/src/domain/entities/unit.dart';
import 'package:dictionarydox/src/domain/repositories/unit_repository.dart';

class GetGlobalUnits {
  final UnitRepository repository;

  GetGlobalUnits(this.repository);

  Future<Either<Failure, List<Unit>>> call() async {
    return await repository.getGlobalUnits();
  }
}

