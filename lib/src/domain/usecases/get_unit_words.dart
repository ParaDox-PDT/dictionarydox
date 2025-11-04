import 'package:dartz/dartz.dart';
import 'package:dictionarydox/src/core/error/failures.dart';
import 'package:dictionarydox/src/domain/entities/word.dart';
import 'package:dictionarydox/src/domain/repositories/word_repository.dart';

class GetUnitWords {
  final WordRepository repository;

  GetUnitWords(this.repository);

  Future<Either<Failure, List<Word>>> call(String unitId) async {
    return await repository.getWordsByUnit(unitId);
  }
}
