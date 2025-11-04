import 'package:dictionarydox/src/core/error/exceptions.dart';
import 'package:dictionarydox/src/domain/repositories/dictionary_repository.dart';
import 'package:dio/dio.dart';

abstract class DictionaryRemoteDataSource {
  Future<ValidationResult> validateWord(String word);
}

class DictionaryRemoteDataSourceImpl implements DictionaryRemoteDataSource {
  final Dio dio;
  static const String baseUrl =
      'https://api.dictionaryapi.dev/api/v2/entries/en';

  DictionaryRemoteDataSourceImpl(this.dio);

  @override
  Future<ValidationResult> validateWord(String word) async {
    try {
      final response = await dio.get('$baseUrl/$word');

      if (response.statusCode == 200 &&
          response.data is List &&
          response.data.isNotEmpty) {
        final data = response.data[0];

        // Extract phonetic
        String? phonetic;
        if (data['phonetic'] != null) {
          phonetic = data['phonetic'];
        }

        // Extract audio URL from phonetics array
        String? audioUrl;
        if (data['phonetics'] != null && data['phonetics'] is List) {
          for (var phoneticEntry in data['phonetics']) {
            if (phoneticEntry['audio'] != null &&
                phoneticEntry['audio'].toString().isNotEmpty) {
              audioUrl = phoneticEntry['audio'];
              // Also try to get phonetic text from here if not found earlier
              if (phonetic == null && phoneticEntry['text'] != null) {
                phonetic = phoneticEntry['text'];
              }
              break;
            }
          }
        }

        // Extract definitions
        List<String> definitions = [];
        if (data['meanings'] != null && data['meanings'] is List) {
          for (var meaning in data['meanings']) {
            if (meaning['definitions'] != null &&
                meaning['definitions'] is List) {
              for (var def in meaning['definitions']) {
                if (def['definition'] != null) {
                  definitions.add(def['definition']);
                  if (definitions.length >= 3) break; // Limit to 3 definitions
                }
              }
              if (definitions.length >= 3) break;
            }
          }
        }

        return ValidationResult(
          isValid: true,
          phonetic: phonetic,
          audioUrl: audioUrl,
          definitions: definitions,
        );
      }

      return const ValidationResult(isValid: false);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return const ValidationResult(isValid: false);
      }
      throw NetworkException('Failed to validate word: ${e.message}');
    } catch (e) {
      throw ServerException('Unexpected error: $e');
    }
  }
}
