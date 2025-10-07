import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/app_config.dart';
import '../models/youtube_video_model.dart';
import '../models/category_model.dart';

class CacheManager {
  static const String _trendingKey = 'trending_videos';
  static const String _categoriesKey = 'video_categories';
  static const String _liveStreamsKey = 'live_streams';
  static const String _searchPrefix = 'search_';
  
  final SharedPreferences _prefs;
  final Duration _cacheExpiry = AppConfig.cacheExpiry;
  final Duration _trendingCacheExpiry = AppConfig.trendingCacheExpiry;
  final Duration _liveStreamsCacheExpiry = AppConfig.liveStreamsCacheExpiry;
  
  CacheManager(this._prefs);
  
  // Trending Videos Cache
  Future<void> cacheTrendingVideos(List<YouTubeVideoModel> videos) async {
    final cacheData = {
      'videos': videos.map((v) => v.toJson()).toList(),
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };
    await _prefs.setString(_trendingKey, jsonEncode(cacheData));
  }
  
  Future<List<YouTubeVideoModel>?> getCachedTrendingVideos() async {
    final cached = _prefs.getString(_trendingKey);
    if (cached != null) {
      try {
        final data = jsonDecode(cached);
        final timestamp = DateTime.fromMillisecondsSinceEpoch(data['timestamp']);
        
        if (DateTime.now().difference(timestamp) < _trendingCacheExpiry) {
          final videosJson = data['videos'] as List;
          return videosJson.map((v) => YouTubeVideoModel.fromJson(v)).toList();
        }
      } catch (e) {
        // Invalid cache data, remove it
        await _prefs.remove(_trendingKey);
      }
    }
    return null;
  }
  
  // Live Streams Cache
  Future<void> cacheLiveStreams(List<YouTubeVideoModel> streams) async {
    final cacheData = {
      'streams': streams.map((s) => s.toJson()).toList(),
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };
    await _prefs.setString(_liveStreamsKey, jsonEncode(cacheData));
  }
  
  Future<List<YouTubeVideoModel>?> getCachedLiveStreams() async {
    final cached = _prefs.getString(_liveStreamsKey);
    if (cached != null) {
      try {
        final data = jsonDecode(cached);
        final timestamp = DateTime.fromMillisecondsSinceEpoch(data['timestamp']);
        
        if (DateTime.now().difference(timestamp) < _liveStreamsCacheExpiry) {
          final streamsJson = data['streams'] as List;
          return streamsJson.map((s) => YouTubeVideoModel.fromJson(s)).toList();
        }
      } catch (e) {
        // Invalid cache data, remove it
        await _prefs.remove(_liveStreamsKey);
      }
    }
    return null;
  }
  
  // Categories Cache
  Future<void> cacheCategories(List<CategoryModel> categories) async {
    final cacheData = {
      'categories': categories.map((c) => c.toJson()).toList(),
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };
    await _prefs.setString(_categoriesKey, jsonEncode(cacheData));
  }
  
  Future<List<CategoryModel>?> getCachedCategories() async {
    final cached = _prefs.getString(_categoriesKey);
    if (cached != null) {
      try {
        final data = jsonDecode(cached);
        final timestamp = DateTime.fromMillisecondsSinceEpoch(data['timestamp']);
        
        if (DateTime.now().difference(timestamp) < _cacheExpiry) {
          final categoriesJson = data['categories'] as List;
          return categoriesJson.map((c) => CategoryModel.fromJson(c)).toList();
        }
      } catch (e) {
        // Invalid cache data, remove it
        await _prefs.remove(_categoriesKey);
      }
    }
    return null;
  }
  
  // Search Results Cache
  Future<void> cacheSearchResults(String query, List<YouTubeVideoModel> results) async {
    final cacheKey = '$_searchPrefix${_hashQuery(query)}';
    final cacheData = {
      'results': results.map((r) => r.toJson()).toList(),
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };
    await _prefs.setString(cacheKey, jsonEncode(cacheData));
  }
  
  Future<List<YouTubeVideoModel>?> getCachedSearchResults(String query) async {
    final cacheKey = '$_searchPrefix${_hashQuery(query)}';
    final cached = _prefs.getString(cacheKey);
    if (cached != null) {
      try {
        final data = jsonDecode(cached);
        final timestamp = DateTime.fromMillisecondsSinceEpoch(data['timestamp']);
        
        if (DateTime.now().difference(timestamp) < _cacheExpiry) {
          final resultsJson = data['results'] as List;
          return resultsJson.map((r) => YouTubeVideoModel.fromJson(r)).toList();
        }
      } catch (e) {
        // Invalid cache data, remove it
        await _prefs.remove(cacheKey);
      }
    }
    return null;
  }
  
