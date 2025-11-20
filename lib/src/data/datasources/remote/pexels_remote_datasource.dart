import 'package:dictionarydox/src/core/error/exceptions.dart';
import 'package:dictionarydox/src/core/utils/platform_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:universal_html/html.dart' as html;

abstract class PexelsRemoteDataSource {
  Future<List<String>> searchImages(String query);
}

class PexelsRemoteDataSourceImpl implements PexelsRemoteDataSource {
  final Dio dio;
  static const String baseUrl = 'https://api.pexels.com/v1';

  String get apiKey {
    // Try to get API key from environment variables
    // On mobile/desktop, get from .env file
    String key = dotenv.env['PEXELS_API_KEY'] ?? '';
    
    // If empty on web, try to get from window.flutterEnv (injected via index.html)
    if (PlatformUtils.isWeb && key.isEmpty) {
      try {
        final window = html.window as dynamic;
        if (window.flutterEnv != null) {
          final env = window.flutterEnv as Map<String, dynamic>;
          final webKey = env['PEXELS_API_KEY'];
          if (webKey != null && webKey.toString().isNotEmpty) {
            key = webKey.toString();
          }
        }
      } catch (e) {
        // Ignore errors when accessing window.flutterEnv
      }
    }
    
    return key;
  }

  PexelsRemoteDataSourceImpl(this.dio);

  @override
  Future<List<String>> searchImages(String query) async {
    // Check if API key is available
    final key = apiKey;
    if (key.isEmpty) {
      throw NetworkException(
        'Pexels API key is not configured. Please set PEXELS_API_KEY environment variable. '
        'For web, add it to Netlify environment variables or index.html.',
      );
    }

    try {
      // Build headers - only include Authorization if key is not empty
      final headers = <String, dynamic>{
        'Authorization': key,
      };

      final response = await dio.get(
        '$baseUrl/search',
        queryParameters: {
          'query': query,
          'per_page': 20,
        },
        options: Options(
          headers: headers,
          // Add CORS headers for web
          followRedirects: true,
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        final photos = response.data['photos'] as List;
        return photos.map((photo) => photo['src']['medium'] as String).toList();
      }

      // Handle 401 Unauthorized
      if (response.statusCode == 401) {
        throw NetworkException(
          'Invalid Pexels API key. Please check your PEXELS_API_KEY configuration.',
        );
      }

      // Handle other errors
      if (response.statusCode != null && response.statusCode! >= 400) {
        throw NetworkException(
          'Pexels API error: ${response.statusCode} - ${response.statusMessage ?? "Unknown error"}',
        );
      }

      return [];
    } on DioException catch (e) {
      // Handle network errors more specifically
      if (e.type == DioExceptionType.connectionError) {
        throw NetworkException(
          'Failed to connect to Pexels API. Please check your internet connection.',
        );
      } else if (e.type == DioExceptionType.connectionTimeout) {
        throw NetworkException(
          'Connection to Pexels API timed out. Please try again.',
        );
      } else if (e.response != null) {
        throw NetworkException(
          'Pexels API error: ${e.response?.statusCode} - ${e.response?.statusMessage ?? e.message}',
        );
      }
      throw NetworkException('Failed to search images: ${e.message}');
    } catch (e) {
      if (e is NetworkException) {
        rethrow;
      }
      throw ServerException('Unexpected error: $e');
    }
  }
}
