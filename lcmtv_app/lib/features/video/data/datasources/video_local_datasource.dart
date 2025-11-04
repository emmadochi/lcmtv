import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../../../core/models/video_metadata_model.dart';
import '../../../../core/models/category_model.dart';

abstract class VideoLocalDataSource {
  Future<List<VideoMetadata>> getCachedSearchResults(String query);
  Future<void> cacheSearchResults(String query, List<VideoMetadata> videos);
  Future<List<VideoMetadata>> getCachedTrendingVideos();
  Future<void> cacheTrendingVideos(List<VideoMetadata> videos);
  Future<List<VideoMetadata>> getCachedLiveStreams();
  Future<void> cacheLiveStreams(List<VideoMetadata> videos);
  Future<VideoMetadata?> getCachedVideo(String videoId);
  Future<void> cacheVideo(VideoMetadata video);
  Future<List<CategoryModel>> getCachedCategories();
  Future<void> cacheCategories(List<CategoryModel> categories);
  Future<void> clearCache();
}

class VideoLocalDataSourceImpl implements VideoLocalDataSource {
  final SharedPreferences _prefs;

  VideoLocalDataSourceImpl({required SharedPreferences prefs}) : _prefs = prefs;

  // ============================================================================
  // SEARCH RESULTS CACHING
  // ============================================================================

  @override
  Future<List<VideoMetadata>> getCachedSearchResults(String query) async {
    try {
      final cacheKey = 'search_results_${query.hashCode}';
      final cachedData = _prefs.getString(cacheKey);
      
      if (cachedData != null) {
        final List<dynamic> jsonList = json.decode(cachedData);
        return jsonList.map((json) => VideoMetadata.fromJson(json)).toList();
      }
      
      return [];
    } catch (e) {
      print('❌ Error getting cached search results: $e');
      return [];
    }
  }

  @override
  Future<void> cacheSearchResults(String query, List<VideoMetadata> videos) async {
    try {
      final cacheKey = 'search_results_${query.hashCode}';
      final jsonList = videos.map((video) => video.toJson()).toList();
      await _prefs.setString(cacheKey, json.encode(jsonList));
    } catch (e) {
      print('❌ Error caching search results: $e');
    }
  }

  // ============================================================================
  // TRENDING VIDEOS CACHING
  // ============================================================================

  @override
  Future<List<VideoMetadata>> getCachedTrendingVideos() async {
    try {
      final cachedData = _prefs.getString('trending_videos');
      
      if (cachedData != null) {
        final List<dynamic> jsonList = json.decode(cachedData);
        return jsonList.map((json) => VideoMetadata.fromJson(json)).toList();
      }
      
      return [];
    } catch (e) {
      print('❌ Error getting cached trending videos: $e');
      return [];
    }
  }

  @override
  Future<void> cacheTrendingVideos(List<VideoMetadata> videos) async {
    try {
      final jsonList = videos.map((video) => video.toJson()).toList();
      await _prefs.setString('trending_videos', json.encode(jsonList));
    } catch (e) {
      print('❌ Error caching trending videos: $e');
    }
  }

  // ============================================================================
  // LIVE STREAMS CACHING
  // ============================================================================

  @override
  Future<List<VideoMetadata>> getCachedLiveStreams() async {
    try {
      final cachedData = _prefs.getString('live_streams');
      
      if (cachedData != null) {
        final List<dynamic> jsonList = json.decode(cachedData);
        return jsonList.map((json) => VideoMetadata.fromJson(json)).toList();
      }
      
      return [];
    } catch (e) {
      print('❌ Error getting cached live streams: $e');
      return [];
    }
  }

  @override
  Future<void> cacheLiveStreams(List<VideoMetadata> videos) async {
    try {
      final jsonList = videos.map((video) => video.toJson()).toList();
      await _prefs.setString('live_streams', json.encode(jsonList));
    } catch (e) {
      print('❌ Error caching live streams: $e');
    }
  }

  // ============================================================================
  // INDIVIDUAL VIDEO CACHING
  // ============================================================================

  @override
  Future<VideoMetadata?> getCachedVideo(String videoId) async {
    try {
      final cacheKey = 'video_$videoId';
      final cachedData = _prefs.getString(cacheKey);
      
      if (cachedData != null) {
        final jsonData = json.decode(cachedData);
        return VideoMetadata.fromJson(jsonData);
      }
      
      return null;
    } catch (e) {
      print('❌ Error getting cached video: $e');
      return null;
    }
  }

