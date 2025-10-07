import '../../../../core/api/youtube_api_client.dart';
import '../../../../core/models/youtube_video_model.dart';
import '../../../../core/models/category_model.dart';
import '../../../../core/cache/cache_manager.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/repositories/video_repository.dart';

class VideoRepositoryImpl implements VideoRepository {
  final YouTubeApiClient _apiClient;
  final CacheManager _cacheManager;
  final NetworkInfo _networkInfo;
  
  VideoRepositoryImpl({
    required YouTubeApiClient apiClient,
    required CacheManager cacheManager,
    required NetworkInfo networkInfo,
  }) : _apiClient = apiClient,
       _cacheManager = cacheManager,
       _networkInfo = networkInfo;
  
  @override
  Future<List<YouTubeVideoModel>> getTrendingVideos({
    String? categoryId,
    int maxResults = 25,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        final videos = await _apiClient.getTrendingVideos(
          categoryId: categoryId,
          maxResults: maxResults,
        );
        await _cacheManager.cacheTrendingVideos(videos);
        return videos;
      } catch (e) {
        // Fallback to cached data on error
        final cachedVideos = await _cacheManager.getCachedTrendingVideos();
        if (cachedVideos != null) {
          return cachedVideos;
        }
        rethrow;
      }
    } else {
      // Return cached data when offline
      final cachedVideos = await _cacheManager.getCachedTrendingVideos();
      if (cachedVideos != null) {
        return cachedVideos;
      }
      throw NetworkException('No internet connection and no cached data available');
    }
  }
  
  @override
  Future<List<YouTubeVideoModel>> getLiveStreams({
    String? categoryId,
    int maxResults = 25,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        final streams = await _apiClient.getLiveStreams(
          categoryId: categoryId,
          maxResults: maxResults,
        );
        await _cacheManager.cacheLiveStreams(streams);
        return streams;
      } catch (e) {
        // Fallback to cached data on error
        final cachedStreams = await _cacheManager.getCachedLiveStreams();
        if (cachedStreams != null) {
          return cachedStreams;
        }
        rethrow;
      }
    } else {
      // Return cached data when offline
      final cachedStreams = await _cacheManager.getCachedLiveStreams();
      if (cachedStreams != null) {
        return cachedStreams;
      }
      throw NetworkException('No internet connection and no cached data available');
    }
  }
  
  @override
  Future<List<YouTubeVideoModel>> searchVideos({
    required String query,
    String? categoryId,
    String? order = 'relevance',
    String? publishedAfter,
    String? publishedBefore,
    int maxResults = 25,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        final videos = await _apiClient.searchVideos(
          query: query,
          categoryId: categoryId,
          order: order,
          publishedAfter: publishedAfter,
          publishedBefore: publishedBefore,
          maxResults: maxResults,
        );
        await _cacheManager.cacheSearchResults(query, videos);
        return videos;
      } catch (e) {
        // Try to get cached search results
        final cachedResults = await _cacheManager.getCachedSearchResults(query);
        if (cachedResults != null) {
          return cachedResults;
        }
        rethrow;
      }
    } else {
      // Return cached search results when offline
      final cachedResults = await _cacheManager.getCachedSearchResults(query);
      if (cachedResults != null) {
        return cachedResults;
      }
      throw NetworkException('No internet connection and no cached search results available');
    }
  }
  
  @override
  Future<YouTubeVideoModel> getVideoDetails(String videoId) async {
    if (await _networkInfo.isConnected) {
      try {
        return await _apiClient.getVideoDetails(videoId);
      } catch (e) {
        rethrow;
      }
    } else {
      throw NetworkException('No internet connection');
    }
  }
  
  @override
  Future<List<CategoryModel>> getCategories() async {
    if (await _networkInfo.isConnected) {
      try {
        final categories = await _apiClient.getCategories();
        await _cacheManager.cacheCategories(categories);
        return categories;
      } catch (e) {
        // Fallback to cached data on error
        final cachedCategories = await _cacheManager.getCachedCategories();
        if (cachedCategories != null) {
          return cachedCategories;
        }
        rethrow;
      }
    } else {
      // Return cached data when offline
      final cachedCategories = await _cacheManager.getCachedCategories();
      if (cachedCategories != null) {
        return cachedCategories;
      }
      throw NetworkException('No internet connection and no cached categories available');
    }
  }
  
  @override
  Future<List<YouTubeVideoModel>> getVideosByCategory({
    required String categoryId,
    int maxResults = 25,
  }) async {
    return await getTrendingVideos(
      categoryId: categoryId,
      maxResults: maxResults,
    );
  }
  
  @override
  Future<List<YouTubeVideoModel>> getRelatedVideos({
    required String videoId,
    int maxResults = 25,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        // Get video details first to get the title for related search
        final videoDetails = await _apiClient.getVideoDetails(videoId);
        final relatedVideos = await _apiClient.searchVideos(
          query: videoDetails.title,
          maxResults: maxResults,
        );
        // Remove the original video from results
        return relatedVideos.where((video) => video.id != videoId).toList();
      } catch (e) {
        rethrow;
      }
    } else {
      throw NetworkException('No internet connection');
    }
  }
  
  @override
  Future<List<YouTubeVideoModel>> getChannelVideos({
    required String channelId,
    int maxResults = 25,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        // Search for videos from specific channel
        final videos = await _apiClient.searchVideos(
          query: 'channel:$channelId',
          maxResults: maxResults,
        );
        return videos;
      } catch (e) {
        rethrow;
      }
    } else {
      throw NetworkException('No internet connection');
    }
  }
  
  @override
  Future<List<YouTubeVideoModel>> getPopularVideos({
    String? regionCode,
    int maxResults = 25,
  }) async {
    return await getTrendingVideos(maxResults: maxResults);
  }
  
  @override
  Future<void> clearCache() async {
    await _cacheManager.clearAllCache();
  }
  
  @override
  Future<List<YouTubeVideoModel>?> getCachedTrendingVideos() async {
    return await _cacheManager.getCachedTrendingVideos();
  }
  
  @override
  Future<List<YouTubeVideoModel>?> getCachedLiveStreams() async {
    return await _cacheManager.getCachedLiveStreams();
  }
  
  @override
  Future<List<CategoryModel>?> getCachedCategories() async {
    return await _cacheManager.getCachedCategories();
  }
}

// Network exception for offline scenarios
class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);
  
  @override
  String toString() => 'NetworkException: $message';
}
