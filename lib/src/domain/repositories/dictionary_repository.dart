import 'package:dartz/dartz.dart';
import 'package:dictionarydox/src/core/error/failures.dart';

/// Result from validating a word via Dictionary API
class ValidationResult {
  final bool isValid;
  final String? phonetic;
  final String? audioUrl;
  final List<String> definitions;

  const ValidationResult({
    required this.isValid,
    this.phonetic,
    this.audioUrl,
    this.definitions = const [],
  });
}

/// Abstract repository for dictionary API operations
abstract class DictionaryRepository {
  Future<Either<Failure, ValidationResult>> validateWord(String word);
}
