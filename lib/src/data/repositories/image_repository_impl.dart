import 'package:dartz/dartz.dart';
import 'package:dictionarydox/src/core/error/exceptions.dart';
import 'package:dictionarydox/src/core/error/failures.dart';
import 'package:dictionarydox/src/data/datasources/remote/pexels_remote_datasource.dart';
import 'package:dictionarydox/src/domain/repositories/image_repository.dart';

class ImageRepositoryImpl implements ImageRepository {
  final PexelsRemoteDataSource remoteDataSource;

  ImageRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<String>>> searchImages(String query) async {
    try {
      final result = await remoteDataSource.searchImages(query);
      return Right(result);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
