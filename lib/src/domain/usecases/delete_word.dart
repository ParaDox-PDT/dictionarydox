import 'package:dartz/dartz.dart';
import 'package:dictionarydox/src/core/error/failures.dart';
import 'package:dictionarydox/src/domain/repositories/word_repository.dart';

class DeleteWord {
  final WordRepository repository;

  DeleteWord(this.repository);

  Future<Either<Failure, void>> call(String wordId) async {
    return await repository.deleteWord(wordId);
  }
}
