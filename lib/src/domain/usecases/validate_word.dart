import 'package:dartz/dartz.dart';
import 'package:dictionarydox/src/core/error/failures.dart';
import 'package:dictionarydox/src/domain/repositories/dictionary_repository.dart';

class ValidateWord {
  final DictionaryRepository repository;

  ValidateWord(this.repository);

  Future<Either<Failure, ValidationResult>> call(String word) async {
    return await repository.validateWord(word);
  }
}
