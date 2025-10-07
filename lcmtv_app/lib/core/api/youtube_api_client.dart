import 'dart:convert';
import 'package:dio/dio.dart';
import '../models/youtube_video_model.dart';
import '../models/category_model.dart';
import '../config/app_config.dart';

class YouTubeApiClient {
  static const String _baseUrl = 'https://www.googleapis.com/youtube/v3';
  late final Dio _dio;
  
  // Rate limiting and quota management
  static const int _quotaLimit = 10000;
  static int _currentQuota = 0;
  
  YouTubeApiClient() {
    _dio = Dio(BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
      },
    ));
    
    // Add interceptors for logging and error handling
    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      logPrint: (obj) => print('YouTube API: $obj'),
    ));
  }
  
  // Trending videos with category filtering
  Future<List<YouTubeVideoModel>> getTrendingVideos({
    String? categoryId,
    String? regionCode = 'US',
    int maxResults = 25,
  }) async {
    try {
      _checkQuotaLimit();
      
      final response = await _dio.get('/videos', queryParameters: {
        'part': 'snippet,statistics,contentDetails',
        'chart': 'mostPopular',
        'regionCode': regionCode,
        'maxResults': maxResults,
        'key': AppConfig.youtubeApiKey,
        if (categoryId != null) 'videoCategoryId': categoryId,
      });
      
      _currentQuota += 1; // videos.list costs 1 unit
      
      if (response.statusCode == 200) {
        final List<dynamic> items = response.data['items'] ?? [];
        return items.map((item) => YouTubeVideoModel.fromJson(item)).toList();
      } else {
        throw YouTubeApiException('Failed to fetch trending videos: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw YouTubeApiException('Network error: ${e.message}');
    } catch (e) {
      throw YouTubeApiException('Unexpected error: $e');
    }
  }
  
  // Live streams detection
  Future<List<YouTubeVideoModel>> getLiveStreams({
    String? categoryId,
    int maxResults = 25,
  }) async {
    try {
      _checkQuotaLimit();
      
      final response = await _dio.get('/search', queryParameters: {
        'part': 'snippet',
        'eventType': 'live',
        'type': 'video',
        'order': 'viewCount',
        'maxResults': maxResults,
        'key': AppConfig.youtubeApiKey,
        if (categoryId != null) 'videoCategoryId': categoryId,
      });
      
      _currentQuota += 100; // search.list costs 100 units
      
      if (response.statusCode == 200) {
        final List<dynamic> items = response.data['items'] ?? [];
        return items.map((item) => YouTubeVideoModel.fromJson(item)).toList();
      } else {
        throw YouTubeApiException('Failed to fetch live streams: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw YouTubeApiException('Network error: ${e.message}');
    } catch (e) {
      throw YouTubeApiException('Unexpected error: $e');
    }
  }
  
  // Video search with advanced filters
  Future<List<YouTubeVideoModel>> searchVideos({
    required String query,
    String? categoryId,
    String? order = 'relevance',
    String? publishedAfter,
    String? publishedBefore,
    int maxResults = 25,
  }) async {
    try {
      _checkQuotaLimit();
      
      final response = await _dio.get('/search', queryParameters: {
        'part': 'snippet',
        'q': query,
        'type': 'video',
        'order': order,
        'maxResults': maxResults,
        'key': AppConfig.youtubeApiKey,
        if (categoryId != null) 'videoCategoryId': categoryId,
        if (publishedAfter != null) 'publishedAfter': publishedAfter,
        if (publishedBefore != null) 'publishedBefore': publishedBefore,
      });
      
      _currentQuota += 100; // search.list costs 100 units
      
      if (response.statusCode == 200) {
        final List<dynamic> items = response.data['items'] ?? [];
        return items.map((item) => YouTubeVideoModel.fromJson(item)).toList();
      } else {
        throw YouTubeApiException('Failed to search videos: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw YouTubeApiException('Network error: ${e.message}');
    } catch (e) {
      throw YouTubeApiException('Unexpected error: $e');
    }
  }
  
  // Get video details
  Future<YouTubeVideoModel> getVideoDetails(String videoId) async {
    try {
      _checkQuotaLimit();
      
      final response = await _dio.get('/videos', queryParameters: {
        'part': 'snippet,statistics,contentDetails',
        'id': videoId,
        'key': AppConfig.youtubeApiKey,
      });
      
      _currentQuota += 1; // videos.list costs 1 unit
      
      if (response.statusCode == 200) {
        final List<dynamic> items = response.data['items'] ?? [];
        if (items.isNotEmpty) {
          return YouTubeVideoModel.fromJson(items.first);
        } else {
          throw YouTubeApiException('Video not found');
        }
      } else {
        throw YouTubeApiException('Failed to fetch video details: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw YouTubeApiException('Network error: ${e.message}');
    } catch (e) {
      throw YouTubeApiException('Unexpected error: $e');
    }
  }
  
  // Get video categories
  Future<List<CategoryModel>> getCategories({String? regionCode = 'US'}) async {
    try {
      _checkQuotaLimit();
      
      final response = await _dio.get('/videoCategories', queryParameters: {
        'part': 'snippet',
        'regionCode': regionCode,
        'key': AppConfig.youtubeApiKey,
      });
      
      _currentQuota += 1; // videoCategories.list costs 1 unit
      
      if (response.statusCode == 200) {
        final List<dynamic> items = response.data['items'] ?? [];
        return items.map((item) => CategoryModel.fromJson(item)).toList();
      } else {
        throw YouTubeApiException('Failed to fetch categories: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw YouTubeApiException('Network error: ${e.message}');
    } catch (e) {
      throw YouTubeApiException('Unexpected error: $e');
    }
  }
  
  // Check quota limit
  void _checkQuotaLimit() {
    if (_currentQuota >= _quotaLimit) {
      throw YouTubeApiException('API quota exceeded. Please try again later.');
    }
  }
  
  // Reset quota (should be called daily)
  static void resetQuota() {
    _currentQuota = 0;
  }
  
  // Get current quota usage
  static int getCurrentQuota() {
    return _currentQuota;
  }
}

// Custom exception for YouTube API errors
class YouTubeApiException implements Exception {
  final String message;
  YouTubeApiException(this.message);
  
  @override
  String toString() => 'YouTubeApiException: $message';
}
