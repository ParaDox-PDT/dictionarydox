import 'package:dartz/dartz.dart' hide Unit;
import 'package:dictionarydox/src/core/error/failures.dart';
import 'package:dictionarydox/src/domain/entities/unit.dart';
import 'package:dictionarydox/src/domain/repositories/unit_repository.dart';

class GetAllUnits {
  final UnitRepository repository;

  GetAllUnits(this.repository);

  Future<Either<Failure, List<Unit>>> call() async {
    return await repository.getAllUnits();
  }
}