  @override
  Future<void> cacheVideo(VideoMetadata video) async {
    try {
      final cacheKey = 'video_${video.id}';
      await _prefs.setString(cacheKey, json.encode(video.toJson()));
    } catch (e) {
      print('❌ Error caching video: $e');
    }
  }

  // ============================================================================
  // CATEGORIES CACHING
  // ============================================================================

  @override
  Future<List<CategoryModel>> getCachedCategories() async {
    try {
      final cachedData = _prefs.getString('categories');
      
      if (cachedData != null) {
        final List<dynamic> jsonList = json.decode(cachedData);
        return jsonList.map((json) => CategoryModel.fromJson(json)).toList();
      }
      
      return [];
    } catch (e) {
      print('❌ Error getting cached categories: $e');
      return [];
    }
  }

  @override
  Future<void> cacheCategories(List<CategoryModel> categories) async {
    try {
      final jsonList = categories.map((category) => category.toJson()).toList();
      await _prefs.setString('categories', json.encode(jsonList));
    } catch (e) {
      print('❌ Error caching categories: $e');
    }
  }

  // ============================================================================
  // CACHE MANAGEMENT
  // ============================================================================

  @override
  Future<void> clearCache() async {
    try {
      final keys = _prefs.getKeys();
      final videoKeys = keys.where((key) => 
        key.startsWith('video_') || 
        key.startsWith('search_results_') ||
        key == 'trending_videos' ||
        key == 'live_streams' ||
        key == 'categories'
      );
      
      for (final key in videoKeys) {
        await _prefs.remove(key);
      }
    } catch (e) {
      print('❌ Error clearing cache: $e');
    }
  }

  // ============================================================================
  // CACHE EXPIRY MANAGEMENT
  // ============================================================================

  Future<bool> _isCacheExpired(String cacheKey, Duration maxAge) async {
    try {
      final timestampKey = '${cacheKey}_timestamp';
      final timestamp = _prefs.getInt(timestampKey);
      
      if (timestamp == null) return true;
      
      final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      final now = DateTime.now();
      
      return now.difference(cacheTime) > maxAge;
    } catch (e) {
      return true;
    }
  }

  Future<void> _setCacheTimestamp(String cacheKey) async {
    try {
      final timestampKey = '${cacheKey}_timestamp';
      await _prefs.setInt(timestampKey, DateTime.now().millisecondsSinceEpoch);
    } catch (e) {
      print('❌ Error setting cache timestamp: $e');
    }
  }

  // ============================================================================
  // SMART CACHING WITH EXPIRY
  // ============================================================================

  Future<List<VideoMetadata>> getCachedSearchResultsWithExpiry(
    String query, {
    Duration maxAge = const Duration(hours: 1),
  }) async {
    final cacheKey = 'search_results_${query.hashCode}';
    
    if (await _isCacheExpired(cacheKey, maxAge)) {
      return [];
    }
    
    return await getCachedSearchResults(query);
  }

  Future<List<VideoMetadata>> getCachedTrendingVideosWithExpiry({
    Duration maxAge = const Duration(minutes: 30),
  }) async {
    const cacheKey = 'trending_videos';
    
    if (await _isCacheExpired(cacheKey, maxAge)) {
      return [];
    }
    
    return await getCachedTrendingVideos();
  }

  Future<List<VideoMetadata>> getCachedLiveStreamsWithExpiry({
    Duration maxAge = const Duration(minutes: 5),
  }) async {
    const cacheKey = 'live_streams';
    
    if (await _isCacheExpired(cacheKey, maxAge)) {
      return [];
    }
    
    return await getCachedLiveStreams();
  }

  Future<VideoMetadata?> getCachedVideoWithExpiry(
    String videoId, {
    Duration maxAge = const Duration(hours: 24),
  }) async {
    final cacheKey = 'video_$videoId';
    
    if (await _isCacheExpired(cacheKey, maxAge)) {
      return null;
    }
    
    return await getCachedVideo(videoId);
  }

  Future<List<CategoryModel>> getCachedCategoriesWithExpiry({
    Duration maxAge = const Duration(days: 7),
  }) async {
    const cacheKey = 'categories';
    
    if (await _isCacheExpired(cacheKey, maxAge)) {
      return [];
    }
    
    return await getCachedCategories();
  }
}