  // Video Details Cache
  Future<void> cacheVideoDetails(String videoId, YouTubeVideoModel video) async {
    final cacheKey = 'video_$videoId';
    final cacheData = {
      'video': video.toJson(),
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };
    await _prefs.setString(cacheKey, jsonEncode(cacheData));
  }
  
  Future<YouTubeVideoModel?> getCachedVideoDetails(String videoId) async {
    final cacheKey = 'video_$videoId';
    final cached = _prefs.getString(cacheKey);
    if (cached != null) {
      try {
        final data = jsonDecode(cached);
        final timestamp = DateTime.fromMillisecondsSinceEpoch(data['timestamp']);
        
        if (DateTime.now().difference(timestamp) < _cacheExpiry) {
          return YouTubeVideoModel.fromJson(data['video']);
        }
      } catch (e) {
        // Invalid cache data, remove it
        await _prefs.remove(cacheKey);
      }
    }
    return null;
  }
  
  // User Preferences Cache
  Future<void> cacheUserPreferences(Map<String, dynamic> preferences) async {
    await _prefs.setString('user_preferences', jsonEncode(preferences));
  }
  
  Future<Map<String, dynamic>?> getCachedUserPreferences() async {
    final cached = _prefs.getString('user_preferences');
    if (cached != null) {
      try {
        return jsonDecode(cached);
      } catch (e) {
        await _prefs.remove('user_preferences');
      }
    }
    return null;
  }
  
  // Watch History Cache
  Future<void> cacheWatchHistory(List<String> videoIds) async {
    await _prefs.setStringList('watch_history', videoIds);
  }
  
  Future<List<String>?> getCachedWatchHistory() async {
    return _prefs.getStringList('watch_history');
  }
  
  // Liked Videos Cache
  Future<void> cacheLikedVideos(List<String> videoIds) async {
    await _prefs.setStringList('liked_videos', videoIds);
  }
  
  Future<List<String>?> getCachedLikedVideos() async {
    return _prefs.getStringList('liked_videos');
  }
  
  // Clear specific cache
  Future<void> clearTrendingCache() async {
    await _prefs.remove(_trendingKey);
  }
  
  Future<void> clearLiveStreamsCache() async {
    await _prefs.remove(_liveStreamsKey);
  }
  
  Future<void> clearCategoriesCache() async {
    await _prefs.remove(_categoriesKey);
  }
  
  Future<void> clearSearchCache() async {
    final keys = _prefs.getKeys().where((key) => key.startsWith(_searchPrefix));
    for (final key in keys) {
      await _prefs.remove(key);
    }
  }
  
  Future<void> clearVideoDetailsCache() async {
    final keys = _prefs.getKeys().where((key) => key.startsWith('video_'));
    for (final key in keys) {
      await _prefs.remove(key);
    }
  }
  
  // Clear all cache
  Future<void> clearAllCache() async {
    await clearTrendingCache();
    await clearLiveStreamsCache();
    await clearCategoriesCache();
    await clearSearchCache();
    await clearVideoDetailsCache();
  }
  
  // Get cache size info
  Future<Map<String, dynamic>> getCacheInfo() async {
    final keys = _prefs.getKeys();
    int totalSize = 0;
    int itemCount = 0;
    
    for (final key in keys) {
      if (key.startsWith(_searchPrefix) || 
          key.startsWith('video_') || 
          key == _trendingKey || 
          key == _liveStreamsKey || 
          key == _categoriesKey) {
        final value = _prefs.getString(key);
        if (value != null) {
          totalSize += value.length;
          itemCount++;
        }
      }
    }
    
    return {
      'totalSize': totalSize,
      'itemCount': itemCount,
      'trendingCached': _prefs.containsKey(_trendingKey),
      'liveStreamsCached': _prefs.containsKey(_liveStreamsKey),
      'categoriesCached': _prefs.containsKey(_categoriesKey),
    };
  }
  
  // Helper method to hash query for cache key
  String _hashQuery(String query) {
    return query.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '_');
  }
}
