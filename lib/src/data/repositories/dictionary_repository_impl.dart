import 'package:dartz/dartz.dart';
import 'package:dictionarydox/src/core/error/exceptions.dart';
import 'package:dictionarydox/src/core/error/failures.dart';
import 'package:dictionarydox/src/data/datasources/remote/dictionary_remote_datasource.dart';
import 'package:dictionarydox/src/domain/repositories/dictionary_repository.dart';

class DictionaryRepositoryImpl implements DictionaryRepository {
  final DictionaryRemoteDataSource remoteDataSource;

  DictionaryRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, ValidationResult>> validateWord(String word) async {
    try {
      final result = await remoteDataSource.validateWord(word);
      return Right(result);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
