import '../../../core/models/youtube_video_model.dart';
import '../../../core/models/category_model.dart';

abstract class VideoRepository {
  /// Get trending videos with optional category filtering
  Future<List<YouTubeVideoModel>> getTrendingVideos({
    String? categoryId,
    int maxResults = 25,
  });
  
  /// Get live streams with optional category filtering
  Future<List<YouTubeVideoModel>> getLiveStreams({
    String? categoryId,
    int maxResults = 25,
  });
  
  /// Search videos with advanced filters
  Future<List<YouTubeVideoModel>> searchVideos({
    required String query,
    String? categoryId,
    String? order = 'relevance',
    String? publishedAfter,
    String? publishedBefore,
    int maxResults = 25,
  });
  
  /// Get detailed information about a specific video
  Future<YouTubeVideoModel> getVideoDetails(String videoId);
  
  /// Get all available video categories
  Future<List<CategoryModel>> getCategories();
  
  /// Get videos by category
  Future<List<YouTubeVideoModel>> getVideosByCategory({
    required String categoryId,
    int maxResults = 25,
  });
  
  /// Get related videos for a specific video
  Future<List<YouTubeVideoModel>> getRelatedVideos({
    required String videoId,
    int maxResults = 25,
  });
  
  /// Get channel videos
  Future<List<YouTubeVideoModel>> getChannelVideos({
    required String channelId,
    int maxResults = 25,
  });
  
  /// Get popular videos in a specific region
  Future<List<YouTubeVideoModel>> getPopularVideos({
    String? regionCode,
    int maxResults = 25,
  });
  
  /// Clear cache
  Future<void> clearCache();
  
  /// Get cached trending videos
  Future<List<YouTubeVideoModel>?> getCachedTrendingVideos();
  
  /// Get cached live streams
  Future<List<YouTubeVideoModel>?> getCachedLiveStreams();
  
  /// Get cached categories
  Future<List<CategoryModel>?> getCachedCategories();
}
