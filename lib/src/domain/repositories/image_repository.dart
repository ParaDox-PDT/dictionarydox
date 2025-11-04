import 'package:dartz/dartz.dart';
import 'package:dictionarydox/src/core/error/failures.dart';

/// Abstract repository for image search operations
abstract class ImageRepository {
  Future<Either<Failure, List<String>>> searchImages(String query);
}
