import 'package:dictionarydox/src/core/error/exceptions.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract class PexelsRemoteDataSource {
  Future<List<String>> searchImages(String query);
}

class PexelsRemoteDataSourceImpl implements PexelsRemoteDataSource {
  final Dio dio;
  static const String baseUrl = 'https://api.pexels.com/v1';

  String get apiKey => dotenv.env['PEXELS_API_KEY'] ?? '';

  PexelsRemoteDataSourceImpl(this.dio);

  @override
  Future<List<String>> searchImages(String query) async {
    try {
      final response = await dio.get(
        '$baseUrl/search',
        queryParameters: {
          'query': query,
          'per_page': 20,
        },
        options: Options(
          headers: {
            'Authorization': apiKey,
          },
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        final photos = response.data['photos'] as List;
        return photos.map((photo) => photo['src']['medium'] as String).toList();
      }

      return [];
    } on DioException catch (e) {
      throw NetworkException('Failed to search images: ${e.message}');
    } catch (e) {
      throw ServerException('Unexpected error: $e');
    }
  }
}
