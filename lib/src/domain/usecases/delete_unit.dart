import 'package:dartz/dartz.dart';
import 'package:dictionarydox/src/core/error/failures.dart';
import 'package:dictionarydox/src/domain/repositories/unit_repository.dart';

class DeleteUnit {
  final UnitRepository repository;

  DeleteUnit(this.repository);

  Future<Either<Failure, void>> call(String unitId) async {
    return await repository.deleteUnit(unitId);
  }
}
