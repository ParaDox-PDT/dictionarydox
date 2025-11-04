import 'package:dartz/dartz.dart';
import 'package:dictionarydox/src/core/error/failures.dart';
import 'package:dictionarydox/src/domain/repositories/image_repository.dart';

class SearchImages {
  final ImageRepository repository;

  SearchImages(this.repository);

  Future<Either<Failure, List<String>>> call(String query) async {
    return await repository.searchImages(query);
  }
}
