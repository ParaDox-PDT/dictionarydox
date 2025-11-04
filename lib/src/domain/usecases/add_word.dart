import 'package:dartz/dartz.dart';
import 'package:dictionarydox/src/core/error/failures.dart';
import 'package:dictionarydox/src/domain/entities/word.dart';
import 'package:dictionarydox/src/domain/repositories/word_repository.dart';

class AddWord {
  final WordRepository repository;

  AddWord(this.repository);

  Future<Either<Failure, Word>> call(Word word) async {
    return await repository.addWord(word);
  }
}
