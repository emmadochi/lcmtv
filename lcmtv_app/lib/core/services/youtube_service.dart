import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config/app_config.dart';

class YouTubeService {
  static const String _baseUrl = 'https://www.googleapis.com/youtube/v3';
  static String? _apiKey;

  static void initialize({required String apiKey}) {
    _apiKey = apiKey;
  }

  // ============================================================================
  // SEARCH FUNCTIONALITY
  // ============================================================================

  /// Search for videos
  static Future<List<Map<String, dynamic>>> searchVideos({
    required String query,
    String? categoryId,
    int maxResults = 25,
    String order = 'relevance',
    String? publishedAfter,
    String? publishedBefore,
  }) async {
    if (_apiKey == null) throw Exception('YouTube API key not initialized');

    final params = {
      'part': 'snippet',
      'q': query,
      'type': 'video',
      'maxResults': maxResults.toString(),
      'order': order,
      'key': _apiKey!,
      'videoDefinition': 'high',
      'videoDuration': 'any',
    };

    if (categoryId != null) params['videoCategoryId'] = categoryId;
    if (publishedAfter != null) params['publishedAfter'] = publishedAfter;
    if (publishedBefore != null) params['publishedBefore'] = publishedBefore;

    final uri = Uri.parse('$_baseUrl/search').replace(queryParameters: params);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return _parseSearchResults(data);
    } else {
      throw Exception('Failed to search videos: ${response.statusCode}');
    }
  }

  /// Get trending videos
  static Future<List<Map<String, dynamic>>> getTrendingVideos({
    String? categoryId,
    String? regionCode = 'US',
    int maxResults = 25,
  }) async {
    if (_apiKey == null) throw Exception('YouTube API key not initialized');

    final params = {
      'part': 'snippet,statistics,contentDetails',
      'chart': 'mostPopular',
      'regionCode': regionCode!,
      'maxResults': maxResults.toString(),
      'key': _apiKey!,
    };

    if (categoryId != null) params['videoCategoryId'] = categoryId;

    final uri = Uri.parse('$_baseUrl/videos').replace(queryParameters: params);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return _parseVideoResults(data);
    } else {
      throw Exception('Failed to get trending videos: ${response.statusCode}');
    }
  }

  /// Get video details
  static Future<Map<String, dynamic>?> getVideoDetails(String videoId) async {
    if (_apiKey == null) throw Exception('YouTube API key not initialized');

    final params = {
      'part': 'snippet,statistics,contentDetails',
      'id': videoId,
      'key': _apiKey!,
    };

    final uri = Uri.parse('$_baseUrl/videos').replace(queryParameters: params);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['items'] != null && data['items'].isNotEmpty) {
        return _parseVideoDetails(data['items'][0]);
      }
    }
    return null;
  }

  /// Get channel details
  static Future<Map<String, dynamic>?> getChannelDetails(String channelId) async {
    if (_apiKey == null) throw Exception('YouTube API key not initialized');

    final params = {
      'part': 'snippet,statistics',
      'id': channelId,
      'key': _apiKey!,
    };

    final uri = Uri.parse('$_baseUrl/channels').replace(queryParameters: params);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['items'] != null && data['items'].isNotEmpty) {
        return _parseChannelDetails(data['items'][0]);
      }
    }
    return null;
  }

  /// Get video categories
  static Future<List<Map<String, dynamic>>> getVideoCategories({
    String regionCode = 'US',
  }) async {
    if (_apiKey == null) throw Exception('YouTube API key not initialized');

    final params = {
      'part': 'snippet',
      'regionCode': regionCode,
      'key': _apiKey!,
    };

    final uri = Uri.parse('$_baseUrl/videoCategories').replace(queryParameters: params);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return _parseCategories(data);
    } else {
      throw Exception('Failed to get categories: ${response.statusCode}');
    }
  }

  // ============================================================================
  // LIVE STREAMS
  // ============================================================================

  /// Get live streams
  static Future<List<Map<String, dynamic>>> getLiveStreams({
    String? categoryId,
    int maxResults = 25,
  }) async {
    if (_apiKey == null) throw Exception('YouTube API key not initialized');

    final params = {
      'part': 'snippet',
      'eventType': 'live',
      'type': 'video',
      'maxResults': maxResults.toString(),
      'key': _apiKey!,
    };

    if (categoryId != null) params['videoCategoryId'] = categoryId;

    final uri = Uri.parse('$_baseUrl/search').replace(queryParameters: params);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return _parseSearchResults(data);
    } else {
      throw Exception('Failed to get live streams: ${response.statusCode}');
    }
  }

  // ============================================================================
  // PARSING METHODS
  // ============================================================================

  static List<Map<String, dynamic>> _parseSearchResults(Map<String, dynamic> data) {
    final List<Map<String, dynamic>> videos = [];
    
    if (data['items'] != null) {
      for (var item in data['items']) {
        videos.add({
          'id': item['id']['videoId'],
          'title': item['snippet']['title'],
          'description': item['snippet']['description'],
          'channelId': item['snippet']['channelId'],
          'channelTitle': item['snippet']['channelTitle'],
          'thumbnailUrl': _getBestThumbnail(item['snippet']['thumbnails']),
          'publishedAt': item['snippet']['publishedAt'],
          'categoryId': item['snippet'].containsKey('categoryId') 
              ? item['snippet']['categoryId'] 
              : null,
        });
      }
    }
    
    return videos;
  }

  static List<Map<String, dynamic>> _parseVideoResults(Map<String, dynamic> data) {
    final List<Map<String, dynamic>> videos = [];
    
    if (data['items'] != null) {
      for (var item in data['items']) {
        videos.add(_parseVideoDetails(item));
      }
    }
    
    return videos;
  }

  static Map<String, dynamic> _parseVideoDetails(Map<String, dynamic> item) {
    final snippet = item['snippet'];
    final statistics = item['statistics'] ?? {};
    final contentDetails = item['contentDetails'] ?? {};
    
    return {
      'id': item['id'],
      'title': snippet['title'],
      'description': snippet['description'],
      'channelId': snippet['channelId'],
      'channelTitle': snippet['channelTitle'],
      'thumbnailUrl': _getBestThumbnail(snippet['thumbnails']),
      'publishedAt': snippet['publishedAt'],
      'categoryId': snippet['categoryId'],
      'tags': snippet['tags'] ?? [],
      'duration': contentDetails['duration'],
      'viewCount': int.tryParse(statistics['viewCount'] ?? '0') ?? 0,
      'likeCount': int.tryParse(statistics['likeCount'] ?? '0') ?? 0,
      'commentCount': int.tryParse(statistics['commentCount'] ?? '0') ?? 0,
    };
  }

  static Map<String, dynamic> _parseChannelDetails(Map<String, dynamic> item) {
    final snippet = item['snippet'];
    final statistics = item['statistics'] ?? {};
    
    return {
      'id': item['id'],
      'title': snippet['title'],
      'description': snippet['description'],
      'thumbnailUrl': _getBestThumbnail(snippet['thumbnails']),
      'subscriberCount': int.tryParse(statistics['subscriberCount'] ?? '0') ?? 0,
      'videoCount': int.tryParse(statistics['videoCount'] ?? '0') ?? 0,
      'viewCount': int.tryParse(statistics['viewCount'] ?? '0') ?? 0,
    };
  }

  static List<Map<String, dynamic>> _parseCategories(Map<String, dynamic> data) {
    final List<Map<String, dynamic>> categories = [];
    
    if (data['items'] != null) {
      for (var item in data['items']) {
        categories.add({
          'id': item['id'],
          'title': item['snippet']['title'],
          'assignable': item['snippet']['assignable'],
        });
      }
    }
    
    return categories;
  }

  static String _getBestThumbnail(Map<String, dynamic> thumbnails) {
    // Priority: maxres > high > medium > default
    if (thumbnails['maxres'] != null) return thumbnails['maxres']['url'];
    if (thumbnails['high'] != null) return thumbnails['high']['url'];
    if (thumbnails['medium'] != null) return thumbnails['medium']['url'];
    if (thumbnails['default'] != null) return thumbnails['default']['url'];
    return '';
  }

  // ============================================================================
  // ERROR HANDLING
  // ============================================================================

  static String _handleError(int statusCode) {
    switch (statusCode) {
      case 400:
        return 'Bad Request - Invalid parameters';
      case 401:
        return 'Unauthorized - Invalid API key';
      case 403:
        return 'Forbidden - API quota exceeded';
      case 404:
        return 'Not Found - Resource not found';
      case 500:
        return 'Internal Server Error';
      default:
        return 'Unknown error: $statusCode';
    }
  }
}
